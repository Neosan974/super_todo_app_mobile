import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:super_todo_app_mobile/features/projects/domain/entities/project.dart";
import "package:super_todo_app_mobile/features/projects/presentation/manager/project_provider.dart";
import "package:super_todo_app_mobile/features/projects/presentation/pages/project_detail_page.dart";
import "package:super_todo_app_mobile/features/projects/presentation/widgets/project_form.dart";
import "package:super_todo_app_mobile/features/projects/presentation/widgets/project_list_item.dart";

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({super.key});

  static final newProjectButtonKey = Key("new_project_button");

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  @override
  void initState() {
    super.initState();
    // On charge les projets dès que l'écran s'affiche
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectProvider>().fetchProjects();
    });
  }

  void _showProjectDialog(BuildContext context, {Project? project}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(project == null ? "Nouveau Projet" : "Modifier le projet"),
        content: ProjectForm(
          project: project,
          onSave: (name, description) {
            final provider = context.read<ProjectProvider>();

            if (project == null) {
              // Logique AJOUT
              provider.createProject(name, description);
            } else {
              // Logique MODIFICATION
              provider.editProject(
                Project(
                  id: project.id,
                  name: name,
                  description: description,
                  createdAt: project.createdAt,
                ),
              );
            }
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProjectProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Mes Projets")),
      body: Builder(
        builder: (context) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.projects.isEmpty) {
            return const Center(child: Text("Rien pour le moment"));
          }
          return ListView.builder(
            itemCount: provider.projects.length,
            itemBuilder: (context, index) {
              final project = provider.projects[index];

              return ProjectListItem(
                project: project,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProjectDetailPage(project: project),
                    ),
                  );
                },
                onEdit: () => _showProjectDialog(context, project: project),
                onDelete: () {
                  provider.removeProject(project.id!);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        key: ProjectListPage.newProjectButtonKey,
        onPressed: () {
          // C'est ici qu'on appellera plus tard notre AddProjectUseCase
          _showProjectDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
