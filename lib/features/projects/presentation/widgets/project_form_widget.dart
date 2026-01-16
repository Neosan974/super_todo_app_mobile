import "package:flutter/material.dart";
import "package:super_todo_app_mobile/features/projects/domain/entities/project.dart";

class ProjectFormWidget extends StatefulWidget {
  final Project? project; // Optionnel : si présent, on modifie, sinon on ajoute
  final Function(String name, String description) onSave;

  const ProjectFormWidget({super.key, this.project, required this.onSave});

  @override
  State<ProjectFormWidget> createState() => _ProjectFormWidgetState();
}

class _ProjectFormWidgetState extends State<ProjectFormWidget> {
  late TextEditingController _nameController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    // On initialise avec les valeurs existantes ou du texte vide
    _nameController = TextEditingController(text: widget.project?.name ?? "");
    _descController = TextEditingController(text: widget.project?.description ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: "Nom du projet"),
          autofocus: true,
        ),
        TextField(
          controller: _descController,
          decoration: const InputDecoration(labelText: "Description"),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => widget.onSave(_nameController.text, _descController.text),
          child: Text(widget.project == null ? "Créer" : "Enregistrer"),
        ),
      ],
    );
  }
}
