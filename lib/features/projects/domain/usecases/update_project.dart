import "package:super_todo_app_mobile/features/projects/domain/entities/project.dart";
import "package:super_todo_app_mobile/features/projects/domain/repositories/project_repository.dart";

class UpdateProject {
  final ProjectRepository repository;
  UpdateProject(this.repository);
  Future<void> execute(final Project project) => repository.updateProject(project);
}
