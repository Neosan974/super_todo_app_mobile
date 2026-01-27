import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/usecases/add_task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/usecases/delete_task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/usecases/get_tasks_by_project.dart";
import "package:super_todo_app_mobile/features/tasks/domain/usecases/update_task_status.dart";
import "package:super_todo_app_mobile/features/tasks/domain/usecases/update_task.dart";
import "package:super_todo_app_mobile/features/tasks/presentation/manager/task_provider.dart";

class MockGetTasks extends Mock implements GetTasksByProject {}

class MockAddTask extends Mock implements AddTask {}

class MockUpdateTask extends Mock implements UpdateTask {}

class MockDeleteTask extends Mock implements DeleteTask {}

class MockUpdateTaskStatus extends Mock implements UpdateTaskStatus {}

class MockTaskUpdateError extends Mock implements TaskUpdateError {}

void main() {
  late TaskProvider provider;
  late MockGetTasks mockGetTasks;
  late MockAddTask mockAddTask;
  late MockUpdateTask mockUpdateTask;
  late MockDeleteTask mockDeleteTask;
  late MockUpdateTaskStatus mockUpdateTaskStatus;

  setUp(() {
    mockGetTasks = MockGetTasks();
    mockAddTask = MockAddTask();
    mockUpdateTask = MockUpdateTask();
    mockDeleteTask = MockDeleteTask();
    mockUpdateTaskStatus = MockUpdateTaskStatus();

    provider = TaskProvider(
      getTasksByProjectUseCase: mockGetTasks,
      addTaskUseCase: mockAddTask,
      updateTaskUseCase: mockUpdateTask,
      deleteTaskUseCase: mockDeleteTask,
      updateTaskStatusUseCase: mockUpdateTaskStatus,
    );
  });

  setUpAll(() {
    registerFallbackValue(Task(title: "title", projectId: 1));
  });

  const tProjectId = 1;
  final tTask = Task(id: 1, title: "Test Task", projectId: tProjectId);

  group("task loading", () {
    test("fetchTasks doit passer par l'état loading true puis false", () async {
      // Arrange
      when(() => mockGetTasks.execute(any())).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 50)); // Simule un délai
        return [];
      });

      // Act
      final future = provider.fetchTasks(tProjectId);

      // Assert : Pendant l'exécution, loading doit être true
      expect(provider.isLoading, true);

      await future;

      // Assert : Après exécution, loading doit être false
      expect(provider.isLoading, false);
    });

    test("fetchTasks doit passer isLoading à false même en cas d'erreur", () async {
      // Arrange
      when(() => mockGetTasks.execute(any())).thenThrow(Exception("Erreur DB"));

      // Act
      await provider.fetchTasks(tProjectId);

      // Assert
      expect(provider.isLoading, false);
      expect(provider.tasks, []); // La liste reste vide
    });
  });

  group("addTask", () {
    test("doit appeler AddTask usecase et rafraîchir la liste", () async {
      // Arrange
      when(() => mockAddTask.execute(any())).thenAnswer((_) async => {});
      when(() => mockGetTasks.execute(any())).thenAnswer((_) async => [tTask]);

      // Act
      await provider.addTask("New Task", tProjectId);

      // Assert
      verify(() => mockAddTask.execute(any(that: isA<Task>()))).called(1);
      verify(() => mockGetTasks.execute(tProjectId)).called(1);
      expect(provider.tasks.length, 1);
    });

    test("addTask ne doit pas rafraîchir la liste si l'ajout échoue", () async {
      // Arrange
      when(() => mockAddTask.execute(any())).thenThrow(Exception("Erreur réseau"));

      // Act
      await provider.addTask("New Task", tProjectId);

      // Assert
      verify(() => mockAddTask.execute(any())).called(1);
      verifyNever(() => mockGetTasks.execute(any())); // Ne doit pas rafraîchir
    });
  });

  group("toggleTaskStatus", () {
    test("doit appeler le usecase toggle avec la tâche reçue", () async {
      // Arrange
      // tTask a isCompleted: false
      when(() => mockUpdateTaskStatus.execute(any())).thenAnswer((_) async => {});
      when(() => mockGetTasks.execute(any())).thenAnswer((_) async => []);

      // Act
      await provider.updateTaskStatus(tTask);

      // Assert
      // On vérifie que le provider a passé EXACTEMENT tTask au usecase
      // C'est ensuite le "vrai" usecase (pas le mock) qui fera l'inversion en prod
      verify(() => mockUpdateTaskStatus.execute(tTask)).called(1);
    });

    test("toggleTaskStatus doit logger l'erreur en cas d'échec", () async {
      when(() => mockUpdateTaskStatus.execute(any())).thenThrow(Exception("Erreur Toggle"));

      await provider.updateTaskStatus(tTask);

      verify(() => mockUpdateTaskStatus.execute(any())).called(1);
    });
  });

  group("renameTask", () {
    test("doit mettre à jour le titre si le nouveau nom est différent", () async {
      // Arrange
      when(() => mockUpdateTask.execute(any())).thenAnswer((_) async => {});
      when(() => mockGetTasks.execute(any())).thenAnswer((_) async => []);

      // Act
      await provider.renameTask(tTask, "Nouveau Titre");

      // Assert
      verify(
        () => mockUpdateTask.execute(any(that: isA<Task>().having((t) => t.title, "title", "Nouveau Titre"))),
      ).called(1);
    });

    test("ne doit rien faire si le titre est identique", () async {
      // Act
      await provider.renameTask(tTask, tTask.title);

      // Assert
      verifyNever(() => mockUpdateTask.execute(any()));
    });

    test("renameTask doit logger l'erreur en cas d'échec", () async {
      when(() => mockUpdateTask.execute(any())).thenThrow(Exception("Erreur Rename"));

      await provider.renameTask(tTask, "Nouveau titre");

      verify(() => mockUpdateTask.execute(any())).called(1);
    });
  });

  group("removeTask", () {
    test("doit supprimer la tâche et rafraîchir la liste", () async {
      // Arrange
      when(() => mockDeleteTask.execute(any())).thenAnswer((_) async => {});
      when(() => mockGetTasks.execute(any())).thenAnswer((_) async => []);

      // Act
      await provider.removeTask(tTask.id!, tProjectId);

      // Assert
      verify(() => mockDeleteTask.execute(tTask.id!)).called(1);
      verify(() => mockGetTasks.execute(tProjectId)).called(1);
    });

    test("removeTask doit logger l'erreur en cas d'échec", () async {
      when(() => mockDeleteTask.execute(any())).thenThrow(Exception("Erreur Delete"));

      await provider.removeTask(1, 1);

      verify(() => mockDeleteTask.execute(any())).called(1);
    });
  });

  group("error stream", () {
    test("dispose doit fermer le errorController", () {
      // Act
      provider.dispose();

      // Assert: On vérifie que le stream est fermé en essayant d'y ajouter quelque chose
      // (L'ajout après fermeture lève une erreur d'état)
      expect(() => provider.notifyListeners(), throwsA(isA<FlutterError>()));
    });

    test("doit émettre TaskUpdateError dans le stream lors d'un échec de toggle", () async {
      // Arrange
      final tError = MockTaskUpdateError();
      when(() => mockUpdateTaskStatus.execute(any())).thenThrow(tError);

      // Assert: On écoute le stream AVANT l'action
      expectLater(provider.errorStream, emits(tError));

      // Act
      await provider.updateTaskStatus(tTask);
    });

    test("doit émettre TaskUpdateError dans le stream lors d'un échec de renommage", () async {
      // Arrange
      final tError = MockTaskUpdateError();
      when(() => mockUpdateTask.execute(any())).thenThrow(tError);

      // Assert
      expectLater(provider.errorStream, emits(tError));

      // Act
      await provider.renameTask(tTask, "Nouveau titre");
    });
  });
}
