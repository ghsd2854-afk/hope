


import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';
import 'package:hobe/features/profiles/mpdel/skill_model.dart';


class SkillService {

  final Dio _dio = DioService().dio;
  final box = GetStorage();

  Future<List<SkillModel>> getSkills() async {

    final token = box.read("token");

    final response = await _dio.get(
      ApiConstants.getSkills,
      options: Options(
        headers: {
          "Authorization":
              "Bearer $token",
        },
      ),
    );

    return (response.data as List)
        .map(
          (e) => SkillModel.fromJson(e),
        )
        .toList();
  }

  Future<SkillModel> createSkill({
    required FormData data,
  }) async {

    final token = box.read("token");

    final response = await _dio.post(
      ApiConstants.createSkill,
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

    return SkillModel.fromJson(
      response.data,
    );
  }

  Future<SkillModel> updateSkill({
    required int id,
    required FormData data,
  }) async {

    final token = box.read("token");

    final response = await _dio.post(
      "${ApiConstants.updateSkill}/$id",
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

    return SkillModel.fromJson(
      response.data,
    );
  }

  Future<void> deleteSkill(
    int id,
  ) async {

    final token = box.read("token");

    await _dio.delete(
      "${ApiConstants.deleteSkill}/$id",
      options: Options(
        headers: {
          "Authorization":
              "Bearer $token",
        },
      ),
    );
  }
}

