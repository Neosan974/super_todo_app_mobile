import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:super_todo_app_mobile/features/projects/domain/entities/project.dart";
import "package:super_todo_app_mobile/features/projects/domain/repositories/project_repository.dart";
import "package:super_todo_app_mobile/features/projects/domain/usecases/get_projects.dart";

class MockProjectRepository extends Mock implements ProjectRepository {}

void main() {
  late GetProjects usecase;
  late MockProjectRepository mockRepository;

  setUp(() {
    mockRepository = MockProjectRepository();
    usecase = GetProjects(mockRepository);
  });

  final tProjects = [Project(id: 1, name: "Test", description: "Desc", createdAt: DateTime.now())];

  test("doit récupérer les projets du repository", () async {
    // Arrange (On prépare le mock)
    when(() => mockRepository.getAllProjects()).thenAnswer((_) async => tProjects);

    // Act (On lance l'action)
    final result = await usecase.execute();

    // Assert (On vérifie le résultat et l'appel)
    expect(result, tProjects);
    verify(() => mockRepository.getAllProjects()).called(1);
  });
}
