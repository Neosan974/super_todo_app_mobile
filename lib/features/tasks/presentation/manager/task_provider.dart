import "dart:async";
import "dart:developer";

import "package:flutter/material.dart";
import "package:super_todo_app_mobile/core/errors/app_error.dart";
import "package:super_todo_app_mobile/core/errors/unknown_error.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/usecases/add_task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/usecases/delete_task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/usecases/get_tasks_by_project.dart";
import "package:super_todo_app_mobile/features/tasks/domain/usecases/update_task_status.dart";
import "package:super_todo_app_mobile/features/tasks/domain/usecases/update_task.dart";

class TaskProvider extends ChangeNotifier {
  final GetTasksByProject getTasksByProjectUseCase;
  final AddTask addTaskUseCase;
  final UpdateTask updateTaskUseCase;
  final DeleteTask deleteTaskUseCase;
  final UpdateTaskStatus updateTaskStatusUseCase;

  final _errorController = StreamController<AppError>.broadcast();

  TaskProvider({
    required this.getTasksByProjectUseCase,
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
    required this.updateTaskStatusUseCase,
  });

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Stream<AppError> get errorStream => _errorController.stream;

  @override
  void dispose() {
    _errorController.close();
    super.dispose();
  }

  Future<void> fetchTasks(int projectId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _tasks = await getTasksByProjectUseCase.execute(projectId);
    } catch (e) {
      log("Erreur tasks: $e");
      _errorController.add(UnknownError());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(String title, int projectId) async {
    final newTask = Task(title: title, projectId: projectId);

    try {
      await addTaskUseCase.execute(newTask);
      await fetchTasks(projectId); // Rafraîchit la liste automatiquement
    } catch (e) {
      log("Erreur ajout tâche: $e");
      _errorController.add(UnknownError());
    }
  }

  Future<void> toggleTaskStatus(Task task) async {
    try {
      // On utilise le use case dédié qui n'a pas la restriction de verrouillage
      await updateTaskStatusUseCase.execute(task);
      await fetchTasks(task.projectId);
    } on TaskUpdateError catch (e) {
      _errorController.add(e);
    } catch (e) {
      log("Erreur toggle: $e");
      _errorController.add(UnknownError());
    }
  }

  // Supprimer une tâche
  Future<void> removeTask(int taskId, int projectId) async {
    try {
      await deleteTaskUseCase.execute(taskId);
      await fetchTasks(projectId);
    } catch (e) {
      log("Erreur suppression: $e");
      _errorController.add(UnknownError());
    }
  }

  Future<void> renameTask(Task task, String newTitle) async {
    if (newTitle.isEmpty || newTitle == task.title) return;

    final updatedTask = task.copyWith(title: newTitle);
    try {
      await updateTaskUseCase.execute(updatedTask);
      await fetchTasks(task.projectId);
    } on TaskUpdateError catch (e) {
      _errorController.add(e);
    } catch (e) {
      log("Erreur renommage: $e");
      _errorController.add(UnknownError());
    }
  }
}
