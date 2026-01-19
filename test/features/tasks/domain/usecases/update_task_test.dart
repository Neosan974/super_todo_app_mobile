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

  final tToDoTask = Task(id: 1, title: "Tâche mise à jour", isCompleted: false, projectId: 101);
  final tDoneTask = Task(id: 1, title: "Tâche mise à jour", isCompleted: true, projectId: 101);

  test("doit appeler le repository pour mettre à jour une tâche", () async {
    // Arrange
    when(() => mockRepository.updateTask(any())).thenAnswer((_) async => {});

    // Act
    await usecase.execute(tToDoTask);

    // Assert
    verify(() => mockRepository.updateTask(tToDoTask)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test("doit renvoyer une Failure (ou lever une Exception) quand on tente de modifier une tâche terminée", () async {
    // Assert
    // On vérifie que le Use Case bloque l'appel avant d'atteindre le repository
    expect(() => usecase.execute(tDoneTask), throwsA(isA<TaskUpdateError>()));
    verifyNever(() => mockRepository.updateTask(any()));
  });
}
