import "package:get_it/get_it.dart";
import "package:super_todo_app_mobile/core/database/app_database.dart";
import "package:super_todo_app_mobile/features/projects/data/datasources/project_dao.dart";
import "package:super_todo_app_mobile/features/projects/data/repositories/project_repository_impl.dart";
import "package:super_todo_app_mobile/features/projects/domain/repositories/project_repository.dart";
import "package:super_todo_app_mobile/features/projects/domain/usecases/add_project.dart";
import "package:super_todo_app_mobile/features/projects/domain/usecases/delete_project.dart";
import "package:super_todo_app_mobile/features/projects/domain/usecases/get_projects.dart";
import "package:super_todo_app_mobile/features/projects/domain/usecases/update_project.dart";

final sl = GetIt.instance; // sl pour Service Locator

Future<void> init({AppDatabase? database}) async {
  // 1. Base de données & DAOs
  final db = database ?? AppDatabase();
  sl.registerSingleton<AppDatabase>(db);
  sl.registerSingleton<ProjectDao>(db.projectDao);

  // 2. Repositories
  // On enregistre l'implémentation liée à l'interface
  sl.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(sl()),
  );

  // 3. Use Cases
  sl.registerLazySingleton(() => GetProjects(sl()));
  sl.registerLazySingleton(() => AddProject(sl()));
  sl.registerLazySingleton(() => UpdateProject(sl()));
  sl.registerLazySingleton(() => DeleteProject(sl()));

  // 4. External (si tu as besoin d'un client HTTP par exemple plus tard)
}
