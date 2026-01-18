import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:super_todo_app_mobile/core/database/app_database.dart";
import "package:super_todo_app_mobile/features/tasks/data/datasources/task_dao.dart";
import "package:super_todo_app_mobile/features/tasks/data/repositories/task_repository_impl.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task.dart";

class MockTaskDao extends Mock implements TaskDao {}

void main() {
  late TaskRepositoryImpl repository;
  late MockTaskDao mockTaskDao;

  const tProjectId = 1;
  const tTaskEntry = TaskEntry(
    id: 1,
    title: "Test Task",
    isCompleted: false,
    projectId: tProjectId,
  );
  final tTaskEntity = Task(
    id: 1,
    title: "Test Task",
    isCompleted: false,
    projectId: tProjectId,
  );

  setUp(() {
    mockTaskDao = MockTaskDao();
    repository = TaskRepositoryImpl(mockTaskDao);
  });

  setUpAll(() {
    registerFallbackValue(TaskEntriesCompanion());
  });

  test("addTask doit appeler le DAO avec les bonnes données", () async {
    // Arrange
    final tTask = Task(title: "New Task", projectId: 1);
    when(() => mockTaskDao.insertTask(any())).thenAnswer((_) async => 1);

    // Act
    await repository.addTask(tTask);

    // Assert
    verify(() => mockTaskDao.insertTask(any())).called(1);
  });

  group("getTasksByProject", () {
    test("doit retourner une liste de Task converties depuis les TaskEntry du DAO", () async {
      // Arrange : on simule le retour d'une liste d'objets "Data" (Drift)
      when(() => mockTaskDao.getTasksByProject(any())).thenAnswer((_) async => [tTaskEntry]);

      // Act : on appelle la méthode du repository
      final result = await repository.getTasksByProject(tProjectId);

      // Assert : on vérifie que la conversion en entité "Domain" a bien eu lieu
      expect(result, [tTaskEntity]);
      verify(() => mockTaskDao.getTasksByProject(tProjectId)).called(1);
    });
  });

  group("updateTask", () {
    test("doit appeler le DAO avec les bonnes valeurs de Companion", () async {
      // Arrange
      when(() => mockTaskDao.updateTask(any())).thenAnswer((_) async => true);

      // Act
      await repository.updateTask(tTaskEntity);

      // Assert : on vérifie que le DAO a reçu un Companion (objet Drift)
      verify(() => mockTaskDao.updateTask(any(that: isA<TaskEntriesCompanion>()))).called(1);
    });
  });

  group("deleteTask", () {
    test("doit appeler deleteTask du DAO avec l'ID correct", () async {
      // Arrange
      when(() => mockTaskDao.deleteTask(any())).thenAnswer((_) async => 1);

      // Act
      await repository.deleteTask(1);

      // Assert
      verify(() => mockTaskDao.deleteTask(1)).called(1);
    });
  });
}
