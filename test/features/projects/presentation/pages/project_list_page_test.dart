import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:provider/provider.dart";
import "package:super_todo_app_mobile/features/projects/domain/entities/project.dart";
import "package:super_todo_app_mobile/features/projects/presentation/manager/project_provider.dart";
import "package:super_todo_app_mobile/features/projects/presentation/pages/project_detail_page.dart";
import "package:super_todo_app_mobile/features/projects/presentation/pages/project_list_page.dart";
import "package:super_todo_app_mobile/features/projects/presentation/widgets/project_form.dart";
import "package:super_todo_app_mobile/features/tasks/presentation/manager/task_provider.dart";

import "project_detail_page_test.dart";

class MockProjectProvider extends Mock implements ProjectProvider {}

void main() {
  late MockProjectProvider mockProjectProvider;
  late MockTaskProvider mockTaskProvider;

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProjectProvider>.value(value: mockProjectProvider),
        ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider), // Injecte-le ici
      ],
      child: const MaterialApp(
        home: ProjectListPage(),
      ),
    );
  }

  setUp(() {
    mockProjectProvider = MockProjectProvider();
    mockTaskProvider = MockTaskProvider();

    // Mocks pour ProjectProvider
    when(() => mockProjectProvider.isLoading).thenReturn(false);
    when(() => mockProjectProvider.projects).thenReturn([]);
    when(() => mockProjectProvider.fetchProjects()).thenAnswer((_) async => {});
    when(() => mockTaskProvider.errorStream).thenAnswer((_) => const Stream.empty());

    // Mocks pour TaskProvider (nécessaires dès que ProjectDetailPage s'affiche)
    when(() => mockTaskProvider.isLoading).thenReturn(false);
    when(() => mockTaskProvider.tasks).thenReturn([]);
    when(() => mockTaskProvider.fetchTasks(any())).thenAnswer((_) async => {});
  });

  setUpAll(() {
    registerFallbackValue(Project(name: "", createdAt: DateTime.now()));
  });

  testWidgets("doit afficher un loader quand le provider charge", (WidgetTester tester) async {
    // On crée un mock du provider ou on injecte un état spécifique
    when(() => mockProjectProvider.isLoading).thenReturn(true);
    when(() => mockProjectProvider.projects).thenReturn([]);
    when(() => mockProjectProvider.fetchProjects()).thenAnswer((_) async => {});

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<ProjectProvider>.value(
          value: mockProjectProvider, // Un provider dont isLoading = true
          child: const ProjectListPage(),
        ),
      ),
    );

    // On cherche le widget de chargement
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets("doit naviguer vers le détail du projet lors d'un clic", (tester) async {
    final tProject = Project(id: 1, name: "Projet Test", createdAt: DateTime.now());
    when(() => mockProjectProvider.projects).thenReturn([tProject]);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // Trigger le build avec la liste

    // Cliquer sur le projet
    await tester.tap(find.text("Projet Test"));
    await tester.pumpAndSettle();

    // Vérifier qu'on est sur la page de détail
    expect(find.byType(ProjectDetailPage), findsOneWidget);
  });

  testWidgets("doit ouvrir le dialogue et créer un projet", (tester) async {
    when(() => mockProjectProvider.projects).thenReturn([]);
    when(() => mockProjectProvider.createProject(any(), any())).thenAnswer((_) async => {});

    await tester.pumpWidget(createWidgetUnderTest());

    // Clique sur le bouton "+" (Ligne 95-97)
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle(); // Attend l'animation du dialogue

    // On est maintenant dans _showProjectDialog (Lignes 27+)
    expect(find.byType(ProjectForm), findsOneWidget);

    // Remplit le formulaire et sauvegarde (Ligne 34)
    await tester.enterText(find.byKey(ProjectForm.titleTextFieldKey), "Nouveau Projet");
    await tester.enterText(find.byKey(ProjectForm.descriptionTextFieldKey), "Nouvelle description Projet");
    await tester.tap(find.byKey(ProjectForm.submitButtonKey));
    await tester.pumpAndSettle();

    // Vérifie l'appel au provider (Ligne 38)
    verify(() => mockProjectProvider.createProject("Nouveau Projet", "Nouvelle description Projet")).called(1);
  });

  testWidgets("doit ouvrir le dialogue en mode édition et modifier le projet", (tester) async {
    // 1. On prépare un projet existant
    final tProject = Project(id: 1, name: "Ancien Nom", createdAt: DateTime.now());

    when(() => mockProjectProvider.projects).thenReturn([tProject]);
    when(() => mockProjectProvider.editProject(any())).thenAnswer((_) async => {});

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // 2. On déclenche l'ouverture du dialogue d'édition
    // Note: Selon ton code ligne 78, le clic sur l'item navigue.
    // Si tu as un bouton spécifique pour éditer, utilise son sélecteur.
    // Ici, on simule l'appel direct de la fonction de modification si tu as un bouton dédié :
    await tester.longPress(find.text("Ancien Nom"));
    await tester.pumpAndSettle();

    // 3. On modifie le texte dans le ProjectForm
    await tester.enterText(find.byKey(ProjectForm.titleTextFieldKey), "Nom Modifié");
    await tester.enterText(find.byKey(ProjectForm.descriptionTextFieldKey), "Description");
    await tester.tap(find.byKey(ProjectForm.submitButtonKey));
    await tester.pumpAndSettle();

    // 4. Vérification du "vrai coupable" : les lignes 41-45
    verify(
      () => mockProjectProvider.editProject(
        any(
          that: isA<Project>()
              .having((p) => p.id, "id", 1)
              .having((p) => p.name, "name", "Nom Modifié")
              .having((p) => p.description, "description", "Description"),
        ),
      ),
    ).called(1);
  });

  testWidgets("doit supprimer un projet lors du drag vers la gauche de celui-ci", (tester) async {
    final tProject = Project(id: 1, name: "Projet Test", createdAt: DateTime.now());
    when(() => mockProjectProvider.projects).thenReturn([tProject]);
    when(() => mockProjectProvider.removeProject(any())).thenAnswer((_) async => {});

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Clique sur l'icône de suppression (Ligne 86)
    await tester.drag(find.byKey(Key("project_1")), Offset(-500, 0));
    await tester.pumpAndSettle();

    // Vérifie l'appel (Ligne 87)
    verify(() => mockProjectProvider.removeProject(1)).called(1);
  });
}
