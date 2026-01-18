import "package:super_todo_app_mobile/features/tasks/domain/repositories/task_repository.dart";

class DeleteTask {
  final TaskRepository repository;
  DeleteTask(this.repository);

  Future<void> execute(int taskId) async {
    return await repository.deleteTask(taskId);
  }
}
