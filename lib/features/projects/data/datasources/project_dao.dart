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

  Future<int> insertProject(final ProjectEntriesCompanion entry) => into(projectEntries).insert(entry);

  Future<bool> updateProject(final ProjectEntriesCompanion entry) => update(projectEntries).replace(entry);

  Future deleteProjectById(final int id) => (delete(projectEntries)..where((final t) => t.id.equals(id))).go();
}
