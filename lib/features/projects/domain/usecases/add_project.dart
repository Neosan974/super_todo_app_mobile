import "package:super_todo_app_mobile/features/projects/domain/entities/project.dart";
import "package:super_todo_app_mobile/features/projects/domain/repositories/project_repository.dart";

class AddProject {
  final ProjectRepository repository;

  AddProject(this.repository);

  Future<void> execute(Project project) async {
    // On pourrait ajouter une validation ici
    if (project.name.isEmpty) return;

    return await repository.addProject(project);
  }
}
