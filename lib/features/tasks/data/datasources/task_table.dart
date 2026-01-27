import "package:drift/drift.dart";
import "package:super_todo_app_mobile/features/projects/data/datasources/project_table.dart";
import "package:super_todo_app_mobile/features/tasks/data/datasources/type_converters.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task_status.dart"; // Chemin vers ta table Project

class TaskEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get status =>
      text().map(const TaskStatusConverter()).check(status.isIn(TaskStatus.values.map((final e) => e.name)))();

  // La clé étrangère vers le projet
  IntColumn get projectId => integer().references(
    ProjectEntries,
    #id,
    onDelete: KeyAction.cascade, // Si on supprime le projet, on supprime ses tâches
  )();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
