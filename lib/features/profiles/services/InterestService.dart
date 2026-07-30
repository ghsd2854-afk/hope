import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../../APIS/api_constants.dart';
import '../../APIS/dio_services.dart';
import '../mpdel/InterestModel.dart';

class InterestService {

  final Dio _dio = DioService().dio;

  final box = GetStorage();

  Future<InterestModel>
      createInterest({
    required FormData data,
  }) async {

    final token = box.read("token");

    final response = await _dio.post(
      ApiConstants.createInterest,
      data: data,
      options: Options(
        headers: {
          "Authorization":
              "Bearer $token",
        },
      ),
    );

    return InterestModel.fromJson(
      response.data,
    );
  }
  Future<void> deleteInterest(int id) async {

  final token = box.read("token");

  await _dio.delete(
    "${ApiConstants.deleteInterest}/$id",
    options: Options(
      headers: {
        "Authorization": "Bearer $token",
      },
    ),
  );
}
Future<InterestModel> updateInterest({
  required int id,
  required FormData data,
}) async {

  final token = box.read("token");

  final response = await _dio.post(
    "${ApiConstants.updateInterest}/$id",
    data: data,
    options: Options(
      headers: {
        "Authorization": "Bearer $token",
      },
    ),
  );

  return InterestModel.fromJson(response.data);
}
Future<List<InterestModel>> getInterests() async {

  final token = box.read("token");

  final response = await _dio.get(
    ApiConstants.getInterests,
    options: Options(
      headers: {
        "Authorization": "Bearer $token",
      },
    ),
  );

  return (response.data as List)
      .map((e) => InterestModel.fromJson(e))
      .toList();
}
}