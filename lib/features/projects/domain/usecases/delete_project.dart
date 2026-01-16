import "package:super_todo_app_mobile/features/projects/domain/repositories/project_repository.dart";

class DeleteProject {
  final ProjectRepository repository;
  DeleteProject(this.repository);
  Future<void> execute(int id) => repository.deleteProject(id);
}
