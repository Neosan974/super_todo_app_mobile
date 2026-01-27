import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task_status.dart";
import "package:super_todo_app_mobile/features/tasks/domain/repositories/task_repository.dart";
import "package:super_todo_app_mobile/features/tasks/domain/usecases/update_task_status.dart";

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late UpdateTaskStatus usecase;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    usecase = UpdateTaskStatus(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(const Task(title: "title", projectId: 1));
  });

  const tToDoTask = Task(id: 1, title: "Tâche mise à jour", projectId: 101, status: TaskStatus.todo);

  test("doit appeler le repository pour mettre à jour une tâche", () async {
    // Arrange
    when(() => mockRepository.updateTask(any())).thenAnswer((_) async => {});

    // Act
    await usecase.execute(tToDoTask);

    // Assert
    verify(() => mockRepository.updateTask(tToDoTask)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
