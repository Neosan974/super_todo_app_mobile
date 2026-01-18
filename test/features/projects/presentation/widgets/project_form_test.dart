import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:super_todo_app_mobile/features/projects/presentation/widgets/project_form.dart";

void main() {
  testWidgets("ProjectForm doit valider et soumettre le texte", (tester) async {
    String? submittedName;
    String? submittedDescription;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProjectForm(
            onSave: (name, description) {
              submittedName = name;
              submittedDescription = description;
            },
          ),
        ),
      ),
    );

    // 1. On vérifie l'état initial
    expect(find.byKey(ProjectForm.titleTextFieldKey), findsOneWidget);
    expect(find.byKey(ProjectForm.descriptionTextFieldKey), findsOneWidget);

    // 2. On saisit un nom de projet
    await tester.enterText(find.byKey(ProjectForm.titleTextFieldKey), "Nouveau nom de projet");
    await tester.enterText(find.byKey(ProjectForm.descriptionTextFieldKey), "Nouvelle description");

    // 3. On appuie sur le bouton de soumission
    await tester.tap(find.byKey(ProjectForm.submitButtonKey));
    await tester.pump();

    // 4. On vérifie que la callback a bien été appelée avec la bonne valeur
    expect(submittedName, "Nouveau nom de projet");
    expect(submittedDescription, "Nouvelle description");
  });
}
