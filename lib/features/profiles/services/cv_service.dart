import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hobe/features/profiles/mpdel/cv_analysis_model.dart';

import '../../APIS/api_constants.dart';
import '../../APIS/dio_services.dart';

class AnalyzeService {
  final Dio _dio = DioService().dio;

  final box = GetStorage();

  Future<AnalyzeModel> analyzeCv() async {

    final token = box.read("token");
    
final response = await _dio.post(
  ApiConstants.analyzeCv,
  options: Options(
    headers: {
      "Authorization": "Bearer $token",
    },
  ),
);

print(response.data);

return AnalyzeModel.fromJson(response.data["result"]);}
}