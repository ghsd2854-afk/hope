import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';
import 'package:hobe/features/profiles/mpdel/TrainingModel.dart';



class TrainingService {

  final Dio _dio = DioService().dio;

  final box = GetStorage();
Future<List<TrainingModel>>
    getTrainings() async {

  final token = box.read("token");

  final response = await _dio.get(

    ApiConstants.getTrainings,

    options: Options(
      headers: {
        "Authorization":
            "Bearer $token",
      },
    ),
  );

  return (response.data as List)

      .map(
        (e) => TrainingModel.fromJson(e),
      )

      .toList();
}
Future<TrainingModel>
    updateTraining({

  required int id,
  required FormData data,

}) async {

  final token = box.read("token");

  final response = await _dio.post(

    "${ApiConstants.updateTraining}/$id",

    data: data,

    options: Options(
      headers: {
        "Authorization":
            "Bearer $token",
      },
    ),
  );

  return TrainingModel.fromJson(
    response.data,
  );
}
Future<void> deleteTraining(
  int id,
) async {

  final token = box.read("token");

  await _dio.delete(

    "${ApiConstants.deleteTraining}/$id",

    options: Options(
      headers: {
        "Authorization":
            "Bearer $token",
      },
    ),
  );
}
  Future<TrainingModel> createTraining({
    required FormData data,
  }) async {

    final token = box.read("token");

    final response = await _dio.post(
      ApiConstants.createTraining,
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

    return TrainingModel.fromJson(
      response.data,
    );
  }
}