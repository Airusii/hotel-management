import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/auth/auth_provider.dart';
import 'package:hotel_app/features/rooms/rooms_repository.dart';
import 'package:hotel_app/features/tasks/task_model.dart';
import 'package:hotel_app/features/tasks/tasks_repository.dart';
import 'package:hotel_app/l10n/app_localizations.dart';

class AdminTasksScreen extends ConsumerStatefulWidget {
  const AdminTasksScreen({super.key});

  @override
  ConsumerState<AdminTasksScreen> createState() => _AdminTasksScreenState();
}

class _AdminTasksScreenState extends ConsumerState<AdminTasksScreen> {
  void _showAddTaskDialog() {
    final l10n = AppLocalizations.of(context)!;
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String? selectedRoomId;
    String? selectedAssigneeId;

    showDialog<void>(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final roomsAsync = ref.watch(roomsStreamProvider);
          final employeesAsync = ref.watch(employeesStreamProvider);

          return AlertDialog(
            title: Text(l10n.tasksNew),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: l10n.tasksName,
                      hintText: l10n.tasksNameHint,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: l10n.tasksDescription,
                      hintText: l10n.tasksDescHint,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  roomsAsync.when(
                    data: (rooms) => DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: l10n.tasksAttachRoom),
                      items: [
                        DropdownMenuItem(value: null, child: Text(l10n.tasksUnattached)),
                        ...rooms.map(
                          (room) => DropdownMenuItem(
                            value: room.id,
                            child: Text('№ ${room.name}'),
                          ),
                        ),
                      ],
                      onChanged: (value) => selectedRoomId = value,
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (_, __) => Text(l10n.tasksErrorRooms),
                  ),
                  const SizedBox(height: 16),
                  employeesAsync.when(
                    data: (employees) => DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: l10n.tasksAssignEmployee),
                      items: [
                        DropdownMenuItem(value: null, child: Text(l10n.tasksUnassigned)),
                        ...employees.map(
                          (employee) => DropdownMenuItem(
                            value: employee['id'],
                            child: Text(employee['name']),
                          ),
                        ),
                      ],
                      onChanged: (value) => selectedAssigneeId = value,
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (_, __) => Text(l10n.tasksErrorStaff),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.tasksCancel),
              ),
              FilledButton(
                onPressed: () async {
                  if (titleController.text.trim().isEmpty) return;

                  final newTask = Task(
                    id: '',
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
                child: Text(l10n.tasksCreate),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tasksAsync = ref.watch(tasksStreamProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tasksTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
      body: tasksAsync.when(
        data: (tasks) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;
              final content = Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildColumn(
                    l10n.tasksPending,
                    tasks.where((task) => task.status == TaskStatus.pending).toList(),
                    TaskStatus.pending,
                    isWide,
                  ),
                  _buildColumn(
                    l10n.tasksInProgress,
                    tasks.where((task) => task.status == TaskStatus.inProgress).toList(),
                    TaskStatus.inProgress,
                    isWide,
                  ),
                  _buildColumn(
                    l10n.tasksDone,
                    tasks.where((task) => task.status == TaskStatus.completed).toList(),
                    TaskStatus.completed,
                    isWide,
                  ),
                ],
              );

              if (isWide) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: content,
                );
              }

              return ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 900,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: content,
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(l10n.tasksError(error.toString()))),
      ),
    );
  }

  Widget _buildColumn(String title, List<Task> columnTasks, TaskStatus status, bool isWide) {
    final theme = Theme.of(context);
    final columnContent = DragTarget<Task>(
      onAccept: (task) {
        ref.read(tasksRepositoryProvider).updateTaskStatus(task.id, status);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;
        return Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isHovered
                ? theme.colorScheme.primaryContainer.withOpacity(0.3)
                : theme.colorScheme.surfaceVariant.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
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
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
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
          roomName = rooms.firstWhere((room) => room.id == task.roomId).name;
        } catch (_) {}
      });
    }

    final cardContent = _buildCardContent(context, roomName);
    final useLongPress = theme.platform == TargetPlatform.iOS ||
        theme.platform == TargetPlatform.android;

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
        width: 280,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.primary),
        ),
        child: Text(
          task.title,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
        padding: const EdgeInsets.all(12),
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
                padding: const EdgeInsets.only(top: 4),
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
