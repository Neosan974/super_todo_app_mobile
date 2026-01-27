import "package:super_todo_app_mobile/features/tasks/domain/entities/task.dart";

abstract class TaskRepository {
  // Récupère les tâches filtrées par projet
  Future<List<Task>> getTasksByProject(final int projectId);

  Future<void> addTask(final Task task);
  Future<void> updateTask(final Task task);
  Future<void> deleteTask(final int taskId);
}
