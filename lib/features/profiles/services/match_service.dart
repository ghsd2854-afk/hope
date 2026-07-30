import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hobe/features/profiles/mpdel/match_model.dart';

import '../../APIS/api_constants.dart';
import '../../APIS/dio_services.dart';


class MatchService {
  final Dio _dio = DioService().dio;
  final box = GetStorage();

  Future<MatchModel> matchCv({
    required String jobDescription,
  }) async {
    final token = box.read("token");

    final response = await _dio.post(
      ApiConstants.matchCv,
      data: {
        "job_description": jobDescription,
        "source": "profile",
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return MatchModel.fromJson(response.data["result"]);
  }
}