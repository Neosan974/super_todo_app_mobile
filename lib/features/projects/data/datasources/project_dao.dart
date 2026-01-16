import "package:drift/drift.dart";
import "package:super_todo_app_mobile/core/database/app_database.dart";
import "package:super_todo_app_mobile/features/projects/data/datasources/project_table.dart";

// On génère aussi un fichier part pour le DAO
part "project_dao.g.dart";

@DriftAccessor(tables: [ProjectEntries])
class ProjectDao extends DatabaseAccessor<AppDatabase> with _$ProjectDaoMixin {
  ProjectDao(super.db);

  // Toutes tes requêtes migrent ici
  Future<List<ProjectEntry>> getAllProjects() => select(projectEntries).get();

  // Drift gère aussi les Streams (très puissant pour l'UI auto-update)
  Stream<List<ProjectEntry>> watchAllProjects() => select(projectEntries).watch();

  Future<int> insertProject(ProjectEntriesCompanion entry) => into(projectEntries).insert(entry);

  Future<bool> updateProject(ProjectEntriesCompanion entry) => update(projectEntries).replace(entry);

  Future deleteProjectById(int id) => (delete(projectEntries)..where((t) => t.id.equals(id))).go();
}
