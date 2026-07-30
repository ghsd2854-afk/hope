import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';
import 'package:hobe/features/profiles/mpdel/ProjectModel.dart';



class ProjectService {

  final Dio _dio = DioService().dio;

  final box = GetStorage();

  Future<List<ProjectModel>>
      getProjects() async {

    final token = box.read("token");

    final response = await _dio.get(
      ApiConstants.getProjects,
      options: Options(
        headers: {
          "Authorization":
              "Bearer $token",
        },
      ),
    );

    return (response.data as List)
        .map(
          (e) => ProjectModel.fromJson(e),
        )
        .toList();
  }

  Future<ProjectModel>
      createProject({
    required FormData data,
  }) async {

    final token = box.read("token");

    final response = await _dio.post(
      ApiConstants.createProject,
      data: data,
      options: Options(
        headers: {
          "Authorization":
              "Bearer $token",
        },
      ),
    );

    return ProjectModel.fromJson(
      response.data,
    );
  }

  Future<ProjectModel>
      updateProject({
    required int id,
    required FormData data,
  }) async {

    final token = box.read("token");

    final response = await _dio.post(
      "${ApiConstants.updateProject}/$id",
      data: data,
      options: Options(
        headers: {
          "Authorization":
              "Bearer $token",
        },
      ),
    );

    return ProjectModel.fromJson(
      response.data,
    );
  }

  Future<void> deleteProject(
    int id,
  ) async {

    final token = box.read("token");

    await _dio.delete(
      "${ApiConstants.deleteProject}/$id",
      options: Options(
        headers: {
          "Authorization":
              "Bearer $token",
        },
      ),
    );
  }
}