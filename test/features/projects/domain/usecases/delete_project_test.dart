import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:super_todo_app_mobile/features/projects/domain/repositories/project_repository.dart";
import "package:super_todo_app_mobile/features/projects/domain/usecases/delete_project.dart";

class MockProjectRepository extends Mock implements ProjectRepository {}

void main() {
  late DeleteProject usecase;
  late MockProjectRepository mockRepository;

  setUp(() {
    mockRepository = MockProjectRepository();
    usecase = DeleteProject(mockRepository);
  });

  const tProjectId = 1;

  test("doit appeler le repository pour supprimer un projet via son ID", () async {
    // Arrange
    when(() => mockRepository.deleteProject(any())).thenAnswer((_) async => {});

    // Act
    await usecase.execute(tProjectId);

    // Assert
    verify(() => mockRepository.deleteProject(tProjectId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
