import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:super_todo_app_mobile/features/projects/domain/entities/project.dart";
import "package:super_todo_app_mobile/features/projects/domain/repositories/project_repository.dart";
import "package:super_todo_app_mobile/features/projects/domain/usecases/add_project.dart";

class MockProjectRepository extends Mock implements ProjectRepository {}

void main() {
  late AddProject usecase;
  late MockProjectRepository mockRepository;

  setUp(() {
    mockRepository = MockProjectRepository();
    usecase = AddProject(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(Project(name: "name", description: "description", createdAt: DateTime.now()));
  });

  final tProject = Project(name: "Test", description: "Desc", createdAt: DateTime.now());

  test("doit appeler le repository pour ajouter un projet", () async {
    // Arrange
    when(() => mockRepository.addProject(any())).thenAnswer((_) async => {});

    // Act
    await usecase.execute(tProject);

    // Assert
    verify(() => mockRepository.addProject(tProject)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
