import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_app/features/news/news_model.dart';
import 'package:intl/intl.dart';

class AdminNewsArchiveScreen extends StatelessWidget {
  const AdminNewsArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Архив новостей')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('news')
            .where('isArchived', isEqualTo: true)
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
            return const Center(child: Text('Архив пуст'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              final news = newsList[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(news.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  subtitle: Text(
                    '${DateFormat('dd.MM.yyyy').format(news.createdAt)} • ${news.targetAudience.name.toUpperCase()}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.unarchive_outlined),
                    onPressed: () => FirebaseFirestore.instance
                        .collection('news')
                        .doc(news.id)
                        .update({'isArchived': false}),
                    tooltip: 'Восстановить',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
