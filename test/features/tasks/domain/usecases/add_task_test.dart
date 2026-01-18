import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/repositories/task_repository.dart";
import "package:super_todo_app_mobile/features/tasks/domain/usecases/add_task.dart";

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late AddTask usecase;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    usecase = AddTask(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(Task(title: "title", projectId: 1));
  });

  final tTask = Task(title: "Test", projectId: 1);

  test("doit appeler le repository pour ajouter une tâche", () async {
    when(() => mockRepository.addTask(any())).thenAnswer((_) async => {});

    await usecase.execute(tTask);

    verify(() => mockRepository.addTask(tTask)).called(1);
  });
}
