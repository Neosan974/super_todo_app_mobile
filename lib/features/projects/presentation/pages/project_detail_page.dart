import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:super_todo_app_mobile/features/projects/domain/entities/project.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task.dart";
import "package:super_todo_app_mobile/features/tasks/presentation/manager/task_provider.dart";
import "package:super_todo_app_mobile/features/tasks/presentation/widgets/task_form.dart";
import "package:super_todo_app_mobile/features/tasks/presentation/widgets/task_list_item.dart";

class ProjectDetailPage extends StatefulWidget {
  final Project project;

  const ProjectDetailPage({super.key, required this.project});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  @override
  void initState() {
    super.initState();
    // On charge les tâches dès l'ouverture de la page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().fetchTasks(widget.project.id!);
    });
  }

  void _showTaskDialog(BuildContext context, {Task? taskToEdit}) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(taskToEdit == null ? "Nouvelle tâche" : "Modifier la tâche"),
        content: TaskForm(
          initialTitle: taskToEdit?.title,
          onSave: (newTitle) async {
            final provider = context.read<TaskProvider>(); // On utilise le context de la page

            if (taskToEdit == null) {
              await provider.addTask(newTitle, widget.project.id!);
            } else {
              await provider.renameTask(taskToEdit, newTitle);
            }

            if (context.mounted) {
              Navigator.pop(dialogContext); // On ferme le dialogue via son propre context
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.project.name)),
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator());

          if (provider.tasks.isEmpty) {
            return const Center(child: Text("Aucune tâche pour ce projet."));
          }

          return ListView.builder(
            itemCount: provider.tasks.length,
            itemBuilder: (context, index) {
              final task = provider.tasks[index];
              return TaskListItem(
                task: task,
                onToggle: () => provider.toggleTaskStatus(task),
                onDelete: () => provider.removeTask(task.id!, widget.project.id!),
                onTap: () => _showTaskDialog(context, taskToEdit: task),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTaskDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
