import "package:super_todo_app_mobile/features/tasks/domain/entities/task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/repositories/task_repository.dart";

class UpdateTaskStatus {
  final TaskRepository repository;
  UpdateTaskStatus(this.repository);

  Future<void> execute(final Task task) async {
    return await repository.updateTask(task);
  }
}
