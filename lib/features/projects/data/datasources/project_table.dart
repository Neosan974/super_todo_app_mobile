import "package:drift/drift.dart";

// Cette classe définit la table dans la base de données
class ProjectEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get description => text().named("body").nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
