import "package:super_todo_app_mobile/features/projects/data/datasources/project_dao.dart";
import "package:super_todo_app_mobile/features/projects/domain/entities/project.dart";
import "package:super_todo_app_mobile/features/projects/domain/repositories/project_repository.dart";
import "package:super_todo_app_mobile/core/database/app_database.dart";
import "package:drift/drift.dart";

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectDao projectDao;

  ProjectRepositoryImpl(this.projectDao);

  @override
  Future<List<Project>> getAllProjects() async {
    final rows = await projectDao.getAllProjects();

    // On convertit les lignes Drift (ProjectEntry) en nos Entités (Project)
    return rows
        .map(
          (row) => Project(
            id: row.id,
            name: row.name,
            description: row.description,
            createdAt: row.createdAt,
          ),
        )
        .toList();
  }

  @override
  Future<void> addProject(Project project) async {
    // Drift utilise des "Companions" pour les insertions (pour gérer l'id auto-incrémenté)
    await projectDao.insertProject(
      ProjectEntriesCompanion(
        name: Value(project.name),
        description: Value(project.description),
        createdAt: Value(project.createdAt),
      ),
    );
  }

  @override
  Future<void> updateProject(Project project) async {
    await projectDao.updateProject(
      ProjectEntriesCompanion(
        id: Value(project.id!),
        name: Value(project.name),
        description: Value(project.description),
      ),
    );
  }

  @override
  Future<void> deleteProject(int id) async {
    await projectDao.deleteProjectById(id);
  }
}
