import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/news/news_model.dart';
import 'package:intl/intl.dart';

class AdminNewsScreen extends ConsumerStatefulWidget {
  const AdminNewsScreen({super.key});

  @override
  ConsumerState<AdminNewsScreen> createState() => _AdminNewsScreenState();
}

// Добавили SingleTickerProviderStateMixin для управления вкладками
class _AdminNewsScreenState extends ConsumerState<AdminNewsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  TargetAudience _selectedAudience = TargetAudience.all;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _publishNews() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все поля!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('news').add({
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim(),
        'targetAudience': _selectedAudience.name,
        'createdAt': FieldValue.serverTimestamp(),
        'isArchived': false,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Новость успешно опубликована! 🎉')),
      );

      _titleController.clear();
      _contentController.clear();

      // Теперь переключение работает через контроллер
      _tabController.animateTo(0);

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleArchive(NewsModel news, bool archive) async {
    await FirebaseFirestore.instance
        .collection('news')
        .doc(news.id)
        .update({'isArchived': archive});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Центр управления новостями'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Активные'),
            Tab(text: 'Создать'),
            Tab(text: 'Архив'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNewsList(false),
          _buildCreateTab(),
          _buildNewsList(true),
        ],
      ),
    );
  }

  Widget _buildNewsList(bool archived) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('news')
          .where('isArchived', isEqualTo: archived)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Center(child: Text('Ошибка: ${snapshot.error}'));
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final newsList = snapshot.data!.docs
            .map((doc) => NewsModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();

        if (newsList.isEmpty) {
          return Center(child: Text(archived ? 'Архив пуст' : 'Нет активных новостей'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: newsList.length,
          itemBuilder: (context, index) {
            final news = newsList[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(news.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(news.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Text(
                      '${DateFormat('dd.MM.yyyy').format(news.createdAt)} • ${news.targetAudience.name.toUpperCase()}',
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(archived ? Icons.unarchive : Icons.archive_outlined),
                  onPressed: () => _toggleArchive(news, !archived),
                  tooltip: archived ? 'Восстановить' : 'В архив',
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCreateTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Заголовок',
              border: OutlineInputBorder(),
            ),
            maxLength: 60,
          ),
          const SizedBox(height: 16),
          const Text('Кто увидит новость:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SegmentedButton<TargetAudience>(
            segments: const [
              ButtonSegment(value: TargetAudience.all, label: Text('Всем')),
              ButtonSegment(value: TargetAudience.guests, label: Text('Гостям')),
              ButtonSegment(value: TargetAudience.staff, label: Text('Персоналу')),
            ],
            selected: {_selectedAudience},
            onSelectionChanged: (Set<TargetAudience> newSelection) {
              setState(() => _selectedAudience = newSelection.first);
            },
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _contentController,
            decoration: const InputDecoration(
              labelText: 'Текст новости',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 8,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _isLoading ? null : _publishNews,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            child: _isLoading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Опубликовать', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}