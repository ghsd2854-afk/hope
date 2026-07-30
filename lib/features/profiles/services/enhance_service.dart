import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hobe/features/profiles/mpdel/enhance_model.dart';

import '../../APIS/api_constants.dart';
import '../../APIS/dio_services.dart';


class EnhanceService {
  final Dio _dio = DioService().dio;

  final box = GetStorage();

Future<EnhanceModel> enhanceCv() async {
  final token = box.read("token");

  try {
    final response = await _dio.post(
      ApiConstants.enhanceCv,
   data: {
  "save": false,
},
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    print(response.data);

    return EnhanceModel.fromJson(response.data);
  } on DioException catch (e) {
    print(e.response?.data); // مهم جداً
    rethrow;
  }
}

Future<void> saveEnhancedCv({
  required int fileRecordId,
  required Map<String, dynamic> enhancedCv,
}) async {
  final token = box.read("token");

  await _dio.post(
    ApiConstants.saveEnhancedCv,
    data: {
      "file_record_id": fileRecordId,
      "enhanced_cv": enhancedCv,
    },
    options: Options(
      headers: {
        "Authorization": "Bearer $token",
      },
    ),
  );
}
}