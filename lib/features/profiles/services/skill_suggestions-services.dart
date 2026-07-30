import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hobe/features/profiles/mpdel/skill_suggestions-model.dart';

import '../../APIS/api_constants.dart';
import '../../APIS/dio_services.dart';


class SkillSuggestionService {

  final Dio _dio = DioService().dio;

  final box = GetStorage();

  Future<void> generateSuggestions({
    required String jobTitle,
    required String description,
  }) async {

    final token = box.read("token");

    await _dio.post(
      ApiConstants.generateSuggestions,
      data: FormData.fromMap({
        "job_title": jobTitle,
        "job_description": description,
      }),
      options: Options(
        headers: {
          "Authorization":"Bearer $token",
        },
      ),
    );
  }

  Future<List<SkillSuggestionModel>>
      getSuggestions() async {

    final token = box.read("token");

    final response = await _dio.get(
      ApiConstants.getSuggestions,
      options: Options(
        headers: {
          "Authorization":"Bearer $token",
        },
      ),
    );

    return (response.data as List)
        .map((e)=>SkillSuggestionModel.fromJson(e))
        .toList();
  }

  Future<void> acceptSkill(
      int id) async {

    final token = box.read("token");

    await _dio.post(
      "${ApiConstants.acceptSuggestion}/$id/accept",
      options: Options(
        headers: {
          "Authorization":"Bearer $token",
        },
      ),
    );
  }

  Future<void> rejectSkill(
      int id) async {

    final token = box.read("token");

    await _dio.post(
      "${ApiConstants.rejectSuggestion}/$id/reject",
      options: Options(
        headers: {
          "Authorization":"Bearer $token",
        },
      ),
    );
  }
}