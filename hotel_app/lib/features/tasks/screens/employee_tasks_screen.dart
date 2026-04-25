import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/tasks/task_model.dart';
import 'package:hotel_app/features/tasks/tasks_repository.dart';
import 'package:hotel_app/features/rooms/rooms_repository.dart';
import 'package:hotel_app/features/auth/auth_provider.dart';

class EmployeeTasksScreen extends ConsumerWidget {
  const EmployeeTasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksStreamProvider);
    final roomsAsync = ref.watch(roomsStreamProvider);
    
    // Получаем текущего пользователя для фильтрации личных задач
    final currentUserId = ref.watch(authStateChangesProvider).value?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои задачи'),
        actions: [
          IconButton(
            onPressed: () => ref.refresh(tasksStreamProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: tasksAsync.when(
        data: (allTasks) {
          if (currentUserId == null) {
            return const Center(child: Text('Пожалуйста, войдите в систему'));
          }

          // 1. Фильтрация: статус active И (назначено мне ИЛИ не назначено никому)
          final filteredTasks = allTasks.where((t) {
            final isActive = t.status == TaskStatus.pending || t.status == TaskStatus.inProgress;
            final isForMe = t.assigneeId == currentUserId || t.assigneeId == null;
            return isActive && isForMe;
          }).toList();

          // 2. Сортировка: "В работе" всегда сверху
          filteredTasks.sort((a, b) {
            if (a.status == TaskStatus.inProgress && b.status != TaskStatus.inProgress) return -1;
            if (a.status != TaskStatus.inProgress && b.status == TaskStatus.inProgress) return 1;
            return b.createdAt.compareTo(a.createdAt);
          });

          // 3. Если пусто — показываем заглушку
          if (filteredTasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.done_all, size: 64, color: Colors.green.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  const Text(
                    'На сегодня задач нет!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Вы отлично поработали.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              final task = filteredTasks[index];
              return _EmployeeTaskCard(task: task, roomsAsync: roomsAsync);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Ошибка: $error')),
      ),
    );
  }
}

class _EmployeeTaskCard extends ConsumerWidget {
  final Task task;
  final AsyncValue<List<dynamic>> roomsAsync;

  const _EmployeeTaskCard({required this.task, required this.roomsAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isInProgress = task.status == TaskStatus.inProgress;

    String roomName = 'Общая территория';
    if (task.roomId != null) {
      roomsAsync.whenData((rooms) {
        try {
          final room = rooms.firstWhere((r) => r.id == task.roomId);
          roomName = 'Номер № ${room.name}';
        } catch (_) {}
      });
    }

    return Card(
      elevation: isInProgress ? 4 : 1,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isInProgress
            ? BorderSide(color: theme.colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      color: isInProgress ? theme.colorScheme.primaryContainer.withOpacity(0.1) : null,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Бейдж комнаты
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isInProgress ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                roomName,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: isInProgress ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Заголовок
            Text(
              task.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Описание
            if (task.description.isNotEmpty)
              Text(
                task.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            const SizedBox(height: 20),
            // Кнопка действия
            SizedBox(
              width: double.infinity,
              height: 56,
              child: task.status == TaskStatus.pending
                  ? OutlinedButton(
                      onPressed: () {
                        ref.read(tasksRepositoryProvider).updateTaskStatus(task.id, TaskStatus.inProgress);
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('ВЗЯТЬ В РАБОТУ', style: TextStyle(fontWeight: FontWeight.bold)),
                    )
                  : FilledButton.icon(
                      onPressed: () {
                        ref.read(tasksRepositoryProvider).updateTaskStatus(task.id, TaskStatus.completed);
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('ЗАВЕРШИТЬ', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
