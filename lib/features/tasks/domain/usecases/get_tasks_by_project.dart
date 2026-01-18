import "package:super_todo_app_mobile/features/tasks/domain/entities/task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/repositories/task_repository.dart";

class GetTasksByProject {
  final TaskRepository repository;

  GetTasksByProject(this.repository);

  Future<List<Task>> execute(int projectId) async {
    return await repository.getTasksByProject(projectId);
  }
}
