import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_app/features/news/news_model.dart';
import 'package:hotel_app/features/news/widgets/news_details_dialog.dart';
import 'package:hotel_app/l10n/app_localizations.dart';
class NewsCarousel extends StatelessWidget {
  const NewsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('news')
          .where('targetAudience', whereIn: ['all', 'guests'])
          .where('isArchived', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(l10n.newsErrorLoading));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                l10n.newsTitle,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 110, 
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

  Widget _buildNewsCard(BuildContext context, NewsModel news) {
    final theme = Theme.of(context);
    
    String? imageUrl;
    String firstText = '';
    
    for (var block in news.contentBlocks) {
      if (block.type == 'image' && imageUrl == null) {
        imageUrl = block.value;
      }
      if (block.type == 'text' && firstText.isEmpty) {
        firstText = block.value;
      }
    }

    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: Card(
        elevation: 0,
        color: theme.colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => NewsDetailsDialog(news: news),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 80,
                    height: 80,
                    color: theme.colorScheme.surfaceVariant,
                    child: imageUrl != null
                        ? Image.network(imageUrl, fit: BoxFit.cover)
                        : Icon(Icons.newspaper, color: theme.colorScheme.primary.withOpacity(0.5)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        news.title,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        firstText,
                        style: TextStyle(
                          fontSize: 12, 
                          color: theme.colorScheme.onSurfaceVariant
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
