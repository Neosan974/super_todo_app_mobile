import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/repositories/task_repository.dart";
import "package:super_todo_app_mobile/features/tasks/domain/usecases/toggle_task_status.dart";

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late ToggleTaskStatus usecase;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    usecase = ToggleTaskStatus(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(Task(title: "title", projectId: 1));
  });

  test("doit inverser le statut de la tâche et appeler le repository", () async {
    final tTask = Task(id: 1, title: "Test", isCompleted: true, projectId: 1);
    when(() => mockRepository.updateTask(any())).thenAnswer((_) async => {});

    await usecase.execute(tTask);

    verify(
      () => mockRepository.updateTask(any(that: isA<Task>().having((t) => t.isCompleted, "isCompleted", false))),
    ).called(1);
  });
}
