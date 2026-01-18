// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_dao.dart';

// ignore_for_file: type=lint
mixin _$TaskDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProjectEntriesTable get projectEntries => attachedDatabase.projectEntries;
  $TaskEntriesTable get taskEntries => attachedDatabase.taskEntries;
  TaskDaoManager get managers => TaskDaoManager(this);
}

class TaskDaoManager {
  final _$TaskDaoMixin _db;
  TaskDaoManager(this._db);
  $$ProjectEntriesTableTableManager get projectEntries =>
      $$ProjectEntriesTableTableManager(
        _db.attachedDatabase,
        _db.projectEntries,
      );
  $$TaskEntriesTableTableManager get taskEntries =>
      $$TaskEntriesTableTableManager(_db.attachedDatabase, _db.taskEntries);
}
