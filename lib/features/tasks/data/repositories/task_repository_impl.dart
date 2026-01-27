import "package:super_todo_app_mobile/features/tasks/domain/entities/task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task_status.dart";
import "package:super_todo_app_mobile/features/tasks/domain/repositories/task_repository.dart";
import "package:super_todo_app_mobile/features/tasks/data/datasources/task_dao.dart";
import "package:super_todo_app_mobile/core/database/app_database.dart";
import "package:drift/drift.dart";

class TaskRepositoryImpl implements TaskRepository {
  final TaskDao taskDao;

  TaskRepositoryImpl(this.taskDao);

  @override
  Future<List<Task>> getTasksByProject(final int projectId) async {
    final entries = await taskDao.getTasksByProject(projectId);
    return entries
        .map(
          (final e) => Task(
            id: e.id,
            title: e.title,
            projectId: e.projectId,
          ),
        )
        .toList();
  }

  @override
  Future<void> addTask(final Task task) async {
    await taskDao.insertTask(
      TaskEntriesCompanion.insert(
        title: task.title,
        projectId: task.projectId,
        status: TaskStatus.todo,
      ),
    );
  }

  @override
  Future<void> updateTask(final Task task) async {
    await taskDao.updateTask(
      TaskEntriesCompanion(
        id: Value(task.id!),
        title: Value(task.title),
        projectId: Value(task.projectId),
      ),
    );
  }

  @override
  Future<void> deleteTask(final int taskId) async {
    await taskDao.deleteTask(taskId);
  }
}
