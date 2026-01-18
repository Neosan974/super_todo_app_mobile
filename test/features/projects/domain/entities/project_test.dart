import "package:flutter_test/flutter_test.dart";
import "package:super_todo_app_mobile/features/projects/domain/entities/project.dart";

void main() {
  group("Project Entity", () {
    final tDate = DateTime(2024, 1, 1);

    final tProject1 = Project(
      id: 1,
      name: "Test Project",
      createdAt: tDate,
      description: "Description",
    );

    final tProject2 = Project(
      id: 1,
      name: "Test Project",
      createdAt: tDate,
      description: "Description",
    );

    test("doit supporter la comparaison par valeur (Equatable)", () {
      // Cette ligne force l'exécution de 'get props'
      expect(tProject1, equals(tProject2));
    });
  });
}
