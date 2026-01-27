import "package:drift/drift.dart";
import "package:super_todo_app_mobile/core/database/app_database.dart"; // Ajuste le chemin selon ton projet
import "package:super_todo_app_mobile/features/tasks/data/datasources/task_table.dart"; // On suppose que ta table est ici

part "task_dao.g.dart";

@DriftAccessor(tables: [TaskEntries])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  TaskDao(super.db);

  // Récupérer toutes les tâches d'un projet
  Future<List<TaskEntry>> getTasksByProject(final int projectId) {
    return (select(taskEntries)..where((final t) => t.projectId.equals(projectId))).get();
  }

  // Ajouter une tâche
  Future<int> insertTask(final TaskEntriesCompanion task) => into(taskEntries).insert(task);

  // Mettre à jour
  Future<bool> updateTask(final TaskEntriesCompanion task) => update(taskEntries).replace(task);

  // Supprimer
  Future<int> deleteTask(final int id) => (delete(taskEntries)..where((final t) => t.id.equals(id))).go();
}
