import "package:equatable/equatable.dart";

class Project extends Equatable {
  final int? id;
  final String name;
  final String description;
  final DateTime createdAt;

  const Project({
    this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, description, createdAt];
}
