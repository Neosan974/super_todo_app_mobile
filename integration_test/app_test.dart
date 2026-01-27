import "package:drift/native.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:super_todo_app_mobile/core/database/app_database.dart";
import "package:super_todo_app_mobile/features/projects/presentation/pages/project_detail_page.dart";
import "package:super_todo_app_mobile/features/projects/presentation/pages/project_list_page.dart";
import "package:super_todo_app_mobile/features/projects/presentation/widgets/project_form.dart";
import "package:super_todo_app_mobile/features/projects/presentation/widgets/project_list_item.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task_status.dart";
import "package:super_todo_app_mobile/features/tasks/presentation/widgets/task_form.dart";
import "package:super_todo_app_mobile/features/tasks/presentation/widgets/task_list_item.dart";
import "package:super_todo_app_mobile/main.dart" as app;
import "package:integration_test/integration_test.dart";

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Scénario d'Usage Complet", () {
    testWidgets("Parcours : Création projet -> Ajout tâche -> Completion", (final tester) async {
      final robot = _AppRobot(tester: tester);
      // Setup avec DB en mémoire pour repartir de zéro
      final testDb = AppDatabase(NativeDatabase.memory());
      app.main(db: testDb);
      await tester.pumpAndSettle();

      // --- 1. GESTION DU PROJET ---
      // Ajout
      await robot.createProject("Projet Intégration");

      // Vérification et Navigation
      expect(find.text("Projet Intégration"), findsOneWidget);
      await robot.navigateInProject(1);

      // --- 2. GESTION DES TÂCHES ---
      // Vérifier qu'on est sur la page de détail (vide)
      expect(find.text("Aucune tâche pour ce projet."), findsOneWidget);

      // Ajouter une tâche
      await robot.createTask("Ma tâche critique");

      expect(find.text("Ma tâche critique"), findsOneWidget);

      // --- 3. TEST DE LA RÈGLE MÉTIER ---
      // On complète la tâche
      await robot.changeTaskStatus(1, TaskStatus.done);
      final doneChipFinder = find.descendant(
        of: find.byKey(TaskListItem.taskItemKey(1)),
        matching: find.widgetWithText(Chip, TaskStatus.done.label),
      );
      expect(doneChipFinder, findsOneWidget);

      // Vérification de la persistance après navigation
      await robot.navigateBack();
      await robot.navigateInProject(1);

      // La tâche doit toujours être là et cochée
      // final checkedCheckbox = find.byWidgetPredicate((final widget) => widget is Checkbox && widget.value == true);
      // expect(checkedCheckbox, findsOneWidget, reason: "La tâche devrait être cochée après réouverture du projet");

      // --- 4. SUPPRESSION ---
      // On retourne à l'accueil et on supprime le projet
      await robot.navigateBack();

      await robot.deleteProject(1);

      expect(find.text("Projet Intégration"), findsNothing);
    });
  });
}

class _AppRobot {
  final WidgetTester tester;
  const _AppRobot({required this.tester});

  Future<void> createProject(final String name) async {
    await tester.tap(find.byKey(ProjectListPage.newProjectButtonKey));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(ProjectForm.titleTextFieldKey), name);
    await tester.tap(find.byKey(ProjectForm.submitButtonKey));
    await tester.pumpAndSettle();
  }

  Future<void> navigateInProject(final int projectId) async {
    await tester.tap(find.byKey(ProjectListItem.projectItemKey(projectId)));
    await tester.pumpAndSettle();
  }

  Future<void> createTask(final String title) async {
    await tester.tap(find.byKey(ProjectDetailPage.newTaskButtonKey));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(TaskForm.textFieldKey), title);
    await tester.tap(find.byKey(TaskForm.submitButtonKey));
    await tester.pumpAndSettle();
  }

  Future<void> changeTaskStatus(final int taskId, final TaskStatus newStatus) async {
    final taskListItemFinder = find.byKey(TaskListItem.taskItemKey(taskId));
    final dropdownFinder = find.descendant(
      of: taskListItemFinder,
      matching: find.byType(DropdownMenu<TaskStatus>),
    );
    await tester.tap(dropdownFinder);
    await tester.pumpAndSettle();
    await tester.tap(find.text(newStatus.label).last);
    await tester.pumpAndSettle();
  }

  Future<void> navigateBack() async {
    await tester.pageBack();
    await tester.pumpAndSettle();
  }

  Future<void> deleteProject(final int projectId) async {
    await tester.drag(find.byKey(ProjectListItem.projectItemKey(projectId)), const Offset(-500.0, 0.0));
    await tester.pumpAndSettle();
  }
}
