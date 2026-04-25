import 'package:cloud_firestore/cloud_firestore.dart';

enum TargetAudience { all, guests, staff }

class NewsModel {
  final String id;
  final String title;
  final String content;
  final TargetAudience targetAudience;
  final DateTime createdAt;
  final bool isArchived;

  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.targetAudience,
    required this.createdAt,
    this.isArchived = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'targetAudience': targetAudience.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'isArchived': isArchived,
    };
  }

  factory NewsModel.fromMap(Map<String, dynamic> map, String id) {
    return NewsModel(
      id: id,
      title: map['title'] ?? 'Без заголовка',
      content: map['content'] ?? '',
      targetAudience: TargetAudience.values.firstWhere(
        (e) => e.name == map['targetAudience'],
        orElse: () => TargetAudience.all,
      ),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isArchived: map['isArchived'] ?? false,
    );
  }

  NewsModel copyWith({
    String? id,
    String? title,
    String? content,
    TargetAudience? targetAudience,
    DateTime? createdAt,
    bool? isArchived,
  }) {
    return NewsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      targetAudience: targetAudience ?? this.targetAudience,
      createdAt: createdAt ?? this.createdAt,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}
