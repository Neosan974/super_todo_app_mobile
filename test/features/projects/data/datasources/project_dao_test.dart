import "package:drift/native.dart";
import "package:flutter_test/flutter_test.dart";
import "package:super_todo_app_mobile/core/database/app_database.dart";
import "package:super_todo_app_mobile/features/projects/data/datasources/project_dao.dart";

void main() {
  late AppDatabase db;
  late ProjectDao dao;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    dao = ProjectDao(db);
  });

  tearDown(() async => await db.close());

  test("doit mettre à jour un projet existant", () async {
    // 1. Insertion initiale
    final id = await dao.insertProject(ProjectEntriesCompanion.insert(name: "Ancien Nom"));

    // 2. Mise à jour
    final updatedProject = ProjectEntry(id: id, name: "Nouveau Nom", createdAt: DateTime.now());
    final result = await dao.updateProject(updatedProject.toCompanion(true));

    // 3. Vérification
    expect(result, isTrue);
    final projects = await dao.getAllProjects();
    expect(projects.first.name, "Nouveau Nom");
  });

  test("doit insérer et récupérer un projet", () async {
    final newProject = ProjectEntriesCompanion.insert(name: "Projet Test");

    await dao.insertProject(newProject);
    final projects = await dao.getAllProjects();

    expect(projects.length, 1);
    expect(projects.first.name, "Projet Test");
  });

  test("doit supprimer un projet", () async {
    final id = await dao.insertProject(ProjectEntriesCompanion.insert(name: "A supprimer"));
    await dao.deleteProjectById(id);

    final projects = await dao.getAllProjects();
    expect(projects, isEmpty);
  });
}
