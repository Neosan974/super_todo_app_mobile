import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task.dart";
import "package:super_todo_app_mobile/features/tasks/presentation/widgets/task_list_item.dart";

void main() {
  testWidgets("TaskListItem doit afficher le nom et réagir aux clics", (tester) async {
    bool isToggled = false;
    bool isEdited = false;
    bool isDeleted = false;
    final tTask = Task(id: 1, title: "Test Task", projectId: 1, isCompleted: false);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskListItem(
            task: tTask,
            onTap: () => isEdited = true,
            onToggle: () => isToggled = true,
            onDelete: () => isDeleted = true,
          ),
        ),
      ),
    );

    // Vérifie l'affichage
    expect(find.text("Test Task"), findsOneWidget);
    expect(find.byType(Checkbox), findsOneWidget);

    // Test du clic sur la ligne
    await tester.tap(find.byType(ListTile));
    expect(isEdited, true);

    // Test du longTap sur la ligne
    await tester.tap(find.byType(Checkbox));
    expect(isToggled, true);

    // Test du drag pour supprimer
    await tester.drag(find.byKey(Key("task_1")), Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(isDeleted, true);
  });
}
