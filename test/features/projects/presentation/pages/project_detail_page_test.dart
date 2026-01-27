import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:provider/provider.dart";
import "package:super_todo_app_mobile/core/errors/app_error.dart";
import "package:super_todo_app_mobile/core/errors/unknown_error.dart";
import "package:super_todo_app_mobile/features/projects/domain/entities/project.dart";
import "package:super_todo_app_mobile/features/projects/presentation/pages/project_detail_page.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task_status.dart";
import "package:super_todo_app_mobile/features/tasks/domain/usecases/update_task.dart";
import "package:super_todo_app_mobile/features/tasks/presentation/manager/task_provider.dart";
import "package:super_todo_app_mobile/features/tasks/presentation/widgets/task_form.dart";

// On crée un mock du provider
class MockTaskProvider extends Mock implements TaskProvider {}

void main() {
  late MockTaskProvider mockProvider;

  setUp(() {
    mockProvider = MockTaskProvider();

    // VALEURS PAR DÉFAUT OBLIGATOIRES
    // Pour éviter le crash 'Null' is not a subtype of 'bool'
    when(() => mockProvider.isLoading).thenReturn(false);
    // Pour éviter le crash 'Null' is not a subtype of 'List<Task>'
    when(() => mockProvider.tasks).thenReturn([]);
    // Pour éviter le crash 'Null' is not a subtype of 'Future<void>'
    when(() => mockProvider.fetchTasks(any())).thenAnswer((_) async => {});
    when(() => mockProvider.addTask(any(), any())).thenAnswer((_) async => {});
    when(() => mockProvider.renameTask(any(), any())).thenAnswer((_) async => {});
    when(() => mockProvider.errorStream).thenAnswer((_) => const Stream.empty());
  });

  setUpAll(() {
    registerFallbackValue(const Task(title: "title", projectId: 1));
  });

  // Helper pour injecter le provider dans l'arbre de widgets du test
  Widget createWidgetUnderTest(final Project project) {
    return MaterialApp(
      // On enveloppe TOUTE l'app pour que les dialogues y aient accès
      home: ChangeNotifierProvider<TaskProvider>.value(
        value: mockProvider,
        child: ProjectDetailPage(project: project),
      ),
    );
  }

  final tProject = Project(id: 1, name: "Projet Test", createdAt: DateTime.now());
  final tTasks = [
    const Task(id: 1, title: "Tâche 1", projectId: 1),
  ];

  testWidgets("doit afficher un loader quand isLoading est vrai", (final tester) async {
    // Arrange
    when(() => mockProvider.isLoading).thenReturn(true);
    when(() => mockProvider.tasks).thenReturn([]);
    // On doit mocker fetchTasks car il est appelé dans le initState
    when(() => mockProvider.fetchTasks(any())).thenAnswer((_) async => {});

    // Act
    await tester.pumpWidget(createWidgetUnderTest(tProject));

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets("doit afficher la liste des tâches quand elles sont chargées", (final tester) async {
    // Arrange
    when(() => mockProvider.isLoading).thenReturn(false);
    when(() => mockProvider.tasks).thenReturn(tTasks);
    when(() => mockProvider.fetchTasks(any())).thenAnswer((_) async => {});

    // Act
    await tester.pumpWidget(createWidgetUnderTest(tProject));
    await tester.pump(); // On laisse le temps au widget de se reconstruire

    // Assert
    expect(find.text("Tâche 1"), findsOneWidget);
    expect(find.byType(DropdownMenu<TaskStatus>), findsOneWidget);
  });

  testWidgets("doit ouvrir le dialogue d'ajout et appeler addTask via les Keys", (final tester) async {
    // ... mocks habituels ...

    await tester.pumpWidget(createWidgetUnderTest(tProject));
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // On utilise find.byKey pour une précision totale
    await tester.enterText(find.byKey(TaskForm.textFieldKey), "Ma nouvelle tâche");

    // On clique sur le bouton via sa clé, peu importe son texte !
    await tester.tap(find.byKey(TaskForm.submitButtonKey));
    await tester.pumpAndSettle();

    verify(() => mockProvider.addTask("Ma nouvelle tâche", tProject.id!)).called(1);
  });

  testWidgets("doit ouvrir le dialogue de modification au clic sur une tâche", (final tester) async {
    // Arrange
    when(() => mockProvider.isLoading).thenReturn(false);
    when(() => mockProvider.tasks).thenReturn(tTasks);
    when(() => mockProvider.fetchTasks(any())).thenAnswer((_) async => {});
    when(() => mockProvider.renameTask(any(), any())).thenAnswer((_) async => {});

    await tester.pumpWidget(createWidgetUnderTest(tProject));
    await tester.pump();

    // 1. Cliquer sur le titre de la tâche
    await tester.tap(find.text("Tâche 1"));
    await tester.pumpAndSettle();

    // 2. Vérifier que le titre du dialogue est correct et le texte pré-rempli
    expect(find.text("Modifier la tâche"), findsOneWidget);

    // 3. Modifier le texte et enregistrer
    await tester.enterText(find.byKey(TaskForm.textFieldKey), "Tâche modifiée");
    await tester.tap(find.text("Enregistrer"));
    await tester.pumpAndSettle();

    // Assert
    verify(() => mockProvider.renameTask(tTasks[0], "Tâche modifiée")).called(1);
  });

  testWidgets("doit appeler updateTaskStatus lors de la sélection d'un nouveau status", (final tester) async {
    // Arrange
    when(() => mockProvider.isLoading).thenReturn(false);
    when(() => mockProvider.tasks).thenReturn(tTasks);
    when(() => mockProvider.fetchTasks(any())).thenAnswer((_) async => {});
    when(() => mockProvider.updateTaskStatus(any())).thenAnswer((_) async => {});

    await tester.pumpWidget(createWidgetUnderTest(tProject));
    await tester.pump();

    // Act
    await tester.tap(find.byType(DropdownMenu<TaskStatus>));
    await tester.pumpAndSettle();

    // Taper sur le texte 'In Progress' qui est dans le Chip d'une DropdownMenuEntry
    await tester.tap(find.text("In Progress").last);
    await tester.pumpAndSettle();

    // Assert
    verify(() => mockProvider.updateTaskStatus(tTasks[0].copyWith(status: TaskStatus.inProgress))).called(1);
  });

  testWidgets("doit supprimer une tâche lors d'un swipe vers la gauche", (final tester) async {
    when(() => mockProvider.isLoading).thenReturn(false);
    when(() => mockProvider.tasks).thenReturn(tTasks);
    when(() => mockProvider.fetchTasks(any())).thenAnswer((_) async => {});
    when(() => mockProvider.removeTask(any(), any())).thenAnswer((_) async => {});

    await tester.pumpWidget(createWidgetUnderTest(tProject));
    await tester.pump();

    // On utilise le Finder pour localiser la tâche
    final taskFinder = find.text("Tâche 1");

    // Swipe de droite à gauche
    await tester.drag(taskFinder, const Offset(-500.0, 0.0));
    await tester.pumpAndSettle(); // Attendre l'animation de disparition

    verify(() => mockProvider.removeTask(tTasks[0].id!, tProject.id!)).called(1);
  });

  testWidgets("doit afficher une SnackBar rouge quand une erreur survient", (final tester) async {
    final errorController = StreamController<AppError>();
    // On remplace le stream vide par notre controller pour ce test précis
    when(() => mockProvider.errorStream).thenAnswer((_) => errorController.stream);

    await tester.pumpWidget(createWidgetUnderTest(tProject));

    // On simule l'erreur
    errorController.add(TaskUpdateError(message: "Modification impossible"));

    // On laisse le temps au listener de réagir et à l'animation de démarrer
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 750));

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text("Modification impossible"), findsOneWidget);

    errorController.close();
  });

  testWidgets("doit afficher le message précis de TaskUpdateError", (final tester) async {
    final errorController = StreamController<AppError>();
    when(() => mockProvider.errorStream).thenAnswer((_) => errorController.stream);

    await tester.pumpWidget(createWidgetUnderTest(tProject));

    // On simule l'erreur métier que nous avons créée
    errorController.add(TaskUpdateError(message: "Modification impossible : tâche finie"));

    await tester.pump(); // Déclenche le listener
    await tester.pump(const Duration(milliseconds: 750)); // Attend l'animation

    expect(find.text("Modification impossible : tâche finie"), findsOneWidget);

    final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
    expect(snackBar.backgroundColor, Colors.red);

    errorController.close();
  });

  testWidgets("doit afficher un message générique pour une UnknownError", (final tester) async {
    final errorController = StreamController<AppError>();
    when(() => mockProvider.errorStream).thenAnswer((_) => errorController.stream);

    await tester.pumpWidget(createWidgetUnderTest(tProject));

    // On simule une erreur imprévue
    errorController.add(UnknownError());

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 750));

    // Vérifie que le message par défaut de UnknownError est là
    expect(find.text("Une erreur inattendue est survenue"), findsOneWidget);

    errorController.close();
  });

  testWidgets("doit annuler l'abonnement au stream lors du dispose", (final tester) async {
    final errorController = StreamController<AppError>();
    when(() => mockProvider.errorStream).thenAnswer((_) => errorController.stream);

    await tester.pumpWidget(createWidgetUnderTest(tProject));

    // On remplace le widget par un autre pour forcer le dispose de ProjectDetailPage
    await tester.pumpWidget(const SizedBox());

    // On vérifie que le controller n'a plus d'écouteurs actifs (le cancel a fonctionné)
    expect(errorController.hasListener, isFalse);

    errorController.close();
  });
}
