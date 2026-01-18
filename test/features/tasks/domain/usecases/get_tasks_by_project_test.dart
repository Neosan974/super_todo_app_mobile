import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/repositories/task_repository.dart";
import "package:super_todo_app_mobile/features/tasks/domain/usecases/get_tasks_by_project.dart";

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late GetTasksByProject usecase;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    usecase = GetTasksByProject(mockRepository);
  });

  const tProjectId = 1;
  final tTasks = [
    Task(id: 1, title: "Test Task", projectId: tProjectId),
  ];

  test("doit récupérer les tâches du repository pour un projet donné", () async {
    // Arrange
    when(() => mockRepository.getTasksByProject(any())).thenAnswer((_) async => tTasks);

    // Act
    final result = await usecase.execute(tProjectId);

    // Assert
    expect(result, tTasks);
    verify(() => mockRepository.getTasksByProject(tProjectId)).called(1);
  });
}
