class ProjectModel {
  final int id;
  final String name;
  final String description;
  final bool isCompleted;
  final bool isArchived;

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.isCompleted,
    required this.isArchived,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      isCompleted: json['isCompleted'],
      isArchived: json['isArchived'],
    );
  }
}
