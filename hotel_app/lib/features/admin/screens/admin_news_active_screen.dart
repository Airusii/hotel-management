import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_app/features/news/news_model.dart';
import 'package:intl/intl.dart';
import 'package:hotel_app/l10n/app_localizations.dart';
class AdminNewsActiveScreen extends StatelessWidget {
  const AdminNewsActiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminActiveNews)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('news')
            .where('isArchived', isEqualTo: false)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text(l10n.errorGeneric(snapshot.error.toString())));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final newsList = snapshot.data!.docs
              .map((doc) => NewsModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
              .toList();

          if (newsList.isEmpty) {
            return Center(child: Text(l10n.newsManageActiveEmpty));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              final news = newsList[index];
              
              String audienceLabel;
              switch (news.targetAudience) {
                case TargetAudience.all: audienceLabel = l10n.newsCreateAudienceAll; break;
                case TargetAudience.guests: audienceLabel = l10n.newsCreateAudienceGuests; break;
                case TargetAudience.staff: audienceLabel = l10n.newsCreateAudienceStaff; break;
              }

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(news.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    '${DateFormat.yMd(locale).format(news.createdAt)} • ${audienceLabel.toUpperCase()}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.archive_outlined),
                    onPressed: () => FirebaseFirestore.instance
                        .collection('news')
                        .doc(news.id)
                        .update({'isArchived': true}),
                    tooltip: l10n.newsManageArchive,
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
