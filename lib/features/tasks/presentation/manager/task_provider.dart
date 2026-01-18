import "package:flutter/material.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/usecases/add_task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/usecases/delete_task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/usecases/get_tasks_by_project.dart";
import "package:super_todo_app_mobile/features/tasks/domain/usecases/update_task.dart";

class TaskProvider extends ChangeNotifier {
  final GetTasksByProject getTasksByProjectUseCase;
  final AddTask addTaskUseCase;
  final UpdateTask updateTaskUseCase;
  final DeleteTask deleteTaskUseCase;

  TaskProvider({
    required this.getTasksByProjectUseCase,
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
  });

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchTasks(int projectId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _tasks = await getTasksByProjectUseCase.execute(projectId);
    } catch (e) {
      debugPrint("Erreur tasks: $e");
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
      debugPrint("Erreur ajout tâche: $e");
    }
  }

  Future<void> toggleTaskStatus(Task task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    try {
      await updateTaskUseCase.execute(updatedTask);
      await fetchTasks(task.projectId);
    } catch (e) {
      debugPrint("Erreur toggle: $e");
    }
  }

  // Supprimer une tâche
  Future<void> removeTask(int taskId, int projectId) async {
    try {
      await deleteTaskUseCase.execute(taskId);
      await fetchTasks(projectId);
    } catch (e) {
      debugPrint("Erreur suppression: $e");
    }
  }

  Future<void> renameTask(Task task, String newTitle) async {
    if (newTitle.isEmpty || newTitle == task.title) return;

    final updatedTask = task.copyWith(title: newTitle);
    try {
      await updateTaskUseCase.execute(updatedTask);
      await fetchTasks(task.projectId);
    } catch (e) {
      debugPrint("Erreur renommage: $e");
    }
  }
}
