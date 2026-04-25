import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'news_model.dart';


class CreateNewsScreen extends StatefulWidget {
  const CreateNewsScreen({super.key});

  @override
  State<CreateNewsScreen> createState() => _CreateNewsScreenState();
}

class _CreateNewsScreenState extends State<CreateNewsScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  TargetAudience _selectedAudience = TargetAudience.all;
  bool _isLoading = false;

  Future<void> _publishNews() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все поля!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Отправляем данные в Firestore
      await FirebaseFirestore.instance.collection('news').add({
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim(),
        'targetAudience': _selectedAudience.name,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Новость успешно опубликована! 🎉')),
      );

      // Закрываем экран безопасно через GoRouter
      context.pop();

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
      // Убираем загрузку ТОЛЬКО если была ошибка (т.к. экран не закрылся)
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создать новость'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Поле для заголовка
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Заголовок',
                border: OutlineInputBorder(),
              ),
              maxLength: 60,
            ),
            const SizedBox(height: 16),

            // Выбор аудитории (Современный переключатель)
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

            // Поле для основного текста (Многострочное)
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Текст новости',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 8, // Делает поле большим
            ),
            const SizedBox(height: 32),

            // Кнопка публикации
            ElevatedButton(
              onPressed: _isLoading ? null : _publishNews,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Опубликовать', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}