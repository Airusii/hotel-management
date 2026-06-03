import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/tasks/task_model.dart';
import 'package:hotel_app/features/tasks/tasks_repository.dart';
import 'package:hotel_app/features/rooms/rooms_repository.dart';
import 'package:hotel_app/features/auth/auth_provider.dart';

class AdminTasksScreen extends ConsumerStatefulWidget {
  const AdminTasksScreen({super.key});

  @override
  ConsumerState<AdminTasksScreen> createState() => _AdminTasksScreenState();
}

class _AdminTasksScreenState extends ConsumerState<AdminTasksScreen> {
  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String? selectedRoomId;
    String? selectedAssigneeId;

    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final roomsAsync = ref.watch(roomsStreamProvider);
          final employeesAsync = ref.watch(employeesStreamProvider);

          return AlertDialog(
            title: const Text('Новая задача'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Название',
                      hintText: 'Например: Уборка номера',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Описание',
                      hintText: 'Что именно нужно сделать?',
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  roomsAsync.when(
                    data: (rooms) => DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Привязать к номеру'),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('Без привязки')),
                        ...rooms.map((room) => DropdownMenuItem(
                              value: room.id,
                              child: Text('№ ${room.name}'),
                            )),
                      ],
                      onChanged: (val) => selectedRoomId = val,
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (_, __) => const Text('Ошибка загрузки номеров'),
                  ),
                  const SizedBox(height: 16),
                  employeesAsync.when(
                    data: (employees) => DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Назначить сотрудника'),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('Не назначено')),
                        ...employees.map((emp) => DropdownMenuItem(
                              value: emp['id'],
                              child: Text(emp['name']),
                            )),
                      ],
                      onChanged: (val) => selectedAssigneeId = val,
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (_, __) => const Text('Ошибка загрузки персонала'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Отмена'),
              ),
              FilledButton(
                onPressed: () async {
                  if (titleController.text.trim().isEmpty) return;

                  final newTask = Task(
                    id: '', // Firebase сгенерирует свой ID
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim(),
                    status: TaskStatus.pending,
                    createdAt: DateTime.now(),
                    roomId: selectedRoomId,
                    assigneeId: selectedAssigneeId,
                  );

                  await ref.read(tasksRepositoryProvider).addTask(newTask);
                  if (mounted) Navigator.pop(context);
                },
                child: const Text('Создать'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(tasksStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Задачи'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
      body: tasksAsync.when(
        data: (tasks) {
          return LayoutBuilder(
            builder: (context, constraints) {
              // Если экран достаточно широкий (ПК/Планшет), делаем колонки адаптивными
              final bool isWide = constraints.maxWidth > 800;

              final content = Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildColumn('Ожидают', tasks.where((t) => t.status == TaskStatus.pending).toList(), TaskStatus.pending, isWide),
                  _buildColumn('В работе', tasks.where((t) => t.status == TaskStatus.inProgress).toList(), TaskStatus.inProgress, isWide),
                  _buildColumn('Готово', tasks.where((t) => t.status == TaskStatus.completed).toList(), TaskStatus.completed, isWide),
                ],
              );

              if (isWide) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                  child: content,
                );
              }

              // Для мобильных разрешаем горизонтальный скролл
              return ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 900,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: content,
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text('Ошибка: $error'),
        ),
      ),
    );
  }

  Widget _buildColumn(String title, List<Task> columnTasks, TaskStatus status, bool isWide) {
    final theme = Theme.of(context);

    Widget columnContent = DragTarget<Task>(
      onAccept: (task) {
        ref.read(tasksRepositoryProvider).updateTaskStatus(task.id, status);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;
        return Container(
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: isHovered ? theme.colorScheme.primaryContainer.withOpacity(0.3) : theme.colorScheme.surfaceVariant.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${columnTasks.length}',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: columnTasks.length,
                  itemBuilder: (context, index) {
                    return _TaskCard(task: columnTasks[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    return isWide ? Expanded(child: columnContent) : SizedBox(width: 300, child: columnContent);
  }
}

class _TaskCard extends ConsumerWidget {
  final Task task;
  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final roomsAsync = ref.watch(roomsStreamProvider);
    
    String? roomName;
    if (task.roomId != null) {
      roomsAsync.whenData((rooms) {
        try {
          roomName = rooms.firstWhere((r) => r.id == task.roomId).name;
        } catch (_) {}
      });
    }

    final cardContent = _buildCardContent(context, roomName);

    // На ПК (Windows/Web/etc) используем обычный Draggable для мгновенного отклика мышкой.
    // На мобильных - LongPressDraggable, чтобы не блокировать скролл списка.
    final bool useLongPress = theme.platform == TargetPlatform.iOS || theme.platform == TargetPlatform.android;

    if (useLongPress) {
      return LongPressDraggable<Task>(
        data: task,
        feedback: _buildFeedbackCard(theme),
        childWhenDragging: Opacity(opacity: 0.3, child: cardContent),
        child: cardContent,
      );
    }

    return MouseRegion(
      cursor: SystemMouseCursors.grab,
      child: Draggable<Task>(
        data: task,
        feedback: _buildFeedbackCard(theme),
        childWhenDragging: Opacity(opacity: 0.3, child: cardContent),
        child: cardContent,
      ),
    );
  }

  Widget _buildFeedbackCard(ThemeData theme) {
    return Material(
      elevation: 12,
      borderRadius: BorderRadius.circular(12),
      color: Colors.transparent,
      child: Container(
        width: 280, // Фиксируем ширину превью
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.primary),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context, String? roomName) {
    final theme = Theme.of(context);
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                if (task.roomId != null)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '№ ${roomName ?? task.roomId}',
                      style: TextStyle(
                        fontSize: 10,
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            if (task.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  task.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.access_time, size: 10, color: theme.colorScheme.outline),
                const SizedBox(width: 4),
                Text(
                  '${task.createdAt.day}.${task.createdAt.month}',
                  style: TextStyle(fontSize: 10, color: theme.colorScheme.outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
