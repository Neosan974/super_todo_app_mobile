import "package:flutter/material.dart";
import "package:super_todo_app_mobile/features/projects/domain/entities/project.dart";

class ProjectForm extends StatefulWidget {
  static const titleTextFieldKey = Key("project_form_title_text_field");
  static const descriptionTextFieldKey = Key("project_form_description_text_field");
  static const submitButtonKey = Key("project_form_submit_button");

  final Project? project; // Optionnel : si présent, on modifie, sinon on ajoute
  final Function(String name, String description) onSave;

  const ProjectForm({super.key, this.project, required this.onSave});

  @override
  State<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> {
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
          key: ProjectForm.titleTextFieldKey,
          controller: _nameController,
          decoration: const InputDecoration(labelText: "Nom du projet"),
          autofocus: true,
        ),
        TextField(
          key: ProjectForm.descriptionTextFieldKey,
          controller: _descController,
          decoration: const InputDecoration(labelText: "Description"),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          key: ProjectForm.submitButtonKey,
          onPressed: () => widget.onSave(_nameController.text, _descController.text),
          child: Text(widget.project == null ? "Créer" : "Enregistrer"),
        ),
      ],
    );
  }
}
