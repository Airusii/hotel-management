import 'package:cloud_firestore/cloud_firestore.dart';

enum TargetAudience { all, guests, staff }

class NewsContentBlock {
  final String type; // 'text' или 'image'
  final String value; // текст или url картинки

  NewsContentBlock({required this.type, required this.value});

  Map<String, dynamic> toMap() => {'type': type, 'value': value};

  factory NewsContentBlock.fromMap(Map<String, dynamic> map) => 
      NewsContentBlock(type: map['type'] ?? 'text', value: map['value'] ?? '');
}

class NewsModel {
  final String id;
  final String title;
  final List<NewsContentBlock> contentBlocks;
  final TargetAudience targetAudience;
  final DateTime createdAt;
  final bool isArchived;

  NewsModel({
    required this.id,
    required this.title,
    required this.contentBlocks,
    required this.targetAudience,
    required this.createdAt,
    this.isArchived = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'contentBlocks': contentBlocks.map((b) => b.toMap()).toList(),
      'targetAudience': targetAudience.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'isArchived': isArchived,
    };
  }

  factory NewsModel.fromMap(Map<String, dynamic> map, String id) {
    return NewsModel(
      id: id,
      title: map['title'] ?? 'Без заголовка',
      contentBlocks: (map['contentBlocks'] as List? ?? [])
          .map((b) => NewsContentBlock.fromMap(b as Map<String, dynamic>))
          .toList(),
      targetAudience: TargetAudience.values.firstWhere(
        (e) => e.name == map['targetAudience'],
        orElse: () => TargetAudience.all,
      ),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isArchived: map['isArchived'] ?? false,
    );
  }
}
