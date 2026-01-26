import "package:drift/native.dart";
import "package:flutter_test/flutter_test.dart";
import "package:super_todo_app_mobile/core/database/app_database.dart";
import "package:super_todo_app_mobile/features/tasks/data/datasources/task_dao.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task_status.dart";

void main() {
  late AppDatabase db;
  late TaskDao dao;

  setUp(() {
    // On crée une base de données Native en mémoire pour chaque test
    db = AppDatabase(NativeDatabase.memory());
    dao = TaskDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  test("doit insérer et récupérer une tâche", () async {
    // 1. Préparation des données (Companion requis par Drift pour l'insertion)
    final newTask = TaskEntriesCompanion.insert(
      title: "Ma nouvelle tâche",
      projectId: 1,
      status: TaskStatus.todo,
    );

    // 2. Action : Insertion
    await dao.insertTask(newTask);

    // 3. Vérification : Lecture
    final tasks = await dao.getTasksByProject(1);

    expect(tasks.length, 1);
    expect(tasks.first.title, "Ma nouvelle tâche");
    expect(tasks.first.projectId, 1);
    expect(tasks.first.status, TaskStatus.todo);
  });

  test("doit mettre à jour une tâche existante", () async {
    // 1. On insère une tâche initiale
    final initialTask = TaskEntriesCompanion.insert(
      title: "Tâche Initiale",
      projectId: 1,
      status: TaskStatus.todo,
    );
    final id = await dao.insertTask(initialTask);

    // 2. On prépare la version modifiée (avec le même ID)
    final updatedTask = TaskEntry(
      id: id,
      title: "Tâche Mise à jour",
      status: TaskStatus.todo,
      projectId: 1,
    );

    // 3. Action : Appel de la ligne 20
    final result = await dao.updateTask(updatedTask.toCompanion(true));

    // 4. Assertions
    expect(result, isTrue);
    final fetched = await dao.getTasksByProject(1);
    expect(fetched.first.title, "Tâche Mise à jour");
    expect(fetched.first.status, equals(TaskStatus.todo));
  });

  test("doit supprimer une tâche", () async {
    final newTask = TaskEntriesCompanion.insert(
      title: "Tâche à supprimer",
      projectId: 1,
      status: TaskStatus.todo,
    );
    final id = await dao.insertTask(newTask);

    // Suppression
    await dao.deleteTask(id);

    final tasks = await dao.getTasksByProject(1);
    expect(tasks, isEmpty);
  });
}
