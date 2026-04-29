import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/news/news_model.dart';
import 'package:hotel_app/features/news/widgets/news_details_dialog.dart';
import 'package:intl/intl.dart';

class AdminNewsScreen extends ConsumerStatefulWidget {
  final int initialTab;
  const AdminNewsScreen({super.key, this.initialTab = 0});

  @override
  ConsumerState<AdminNewsScreen> createState() => _AdminNewsScreenState();
}

class _AdminNewsScreenState extends ConsumerState<AdminNewsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _titleController = TextEditingController();
  TargetAudience _selectedAudience = TargetAudience.all;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialTab);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _toggleArchive(NewsModel news, bool archive) async {
    await FirebaseFirestore.instance
        .collection('news')
        .doc(news.id)
        .update({'isArchived': archive});
  }

  Future<void> _deleteNews(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Удаление'),
        content: const Text('Вы уверены, что хотите удалить новость навсегда?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Отмена')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            child: const Text('Удалить', style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await FirebaseFirestore.instance.collection('news').doc(id).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Управление новостями'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.campaign_outlined), text: 'Активные'),
            Tab(icon: Icon(Icons.add_comment_outlined), text: 'Создать'),
            Tab(icon: Icon(Icons.archive_outlined), text: 'Архив'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNewsList(false),
          const Center(child: Text('Используйте кнопку "Создать" в меню или FAB')), // Заглушка, т.к. создание в отдельном экране
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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(archived ? Icons.archive_outlined : Icons.newspaper, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(archived ? 'Архив пуст' : 'Активных новостей нет', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: newsList.length,
          itemBuilder: (context, index) {
            final news = newsList[index];
            String? imageUrl;
            String firstText = '';
            for (var b in news.contentBlocks) {
              if (b.type == 'image' && imageUrl == null) imageUrl = b.value;
              if (b.type == 'text' && firstText.isEmpty) firstText = b.value;
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => NewsDetailsDialog(news: news),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 60, height: 60,
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          child: imageUrl != null 
                            ? Image.network(imageUrl, fit: BoxFit.cover)
                            : const Icon(Icons.image_outlined, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(news.title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text(firstText, style: const TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(archived ? Icons.unarchive : Icons.archive_outlined),
                        onPressed: () => _toggleArchive(news, !archived),
                      ),
                      if (archived)
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _deleteNews(news.id),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
