import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/tasks/task_model.dart';
import 'package:hotel_app/features/tasks/tasks_repository.dart';
import 'package:hotel_app/features/rooms/rooms_repository.dart';
import 'package:hotel_app/features/auth/auth_provider.dart';
import 'package:hotel_app/l10n/app_localizations.dart';
class EmployeeTasksScreen extends ConsumerWidget {
  const EmployeeTasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final tasksAsync = ref.watch(tasksStreamProvider);
    final roomsAsync = ref.watch(roomsStreamProvider);
    
    final currentUserId = ref.watch(authStateChangesProvider).value?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tasksMyTasksTitle),
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
            return Center(child: Text(l10n.tasksLoginRequired));
          }

          final filteredTasks = allTasks.where((t) {
            final isActive = t.status == TaskStatus.pending || t.status == TaskStatus.inProgress;
            final isForMe = t.assigneeId == currentUserId || t.assigneeId == null;
            return isActive && isForMe;
          }).toList();

          filteredTasks.sort((a, b) {
            if (a.status == TaskStatus.inProgress && b.status != TaskStatus.inProgress) return -1;
            if (a.status != TaskStatus.inProgress && b.status == TaskStatus.inProgress) return 1;
            return b.createdAt.compareTo(a.createdAt);
          });

          if (filteredTasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.done_all, size: 64, color: Colors.green.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    l10n.tasksNoTasksToday,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    l10n.tasksWellDone,
                    style: const TextStyle(color: Colors.grey),
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
        error: (error, stackTrace) => Center(child: Text(l10n.errorGeneric(error.toString()))),
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
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isInProgress = task.status == TaskStatus.inProgress;

    String roomName = l10n.tasksCommonArea;
    if (task.roomId != null) {
      roomsAsync.whenData((rooms) {
        try {
          final room = rooms.firstWhere((r) => r.id == task.roomId);
          roomName = l10n.tasksRoomLabel(room.name);
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
            Text(
              task.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (task.description.isNotEmpty)
              Text(
                task.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            const SizedBox(height: 20),
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
                      child: Text(l10n.tasksTakeButton, style: const TextStyle(fontWeight: FontWeight.bold)),
                    )
                  : FilledButton.icon(
                      onPressed: () {
                        ref.read(tasksRepositoryProvider).updateTaskStatus(task.id, TaskStatus.completed);
                      },
                      icon: const Icon(Icons.check),
                      label: Text(l10n.tasksCompleteButton, style: const TextStyle(fontWeight: FontWeight.bold)),
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
