import "package:get_it/get_it.dart";
import "package:super_todo_app_mobile/core/database/app_database.dart";
import "package:super_todo_app_mobile/features/projects/data/repositories/project_repository_impl.dart";
import "package:super_todo_app_mobile/features/projects/domain/repositories/project_repository.dart";
import "package:super_todo_app_mobile/features/projects/domain/usecases/add_project.dart";
import "package:super_todo_app_mobile/features/projects/domain/usecases/delete_project.dart";
import "package:super_todo_app_mobile/features/projects/domain/usecases/get_projects.dart";
import "package:super_todo_app_mobile/features/projects/domain/usecases/update_project.dart";
import "package:super_todo_app_mobile/features/tasks/data/repositories/task_repository_impl.dart";
import "package:super_todo_app_mobile/features/tasks/domain/repositories/task_repository.dart";
import "package:super_todo_app_mobile/features/tasks/domain/usecases/add_task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/usecases/delete_task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/usecases/get_tasks_by_project.dart";
import "package:super_todo_app_mobile/features/tasks/domain/usecases/update_task_status.dart";
import "package:super_todo_app_mobile/features/tasks/domain/usecases/update_task.dart";

final sl = GetIt.instance; // sl pour Service Locator

Future<void> init({final AppDatabase? database}) async {
  // 1. Base de données & DAOs
  final db = database ?? AppDatabase();
  sl.registerSingleton(db);
  sl.registerSingleton(db.projectDao);
  sl.registerSingleton(db.taskDao);

  // 2. Repositories
  // On enregistre l'implémentation liée à l'interface
  sl.registerLazySingleton<ProjectRepository>(() => ProjectRepositoryImpl(sl()));
  sl.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(sl()));

  // 3. Use Cases
  // 3.1 Projects
  sl.registerLazySingleton(() => GetProjects(sl()));
  sl.registerLazySingleton(() => AddProject(sl()));
  sl.registerLazySingleton(() => UpdateProject(sl()));
  sl.registerLazySingleton(() => DeleteProject(sl()));
  // 3.2 Tasks
  sl.registerLazySingleton(() => GetTasksByProject(sl()));
  sl.registerLazySingleton(() => AddTask(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));
  sl.registerLazySingleton(() => UpdateTaskStatus(sl()));

  // 4. External (si tu as besoin d'un client HTTP par exemple plus tard)
}
