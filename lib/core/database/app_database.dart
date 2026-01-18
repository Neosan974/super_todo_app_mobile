import "dart:io";
import "package:drift/drift.dart";
import "package:drift/native.dart";
import "package:path_provider/path_provider.dart";
import "package:path/path.dart" as p;
import "package:super_todo_app_mobile/features/projects/data/datasources/project_dao.dart";

import "package:super_todo_app_mobile/features/projects/data/datasources/project_table.dart";
import "package:super_todo_app_mobile/features/tasks/data/datasources/task_dao.dart";
import "package:super_todo_app_mobile/features/tasks/data/datasources/task_table.dart";

part "app_database.g.dart";

@DriftDatabase(tables: [ProjectEntries, TaskEntries], daos: [ProjectDao, TaskDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  // On expose le DAO pour pouvoir l'utiliser dans le Repository
  @override
  ProjectDao get projectDao => ProjectDao(this);
  @override
  TaskDao get taskDao => TaskDao(this);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, "db.sqlite"));
    return NativeDatabase.createInBackground(file);
  });
}
