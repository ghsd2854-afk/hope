import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';
import 'package:hobe/features/profiles/mpdel/experience_model.dart';



class ExperienceService {

  final Dio _dio = DioService().dio;

  final box = GetStorage();

  Future<List<ExperienceModel>>
      getExperiences() async {

    final token = box.read("token");

    final response = await _dio.get(
      ApiConstants.getExperiences,
      options: Options(
        headers: {
          "Authorization":
              "Bearer $token",
        },
      ),
    );

    return (response.data as List)
        .map(
          (e) =>
              ExperienceModel.fromJson(e),
        )
        .toList();
  }

  Future<ExperienceModel>
      createExperience({
    required FormData data,
  }) async {

    final token = box.read("token");

    final response = await _dio.post(
      ApiConstants.createExperience,
      data: data,
      options: Options(
        headers: {
          "Authorization":
              "Bearer $token",
        },
      ),
    );

    return ExperienceModel.fromJson(
      response.data,
    );
  }

  Future<ExperienceModel>
      updateExperience({
    required int id,
    required FormData data,
  }) async {

    final token = box.read("token");

    final response = await _dio.post(
      "${ApiConstants.updateExperience}/$id",
      data: data,
      options: Options(
        headers: {
          "Authorization":
              "Bearer $token",
        },
      ),
    );

    return ExperienceModel.fromJson(
      response.data,
    );
  }

  Future<void> deleteExperience(
    int id,
  ) async {

    final token = box.read("token");

    await _dio.delete(
      "${ApiConstants.deleteExperience}/$id",
      options: Options(
        headers: {
          "Authorization":
              "Bearer $token",
        },
      ),
    );
  }
}