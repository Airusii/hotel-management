import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_app/features/news/news_model.dart'; // Твой путь к модели

class NewsCarousel extends StatelessWidget {
  const NewsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // 🚀 Делаем умный запрос: берем новости для Всех и для Гостей
      stream: FirebaseFirestore.instance
          .collection('news')
          .where('targetAudience', whereIn: ['all', 'guests'])
          .orderBy('createdAt', descending: true)
          .limit(5) // Берем только 5 самых свежих, чтобы не грузить телефон
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Ошибка загрузки новостей'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return const SizedBox.shrink(); // Если новостей нет, просто скрываем карусель (пустота)
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Свежие новости',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 150, // Фиксированная высота карусели
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final news = NewsModel.fromMap(data, docs[index].id);

                  return _buildNewsCard(context, news);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // Дизайн самой карточки
  Widget _buildNewsCard(BuildContext context, NewsModel news) {
    return Container(
      width: 280, // Ширина одной карточки
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceContainerHighest, // Берем цвет из твоей темы
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Позже сюда добавим открытие новости на весь экран
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Открываем: ${news.title}')),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    news.content,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}