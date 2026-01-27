import "package:flutter/material.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task_status.dart";

class TaskListItem extends StatelessWidget {
  final Task task;
  final void Function(TaskStatus?) onStatusChange;
  final void Function() onDelete;
  final void Function() onTap;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onStatusChange,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    return Dismissible(
      key: taskItemKey(task.id ?? 0),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        onTap: onTap,
        leading: DropdownMenu(
          onSelected: (final value) {
            onStatusChange(value);
          },
          initialSelection: task.status,
          dropdownMenuEntries: TaskStatus.values
              .map(
                (final e) => DropdownMenuEntry(
                  value: e,
                  label: e.label,
                  labelWidget: e.displayWidget,
                ),
              )
              .toList(),
        ),
        title: Text(task.title),
      ),
    );
  }

  static Key taskItemKey(final int taskId) => Key("task_$taskId");
}
