import 'package:frontend/features/projects/api/project_api.dart';
import 'package:frontend/features/projects/models/project_with_task_count.dart';
import 'package:frontend/shared/api/errors/api_error.dart';
import 'package:get/get.dart';

class ProjectController extends GetxController {
  final ProjectApi _projectApi = ProjectApi();

  var loading = false.obs;
  var error = ''.obs;
  bool? _lastIsCompleted;
  bool? _lastIsArchived;
  final RxList<ProjectWithTaskCount> projects = <ProjectWithTaskCount>[].obs;

  Future<void> loadProjects(bool? isCompleted, bool? isArchived) async {
    try {
      loading.value = true;
      error.value = '';

      _lastIsCompleted = isCompleted;
      _lastIsArchived = isArchived;

      final result = await _projectApi.getProjects(isCompleted, isArchived);
      projects.assignAll(result);
    } on ApiError catch (e) {
      error.value = e.message;
    } finally {
      loading.value = false;
    }
  }

  Future<void> createProject(String name, String description) async {
    try {
      loading.value = true;
      error.value = '';

      final result = await _projectApi.createProject(name, description);

      final matchesCompleted = _lastIsCompleted == null ||
          result.project.isCompleted == _lastIsCompleted;

      final matchesArchived = _lastIsArchived == null ||
          result.project.isArchived == _lastIsArchived;

      if (matchesCompleted && matchesArchived) {
        projects.insert(0, result);
      }
    } on ApiError catch (e) {
      error.value = e.message;
    } finally {
      loading.value = false;
    }
  }
}
