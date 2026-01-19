import "package:super_todo_app_mobile/core/errors/app_error.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/repositories/task_repository.dart";

class TaskUpdateError extends AppError {
  TaskUpdateError({required super.message});
}

class UpdateTask {
  final TaskRepository repository;
  UpdateTask(this.repository);

  Future<void> execute(Task task) async {
    if (task.isCompleted) {
      throw TaskUpdateError(message: "Modification impossible : la tâche est déjà terminée.");
    }

    return await repository.updateTask(task);
  }
}
