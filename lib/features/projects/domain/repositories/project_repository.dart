import "package:super_todo_app_mobile/features/projects/domain/entities/project.dart";

abstract class ProjectRepository {
  Future<List<Project>> getAllProjects();
  Future<void> addProject(final Project project);
  Future<void> updateProject(final Project project);
  Future<void> deleteProject(final int id);
}
