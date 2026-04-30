import 'package:dio/dio.dart';
import 'package:frontend/features/projects/models/project_model.dart';
import 'package:frontend/features/projects/models/project_with_task_count.dart';
import 'package:frontend/shared/api/clients/protected_client.dart';
import 'package:frontend/shared/api/errors/api_error.dart';
import 'package:frontend/shared/store/jwt_store.dart';
import 'package:get/get.dart';

class ProjectApi {
  late final JwtStore jwtStore = Get.find<JwtStore>();
  late final Dio dio = ProtectedClient(jwtStore).dio;

  Future<List<ProjectWithTaskCount>> getProjects(
    bool? isCompleted,
    bool? isArchived,
  ) async {
    try {
      final response = await dio.get('/project', queryParameters: {
        if (isCompleted != null) 'isCompleted': isCompleted,
        if (isArchived != null) 'isArchived': isArchived
      });
      final List<ProjectWithTaskCount> projects = (response.data as List)
          .map((e) => ProjectWithTaskCount.fromJson(e))
          .toList();

      return projects;
    } on DioException catch (e) {
      if (e.error is ApiError) {
        throw e.error as ApiError;
      }
      throw ApiError(
          message: e.message ?? 'Ошибка при запросе',
          errorCode: 'UNKNOWN_ERROR',
          timestamp: DateTime.now().toIso8601String());
    }
  }

  Future<ProjectWithTaskCount> createProject(
      String name, String description) async {
    try {
      final response = await dio
          .post('/project', data: {'name': name, 'description': description});

      return ProjectWithTaskCount.fromJson(response.data);
    } on DioException catch (e) {
      if (e.error is ApiError) {
        throw e.error as ApiError;
      }
      throw ApiError(
          message: e.message ?? 'Ошибка при запросе',
          errorCode: 'UNKNOWN_ERROR',
          timestamp: DateTime.now().toIso8601String());
    }
  }

  Future<ProjectModel> updateProject(
    int projectId,
    String name,
    String description,
  ) async {
    try {
      final response = await dio.patch(
        '/project/$projectId',
        data: {
          'name': name,
          'description': description,
        },
      );

      return ProjectModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.error is ApiError) {
        throw e.error as ApiError;
      }

      throw ApiError(
        message: e.message ?? 'Ошибка при обновлении проекта',
        errorCode: 'UNKNOWN_ERROR',
        timestamp: DateTime.now().toIso8601String(),
      );
    }
  }

  Future<ProjectModel> updateStatusProject(int id) async {
    try {
      final response = await dio.patch('/project/status/$id');

      return ProjectModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.error is ApiError) {
        throw e.error as ApiError;
      }

      throw ApiError(
        message: e.message ?? 'Ошибка при обновлении статуса',
        errorCode: 'UNKNOWN_ERROR',
        timestamp: DateTime.now().toIso8601String(),
      );
    }
  }

  Future<void> archivedProject(int id) async {
    try {
      await dio.delete('/project/$id');
    } on DioException catch (e) {
      if (e.error is ApiError) {
        throw e.error as ApiError;
      }

      throw ApiError(
        message: e.message ?? 'Ошибка при архивировании проекта',
        errorCode: 'UNKNOWN_ERROR',
        timestamp: DateTime.now().toIso8601String(),
      );
    }
  }
}
