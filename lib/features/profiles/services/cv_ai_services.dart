import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../../APIS/api_constants.dart';
import '../../APIS/dio_services.dart';

class CvService {
  final Dio _dio = DioService().dio;

  final box = GetStorage();

Future<Map<String, dynamic>> generateCv() async {

  final token = box.read("token");

 final response = await _dio.get(
  ApiConstants.generateCv,
  options: Options(
    headers: {
      "Authorization": "Bearer $token",
    },
  ),
);

return response.data["cv"];
}
}