import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskStatus { pending, inProgress, completed }

class Task {
  final String id;
  final String title;
  final String description;
  final String? roomId;
  final String? assigneeId;
  final TaskStatus status;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.roomId,
    this.assigneeId,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'roomId': roomId,
      'assigneeId': assigneeId,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      roomId: map['roomId'],
      assigneeId: map['assigneeId'],
      status: TaskStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => TaskStatus.pending,
      ),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? roomId,
    String? assigneeId,
    TaskStatus? status,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      roomId: roomId ?? this.roomId,
      assigneeId: assigneeId ?? this.assigneeId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
