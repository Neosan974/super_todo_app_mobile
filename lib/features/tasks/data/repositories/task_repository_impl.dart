import "package:super_todo_app_mobile/features/tasks/domain/entities/task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/repositories/task_repository.dart";
import "package:super_todo_app_mobile/features/tasks/data/datasources/task_dao.dart";
import "package:super_todo_app_mobile/core/database/app_database.dart";
import "package:drift/drift.dart";

class TaskRepositoryImpl implements TaskRepository {
  final TaskDao taskDao;

  TaskRepositoryImpl(this.taskDao);

  @override
  Future<List<Task>> getTasksByProject(int projectId) async {
    final entries = await taskDao.getTasksByProject(projectId);
    return entries
        .map(
          (e) => Task(
            id: e.id,
            title: e.title,
            isCompleted: e.isCompleted,
            projectId: e.projectId,
          ),
        )
        .toList();
  }

  @override
  Future<void> addTask(Task task) async {
    await taskDao.insertTask(
      TaskEntriesCompanion.insert(
        title: task.title,
        projectId: task.projectId,
        isCompleted: Value(task.isCompleted),
      ),
    );
  }

  @override
  Future<void> updateTask(Task task) async {
    await taskDao.updateTask(
      TaskEntriesCompanion(
        id: Value(task.id!),
        title: Value(task.title),
        isCompleted: Value(task.isCompleted),
        projectId: Value(task.projectId),
      ),
    );
  }

  @override
  Future<void> deleteTask(int taskId) async {
    await taskDao.deleteTask(taskId);
  }
}
