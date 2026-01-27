import "package:drift/drift.dart";
import "package:drift_flutter/drift_flutter.dart";
import "package:path_provider/path_provider.dart";
import "package:super_todo_app_mobile/core/database/app_database.steps.dart";
import "package:super_todo_app_mobile/features/projects/data/datasources/project_dao.dart";

import "package:super_todo_app_mobile/features/projects/data/datasources/project_table.dart";
import "package:super_todo_app_mobile/features/tasks/data/datasources/task_dao.dart";
import "package:super_todo_app_mobile/features/tasks/data/datasources/task_table.dart";
import "package:super_todo_app_mobile/features/tasks/data/datasources/type_converters.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task_status.dart";

part "app_database.g.dart";

@DriftDatabase(tables: [ProjectEntries, TaskEntries], daos: [ProjectDao, TaskDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase([final QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (final m) async {
        await m.createAll();
      },
      onUpgrade: stepByStep(
        from1To2: (final m, final schema) async {
          await m.addColumn(taskEntries, schema.taskEntries.status);
          await m.dropColumn(taskEntries, "is_completed");
        },
      ),
    );
  }

  // On expose le DAO pour pouvoir l'utiliser dans le Repository
  @override
  ProjectDao get projectDao => ProjectDao(this);
  @override
  TaskDao get taskDao => TaskDao(this);

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: "db.sqlite",
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
