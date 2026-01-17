import "package:drift/native.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:super_todo_app_mobile/core/database/app_database.dart";
import "package:super_todo_app_mobile/main.dart" as app;
import "package:integration_test/integration_test.dart";

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Test de bout en bout", () {
    testWidgets("Scénario CRUD complet : Ajout, Modification et Suppression", (tester) async {
      final testDb = AppDatabase(NativeDatabase.memory());
      app.main(db: testDb);
      await tester.pumpAndSettle();

      // --- 1. CRÉATION ---
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), "Projet à supprimer");
      await tester.enterText(find.byType(TextField).at(1), "Sera supprimé à la fin");
      await tester.tap(find.text("Créer"));
      await tester.pumpAndSettle();

      expect(find.text("Projet à supprimer"), findsOneWidget);

      // --- 2. MODIFICATION ---
      await tester.longPress(find.text("Projet à supprimer"));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), "Projet Final");
      await tester.tap(find.text("Enregistrer"));
      await tester.pumpAndSettle();

      expect(find.text("Projet Final"), findsOneWidget);
      expect(find.text("Projet à supprimer"), findsNothing);

      // --- 3. SUPPRESSION PAR SWIPE ---

      // On identifie le widget à faire glisser
      final projectItem = find.text("Projet Final");

      // On simule un glissement vers la gauche (offset négatif sur l'axe X)
      // -500.0 est généralement suffisant pour déclencher l'action du Dismissible
      await tester.drag(projectItem, const Offset(-500.0, 0.0));

      // Très important : pumpAndSettle attend la fin de l'animation de glissement
      // et de la potentielle confirmation
      await tester.pumpAndSettle();

      // --- 4. VÉRIFICATION FINALE ---
      expect(find.text("Projet Final"), findsNothing);
    });
  });
}
