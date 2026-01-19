import "package:drift/native.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:super_todo_app_mobile/core/database/app_database.dart";
import "package:super_todo_app_mobile/main.dart" as app;
import "package:integration_test/integration_test.dart";

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Scénario d'Usage Complet", () {
    testWidgets("Parcours : Création projet -> Ajout tâche -> Completion", (tester) async {
      // Setup avec DB en mémoire pour repartir de zéro
      final testDb = AppDatabase(NativeDatabase.memory());
      app.main(db: testDb);
      await tester.pumpAndSettle();

      // --- 1. GESTION DU PROJET ---
      // Ajout
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(0), "Projet Intégration");
      await tester.tap(find.text("Créer"));
      await tester.pumpAndSettle();

      // Vérification et Navigation
      expect(find.text("Projet Intégration"), findsOneWidget);
      await tester.tap(find.text("Projet Intégration"));
      await tester.pumpAndSettle();

      // --- 2. GESTION DES TÂCHES ---
      // Vérifier qu'on est sur la page de détail (vide)
      expect(find.text("Aucune tâche pour ce projet."), findsOneWidget);

      // Ajouter une tâche
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), "Ma tâche critique");
      await tester.tap(find.text("Ajouter"));
      await tester.pumpAndSettle();

      expect(find.text("Ma tâche critique"), findsOneWidget);

      // --- 3. TEST DE LA RÈGLE MÉTIER ---
      // On complète la tâche
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      // Vérification de la persistance après navigation
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.text("Projet Intégration"));
      await tester.pumpAndSettle();

      // La tâche doit toujours être là et cochée
      final checkedCheckbox = find.byWidgetPredicate((widget) => widget is Checkbox && widget.value == true);
      expect(checkedCheckbox, findsOneWidget, reason: "La tâche devrait être cochée après réouverture du projet");

      // --- 4. SUPPRESSION ---
      // On retourne à l'accueil et on supprime le projet
      await tester.pageBack();
      await tester.pumpAndSettle();

      final projectItem = find.text("Projet Intégration");
      await tester.drag(projectItem, const Offset(-500.0, 0.0));
      await tester.pumpAndSettle();

      expect(find.text("Projet Intégration"), findsNothing);
    });
  });
}
