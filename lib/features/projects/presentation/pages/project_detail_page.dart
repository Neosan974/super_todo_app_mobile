import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:super_todo_app_mobile/features/projects/domain/entities/project.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task.dart";
import "package:super_todo_app_mobile/features/tasks/presentation/manager/task_provider.dart";

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
    // Si on édite, on pré-remplit le contrôleur avec le titre actuel
    final controller = TextEditingController(text: taskToEdit?.title ?? "");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(taskToEdit == null ? "Nouvelle tâche" : "Modifier la tâche"),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: "Nom de la tâche"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                final provider = context.read<TaskProvider>();
                if (taskToEdit == null) {
                  await provider.addTask(name, widget.project.id!);
                } else {
                  await provider.renameTask(taskToEdit, name);
                }
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text("Enregistrer"),
          ),
        ],
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
              // Dans le ListView.builder :
              return Dismissible(
                key: Key(task.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  context.read<TaskProvider>().removeTask(task.id!, widget.project.id!);
                },
                child: ListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  onTap: () => _showTaskDialog(context, taskToEdit: task),
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) {
                      context.read<TaskProvider>().toggleTaskStatus(task);
                    },
                  ),
                ),
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
