import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:super_todo_app_mobile/core/di/injection_container.dart" as di;
import "package:super_todo_app_mobile/features/projects/presentation/manager/project_provider.dart";
import "package:super_todo_app_mobile/features/projects/presentation/pages/project_list_page.dart";

void main() async {
  // 1. Indispensable pour initialiser les plugins (SQLite/PathProvider)
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialise GetIt (BDD, Repositories, UseCases)
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 3. On injecte le Provider au sommet de l'arbre.
        // sl<GetProjects>() récupère automatiquement l'instance configurée dans GetIt.
        ChangeNotifierProvider(
          create: (_) => ProjectProvider(
            getProjectsUseCase: di.sl(),
            addProjectUseCase: di.sl(),
            updateProjectUseCase: di.sl(),
            deleteProjectUseCase: di.sl(),
          ),
        ),
      ],
      child: MaterialApp(
        title: "Super Project Manager",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // 4. L'écran de démarrage de l'application
        home: const ProjectListPage(),
      ),
    );
  }
}
