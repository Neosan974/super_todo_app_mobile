import "package:super_todo_app_mobile/features/projects/domain/entities/project.dart";

abstract class ProjectRepository {
  Future<List<Project>> getAllProjects();
  Future<void> addProject(Project project);
  Future<void> updateProject(Project project);
  Future<void> deleteProject(int id);
}
