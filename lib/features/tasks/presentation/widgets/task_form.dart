import "package:flutter/material.dart";

class TaskForm extends StatefulWidget {
  // Définition des clés comme constantes statiques pour les réutiliser dans les tests
  static const textFieldKey = Key("task_form_text_field");
  static const submitButtonKey = Key("task_form_submit_button");

  final String? initialTitle;
  final Function(String) onSave;

  const TaskForm({super.key, this.initialTitle, required this.onSave});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialTitle);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          key: TaskForm.textFieldKey,
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: "Nom de la tâche"),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          key: TaskForm.submitButtonKey,
          onPressed: () => widget.onSave(_controller.text),
          child: Text(widget.initialTitle == null ? "Ajouter" : "Enregistrer"),
        ),
      ],
    );
  }
}
