import "package:drift/drift.dart";
import "package:super_todo_app_mobile/features/projects/data/datasources/project_table.dart"; // Chemin vers ta table Project

class TaskEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  // La clé étrangère vers le projet
  IntColumn get projectId => integer().references(
    ProjectEntries,
    #id,
    onDelete: KeyAction.cascade, // Si on supprime le projet, on supprime ses tâches
  )();
}
