import "package:flutter/material.dart";
import "package:super_todo_app_mobile/features/projects/domain/entities/project.dart";

class ProjectListItem extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProjectListItem({
    super.key,
    required this.project,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(final BuildContext context) {
    return Dismissible(
      key: projectItemKey(project.id ?? 0),
      onDismissed: (final direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete();
        }
      },
      child: ListTile(
        key: Key("project_item_${project.id}"),
        title: Text(project.name),
        onLongPress: onEdit,
        onTap: onTap,
      ),
    );
  }

  static Key projectItemKey(final int projectId) => Key("project_$projectId");
}
