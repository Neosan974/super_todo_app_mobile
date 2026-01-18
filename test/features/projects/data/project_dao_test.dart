import "package:drift/native.dart";
import "package:flutter_test/flutter_test.dart";
import "package:drift/drift.dart";
import "package:super_todo_app_mobile/core/database/app_database.dart";
import "package:super_todo_app_mobile/features/projects/data/datasources/project_dao.dart";

void main() {
  late AppDatabase database;
  late ProjectDao projectDao;

  setUp(() {
    // On utilise une connexion Native en mémoire (sqlite3)
    database = AppDatabase(NativeDatabase.memory());
    projectDao = database.projectDao;
  });

  tearDown(() async {
    await database.close();
  });

  test("doit insérer un projet et le récupérer", () async {
    // 1. Arrange : Préparer l'entrée
    final folder = ProjectEntriesCompanion.insert(
      name: "Test Project",
      description: Value("Test Description"),
      createdAt: Value(DateTime.now()),
    );

    // 2. Act : Insérer
    await projectDao.insertProject(folder);
    final result = await projectDao.getAllProjects();

    // 3. Assert : Vérifier
    expect(result.length, 1);
    expect(result.first.name, "Test Project");
  });
}
