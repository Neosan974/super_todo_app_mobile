import "package:drift/drift.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task_status.dart";

class TaskStatusConverter extends TypeConverter<TaskStatus, String> {
  const TaskStatusConverter();

  @override
  TaskStatus fromSql(final String fromDb) => TaskStatus.values.byName(fromDb);

  @override
  String toSql(final TaskStatus value) => value.name;
}
