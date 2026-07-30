import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../../APIS/api_constants.dart';
import '../../APIS/dio_services.dart';

class PdfService {
  final Dio _dio = DioService().dio;
  final box = GetStorage();

  Future<Uint8List> generatePdf() async {
    final token = box.read("token");

    final response = await _dio.post(
      ApiConstants.generatePdf,
      data: {
        "source": "profile",
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
        responseType: ResponseType.bytes,
      ),
    );

    return Uint8List.fromList(response.data);
  }
}