import "package:super_todo_app_mobile/features/projects/domain/entities/project.dart";
import "package:super_todo_app_mobile/features/projects/domain/repositories/project_repository.dart";

class GetProjects {
  final ProjectRepository repository;

  GetProjects(this.repository);

  Future<List<Project>> execute() async {
    return await repository.getAllProjects();
  }
}
