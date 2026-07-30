import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';

import '../mpdel/CertificationModel.dart';

class CertificationService {

  final Dio _dio = DioService().dio;

  final box = GetStorage();

  Future<List<CertificationModel>>
      getCertifications() async {

    final token = box.read("token");

    final response = await _dio.get(

      ApiConstants.getCertifications,

      options: Options(
        headers: {
          "Authorization":
              "Bearer $token",
        },
      ),
    );

    return (response.data as List)

        .map(
          (e) =>
              CertificationModel.fromJson(e),
        )

        .toList();
  }

  Future<CertificationModel>
      createCertification({

    required FormData data,

  }) async {

    final token = box.read("token");

    final response = await _dio.post(

      ApiConstants.createCertification,

      data: data,

      options: Options(
        headers: {
          "Authorization":
              "Bearer $token",
        },
      ),
    );

    return CertificationModel.fromJson(
      response.data,
    );
  }

  Future<CertificationModel>
      updateCertification({

    required int id,
    required FormData data,

  }) async {

    final token = box.read("token");

    final response = await _dio.post(

      "${ApiConstants.updateCertification}/$id",

      data: data,

      options: Options(
        headers: {
          "Authorization":
              "Bearer $token",
        },
      ),
    );

    return CertificationModel.fromJson(
      response.data,
    );
  }

  Future<CertificationModel>
      getCertificationDetails(
    int id,
  ) async {

    final token = box.read("token");

    final response = await _dio.get(

      "${ApiConstants.showCertification}/$id",

      options: Options(
        headers: {
          "Authorization":
              "Bearer $token",
        },
      ),
    );

    return CertificationModel.fromJson(
      response.data,
    );
  }

  Future<void> deleteCertification(
    int id,
  ) async {

    final token = box.read("token");

    await _dio.delete(

      "${ApiConstants.deleteCertification}/$id",

      options: Options(
        headers: {
          "Authorization":
              "Bearer $token",
        },
      ),
    );
  }
}