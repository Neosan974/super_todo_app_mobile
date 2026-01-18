import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/repositories/task_repository.dart";
import "package:super_todo_app_mobile/features/tasks/domain/usecases/update_task.dart";

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late UpdateTask usecase;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    usecase = UpdateTask(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(Task(title: "title", projectId: 1));
  });

  final tTask = Task(
    id: 1,
    title: "Tâche mise à jour",
    isCompleted: true,
    projectId: 101,
  );

  test("doit appeler le repository pour mettre à jour une tâche", () async {
    // Arrange
    when(() => mockRepository.updateTask(any())).thenAnswer((_) async => {});

    // Act
    await usecase.execute(tTask);

    // Assert
    verify(() => mockRepository.updateTask(tTask)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
