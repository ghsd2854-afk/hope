import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';
import 'package:hobe/features/profiles/mpdel/EducationModel.dart';



class EducationService {

  final Dio _dio = DioService().dio;

  final box = GetStorage();

  Future<List<EducationModel>>
      getEducations() async {

    final token = box.read("token");

    final response = await _dio.get(
      ApiConstants.getEducations,
      options: Options(
        headers: {
          "Authorization":
              "Bearer $token",
        },
      ),
    );

    return (response.data as List)
        .map(
          (e) => EducationModel.fromJson(e),
        )
        .toList();
  }

  Future<EducationModel>
      createEducation({
    required FormData data,
  }) async {

    final token = box.read("token");

    final response = await _dio.post(
      ApiConstants.createEducation,
      data: data,
      options: Options(
        headers: {
          "Authorization":
              "Bearer $token",
          "Content-Type":
              "multipart/form-data",
        },
      ),
    );

    return EducationModel.fromJson(
      response.data,
    );
  }

  Future<EducationModel>
      updateEducation({
    required int id,
    required FormData data,
  }) async {

    final token = box.read("token");

    final response = await _dio.post(
      "${ApiConstants.updateEducation}/$id",
      data: data,
      options: Options(
        headers: {
          "Authorization":
              "Bearer $token",
          "Content-Type":
              "multipart/form-data",
        },
      ),
    );

    return EducationModel.fromJson(
      response.data,
    );
  }

  Future<void> deleteEducation(
    int id,
  ) async {

    final token = box.read("token");

    await _dio.delete(
      "${ApiConstants.deleteEducation}/$id",
      options: Options(
        headers: {
          "Authorization":
              "Bearer $token",
        },
      ),
    );
  }

  Future<EducationModel>
      getEducationDetails(
    int id,
  ) async {

    final token = box.read("token");

    final response = await _dio.get(
      "${ApiConstants.showEducation}/$id",
      options: Options(
        headers: {
          "Authorization":
              "Bearer $token",
        },
      ),
    );

    return EducationModel.fromJson(
      response.data,
    );
  }
}