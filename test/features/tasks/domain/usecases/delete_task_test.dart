import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:super_todo_app_mobile/features/tasks/domain/repositories/task_repository.dart";
import "package:super_todo_app_mobile/features/tasks/domain/usecases/delete_task.dart";

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late DeleteTask usecase;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    usecase = DeleteTask(mockRepository);
  });

  const tTaskId = 1;

  test("doit appeler le repository pour supprimer une tâche via son ID", () async {
    // Arrange
    when(() => mockRepository.deleteTask(any())).thenAnswer((_) async => {});

    // Act
    await usecase.execute(tTaskId);

    // Assert
    verify(() => mockRepository.deleteTask(tTaskId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
