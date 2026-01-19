// lib/features/tasks/domain/usecases/toggle_task_status.dart

import "package:super_todo_app_mobile/features/tasks/domain/entities/task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/repositories/task_repository.dart";

class ToggleTaskStatus {
  final TaskRepository repository;
  ToggleTaskStatus(this.repository);

  Future<void> execute(Task task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    return await repository.updateTask(updatedTask);
  }
}
