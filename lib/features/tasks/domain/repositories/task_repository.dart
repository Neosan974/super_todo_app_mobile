import "package:super_todo_app_mobile/features/tasks/domain/entities/task.dart";

abstract class TaskRepository {
  // Récupère les tâches filtrées par projet
  Future<List<Task>> getTasksByProject(int projectId);

  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(int taskId);
}
