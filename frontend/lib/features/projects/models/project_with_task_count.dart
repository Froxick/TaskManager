import 'package:frontend/features/projects/models/project_model.dart';

class ProjectWithTaskCount {
  final ProjectModel project;
  final int totalTasksCount;
  final int completedTasksCount;

  ProjectWithTaskCount({
    required this.project,
    required this.totalTasksCount,
    required this.completedTasksCount,
  });

  factory ProjectWithTaskCount.fromJson(Map<String, dynamic> json) {
    return ProjectWithTaskCount(
      project: ProjectModel.fromJson(json['project']),
      totalTasksCount: json['totalTasksCount'] ?? 0,
      completedTasksCount: json['completedTasksCount'] ?? 0,
    );
  }
}
