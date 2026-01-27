import "package:super_todo_app_mobile/features/tasks/domain/entities/task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/repositories/task_repository.dart";

class AddTask {
  final TaskRepository repository;

  AddTask(this.repository);

  Future<void> execute(final Task task) async {
    return await repository.addTask(task);
  }
}
