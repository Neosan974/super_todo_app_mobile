import "package:super_todo_app_mobile/features/tasks/domain/entities/task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/repositories/task_repository.dart";

class UpdateTask {
  final TaskRepository repository;
  UpdateTask(this.repository);

  Future<void> execute(Task task) async {
    return await repository.updateTask(task);
  }
}
