import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:super_todo_app_mobile/features/projects/domain/entities/project.dart";
import "package:super_todo_app_mobile/features/projects/domain/repositories/project_repository.dart";
import "package:super_todo_app_mobile/features/projects/domain/usecases/update_project.dart";

class MockProjectRepository extends Mock implements ProjectRepository {}

void main() {
  late UpdateProject usecase;
  late MockProjectRepository mockRepository;

  setUp(() {
    mockRepository = MockProjectRepository();
    usecase = UpdateProject(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(Project(name: "name", description: "description", createdAt: DateTime.now()));
  });

  final tProject = Project(
    id: 1,
    name: "Projet Modifié",
    description: "Nouvelle description",
    createdAt: DateTime.now(),
  );

  test("doit appeler le repository pour mettre à jour un projet", () async {
    // Arrange
    when(() => mockRepository.updateProject(any())).thenAnswer((_) async => {});

    // Act
    await usecase.execute(tProject);

    // Assert
    verify(() => mockRepository.updateProject(tProject)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
