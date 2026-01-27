import "dart:async";

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:super_todo_app_mobile/features/projects/domain/entities/project.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task.dart";
import "package:super_todo_app_mobile/features/tasks/presentation/manager/task_provider.dart";
import "package:super_todo_app_mobile/features/tasks/presentation/widgets/task_form.dart";
import "package:super_todo_app_mobile/features/tasks/presentation/widgets/task_list_item.dart";

class ProjectDetailPage extends StatefulWidget {
  final Project project;

  static const newTaskButtonKey = Key("new_task_button");

  const ProjectDetailPage({super.key, required this.project});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  StreamSubscription? _errorSubscription;

  @override
  void initState() {
    super.initState();
    // On charge les tâches dès l'ouverture de la page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().fetchTasks(widget.project.id!);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _errorSubscription = context.read<TaskProvider>().errorStream.listen((final error) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    _errorSubscription?.cancel(); // Très important pour éviter les fuites mémoire
    super.dispose();
  }

  void _showTaskDialog(final BuildContext context, {final Task? taskToEdit}) {
    showDialog(
      context: context,
      builder: (final dialogContext) => AlertDialog(
        title: Text(taskToEdit == null ? "Nouvelle tâche" : "Modifier la tâche"),
        content: TaskForm(
          initialTitle: taskToEdit?.title,
          onSave: (final newTitle) async {
            final provider = context.read<TaskProvider>(); // On utilise le context de la page

            if (taskToEdit == null) {
              await provider.addTask(newTitle, widget.project.id!);
            } else {
              await provider.renameTask(taskToEdit, newTitle);
            }

            if (dialogContext.mounted) {
              Navigator.pop(dialogContext); // On ferme le dialogue via son propre context
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.project.name)),
      body: Consumer<TaskProvider>(
        builder: (final context, final provider, final child) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator());

          if (provider.tasks.isEmpty) {
            return const Center(child: Text("Aucune tâche pour ce projet."));
          }

          return ListView.builder(
            itemCount: provider.tasks.length,
            itemBuilder: (final context, final index) {
              final task = provider.tasks[index];
              return TaskListItem(
                task: task,
                onStatusChange: (final newStatus) async {
                  await provider.updateTaskStatus(task.copyWith(status: newStatus));
                },
                onDelete: () => provider.removeTask(task.id!, widget.project.id!),
                onTap: () => _showTaskDialog(context, taskToEdit: task),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        key: ProjectDetailPage.newTaskButtonKey,
        onPressed: () {
          _showTaskDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
