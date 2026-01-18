import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:super_todo_app_mobile/features/projects/domain/entities/project.dart";
import "package:super_todo_app_mobile/features/projects/presentation/widgets/project_list_item.dart";

void main() {
  testWidgets("ProjectListItem doit afficher le nom et réagir aux clics", (tester) async {
    bool isTapped = false;
    bool isEdited = false;
    bool isDeleted = false;
    final tProject = Project(id: 1, name: "Test Project", createdAt: DateTime.now());

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProjectListItem(
            project: tProject,
            onTap: () => isTapped = true,
            onEdit: () => isEdited = true,
            onDelete: () => isDeleted = true,
          ),
        ),
      ),
    );

    // Vérifie l'affichage
    expect(find.text("Test Project"), findsOneWidget);

    // Test du clic sur la ligne
    await tester.tap(find.byType(ListTile));
    expect(isTapped, true);

    // Test du longTap sur la ligne
    await tester.longPress(find.byType(ListTile));
    expect(isEdited, true);

    // Test du clic sur la poubelle
    await tester.tap(find.byIcon(Icons.delete_outline));
    expect(isDeleted, true);
  });
}
