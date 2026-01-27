import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task_status.dart";
import "package:super_todo_app_mobile/features/tasks/presentation/widgets/task_list_item.dart";

void main() {
  testWidgets("TaskListItem doit afficher le nom et réagir aux clics", (final tester) async {
    bool isStatusChanged = false;
    bool isEdited = false;
    bool isDeleted = false;
    const tTask = Task(id: 1, title: "Test Task", projectId: 1);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskListItem(
            task: tTask,
            onTap: () => isEdited = true,
            onStatusChange: (final newStatus) => isStatusChanged = true,
            onDelete: () => isDeleted = true,
          ),
        ),
      ),
    );

    // Vérifie l'affichage
    expect(find.text("Test Task"), findsOneWidget);
    expect(find.byType(DropdownMenu<TaskStatus>), findsOneWidget);

    // Test du clic sur la ligne
    await tester.tap(find.byType(ListTile));
    expect(isEdited, true);

    // Test du changement de status de la ligne
    await tester.tap(find.byType(DropdownMenu<TaskStatus>));
    await tester.pumpAndSettle();
    await tester.tap(find.text("In Progress").last);
    await tester.pumpAndSettle();
    expect(isStatusChanged, true);

    // Test du drag pour supprimer
    await tester.drag(find.byKey(const Key("task_1")), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(isDeleted, true);
  });
}
