import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/tasks/task_model.dart';

class TasksRepository {
  final FirebaseFirestore _firestore;

  TasksRepository(this._firestore);

  /// Получение потока задач, отсортированных по дате создания (новые сверху)
  Stream<List<Task>> getTasks() {
    return _firestore
        .collection('tasks')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Task.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  /// Добавление новой задачи
  Future<void> addTask(Task task) async {
    await _firestore.collection('tasks').add(task.toMap());
  }

  /// Обновление статуса задачи
  Future<void> updateTaskStatus(String taskId, TaskStatus newStatus) async {
    await _firestore.collection('tasks').doc(taskId).update({
      'status': newStatus.name,
    });
  }
}

/// Провайдер репозитория задач
final tasksRepositoryProvider = Provider<TasksRepository>((ref) {
  return TasksRepository(FirebaseFirestore.instance);
});

/// Стрим-провайдер списка задач
final tasksStreamProvider = StreamProvider<List<Task>>((ref) {
  final repository = ref.watch(tasksRepositoryProvider);
  return repository.getTasks();
});
