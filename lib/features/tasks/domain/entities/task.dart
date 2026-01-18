class Task {
  final int? id;
  final String title;
  final bool isCompleted;
  final int projectId; // Le lien vers le projet parent

  Task({
    this.id,
    required this.title,
    this.isCompleted = false,
    required this.projectId,
  });

  // Optionnel : un helper pour copier l'objet avec des modifications (utile pour le toggle)
  Task copyWith({
    int? id,
    String? title,
    bool? isCompleted,
    int? projectId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      projectId: projectId ?? this.projectId,
    );
  }
}
