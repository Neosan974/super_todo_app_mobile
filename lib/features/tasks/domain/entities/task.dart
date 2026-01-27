import "package:equatable/equatable.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task_status.dart";

class Task extends Equatable {
  final int? id;
  final String title;
  final int projectId;
  final TaskStatus status;

  const Task({
    this.id,
    required this.title,
    required this.projectId,
    this.status = TaskStatus.todo,
  });

  @override
  List<Object?> get props => [id, title, projectId, status];

  // Optionnel : un helper pour copier l'objet avec des modifications (utile pour le toggle)
  Task copyWith({
    final int? id,
    final String? title,
    final int? projectId,
    final TaskStatus? status,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      projectId: projectId ?? this.projectId,
      status: status ?? this.status,
    );
  }
}
