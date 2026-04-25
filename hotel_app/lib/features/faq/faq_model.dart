import 'package:cloud_firestore/cloud_firestore.dart';

class FaqModel {
  final String id;
  final String question;
  final String? answer;
  final String? userId;
  final String? userName;
  final bool isPublic;
  final DateTime createdAt;
  final DateTime? answeredAt;

  FaqModel({
    required this.id,
    required this.question,
    this.answer,
    this.userId,
    this.userName,
    this.isPublic = false,
    required this.createdAt,
    this.answeredAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
      'userId': userId,
      'userName': userName,
      'isPublic': isPublic,
      'createdAt': Timestamp.fromDate(createdAt),
      'answeredAt': answeredAt != null ? Timestamp.fromDate(answeredAt!) : null,
    };
  }

  factory FaqModel.fromMap(Map<String, dynamic> map, String id) {
    return FaqModel(
      id: id,
      question: map['question'] ?? '',
      answer: map['answer'],
      userId: map['userId'],
      userName: map['userName'],
      isPublic: map['isPublic'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      answeredAt: (map['answeredAt'] as Timestamp?)?.toDate(),
    );
  }

  FaqModel copyWith({
    String? id,
    String? question,
    String? answer,
    String? userId,
    String? userName,
    bool? isPublic,
    DateTime? createdAt,
    DateTime? answeredAt,
  }) {
    return FaqModel(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      isPublic: isPublic ?? this.isPublic,
      createdAt: createdAt ?? this.createdAt,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }
}
