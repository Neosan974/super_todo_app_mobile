import "dart:async";
import "dart:developer";

import "package:flutter/material.dart";
import "package:super_todo_app_mobile/features/projects/domain/entities/project.dart";
import "package:super_todo_app_mobile/features/projects/domain/usecases/add_project.dart";
import "package:super_todo_app_mobile/features/projects/domain/usecases/delete_project.dart";
import "package:super_todo_app_mobile/features/projects/domain/usecases/get_projects.dart";
import "package:super_todo_app_mobile/features/projects/domain/usecases/update_project.dart";

class ProjectProvider extends ChangeNotifier {
  final GetProjects getProjectsUseCase;
  final AddProject addProjectUseCase;
  final UpdateProject updateProjectUseCase;
  final DeleteProject deleteProjectUseCase;

  ProjectProvider({
    required this.getProjectsUseCase,
    required this.addProjectUseCase,
    required this.updateProjectUseCase,
    required this.deleteProjectUseCase,
  });

  List<Project> _projects = [];
  List<Project> get projects => _projects;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchProjects() async {
    _isLoading = true;
    notifyListeners();

    try {
      _projects = await getProjectsUseCase.execute();
    } catch (e, stackTrace) {
      log(e.toString(), error: e, zone: Zone.current, time: DateTime.now(), stackTrace: stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createProject(String name, String description) async {
    final newProject = Project(
      name: name,
      description: description,
      createdAt: DateTime.now(),
    );

    await addProjectUseCase.execute(newProject);
    await fetchProjects(); // On rafraîchit la liste après l'ajout
  }

  Future<void> editProject(Project project) async {
    await updateProjectUseCase.execute(project);
    await fetchProjects(); // Rafraîchissement
  }

  Future<void> removeProject(int id) async {
    await deleteProjectUseCase.execute(id);
    await fetchProjects(); // Rafraîchissement
  }
}
