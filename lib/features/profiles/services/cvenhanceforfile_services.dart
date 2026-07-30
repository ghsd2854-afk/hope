// lib/features/profiles/services/cvenhance_services.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/profiles/mpdel/cvenhanceforfile_model.dart';


class CvEnhanceService {
  final Dio _dio = Dio();
 final GetStorage box = GetStorage();
  Future<Map<String, String>> _headers() async {
       final token = box.read("token");
 // TODO: اجلبيه من مكان تخزين التوكن
     print("TOKEN => $token");
    return {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
  }
  // lib/features/profiles/services/cvenhance_services.dart

Future<CvEnhanceResult> enhanceFromPayload({
  required Map<String, dynamic> cv,
  String? jobTitle,
  String? company,
  String? jobDescription,
  bool save = false,
}) async {
  try {
    final body = {
      "source": "payload",
      "save": save,
      "cv": cv,
      if (jobTitle != null && jobTitle.isNotEmpty) "job_title": jobTitle,
      if (company != null && company.isNotEmpty) "company": company,
      if (jobDescription != null && jobDescription.isNotEmpty)
        "job_description": jobDescription,
    };

    final response = await _dio.post(
      ApiConstants.enhanceCv,
      data: body,
      options: Options(
        headers: {
          ...await _headers(),
          "Content-Type": "application/json",
        },
      ),
    );

    final data = response.data;

    if (data['success'] == true) {
      return CvEnhanceResult(
        success: true,
        message: data['message'] ?? "",
        result: CvEnhanceResultModel.fromJson(data),
      );
    } else {
      return CvEnhanceResult(
        success: false,
        message: data['message'] ?? "فشل تحسين البيانات",
      );
    }
  } on DioException catch (e) {
    return CvEnhanceResult(
      success: false,
      message: e.response?.data['message'] ?? "حدث خطأ أثناء التحسين",
    );
  } catch (e) {
    return CvEnhanceResult(success: false, message: "حدث خطأ غير متوقع: $e");
  }
}
// lib/features/profiles/services/cvenhance_services.dart

Future<CvEnhanceResult> enhanceFromSavedFile({
  required int fileRecordId,
  String? jobTitle,
  String? company,
  String? jobDescription,
  bool save = false,
}) async {
  try {
    final formData = FormData.fromMap({
      "source": "saved_file",
      "file_record_id": fileRecordId.toString(),
      "save": save ? "1" : "0",
      if (jobTitle != null && jobTitle.isNotEmpty) "job_title": jobTitle,
      if (company != null && company.isNotEmpty) "company": company,
      if (jobDescription != null && jobDescription.isNotEmpty)
        "job_description": jobDescription,
    });

    final response = await _dio.post(
      ApiConstants.enhanceCv,
      data: formData,
      options: Options(headers: await _headers()),
    );

    final data = response.data;

    if (data['success'] == true) {
      return CvEnhanceResult(
        success: true,
        message: data['message'] ?? "",
        result: CvEnhanceResultModel.fromJson(data),
      );
    } else {
      return CvEnhanceResult(
        success: false,
        message: data['message'] ?? "فشل تحسين الملف",
      );
    }
  } on DioException catch (e) {
    return CvEnhanceResult(
      success: false,
      message: e.response?.data['message'] ?? "حدث خطأ أثناء التحسين",
    );
  } catch (e) {
    return CvEnhanceResult(success: false, message: "حدث خطأ غير متوقع: $e");
  }
}
  Future<CvEnhanceResult> enhanceFromFile({
    required File file,
    String? jobTitle,
    String? company,
    String? jobDescription,
    bool save = false,
  }) async {
    try {
      final formData = FormData.fromMap({
        "source": "file",
        "cv_file": await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
        "save": save ? "1" : "0",
        if (jobTitle != null && jobTitle.isNotEmpty) "job_title": jobTitle,
        if (company != null && company.isNotEmpty) "company": company,
        if (jobDescription != null && jobDescription.isNotEmpty)
          "job_description": jobDescription,
      });

      final response = await _dio.post(
        ApiConstants.enhanceCv,
        data: formData,
        options: Options(headers: await _headers()),
      );

      final data = response.data;

      if (data['success'] == true) {
        return CvEnhanceResult(
          success: true,
          message: data['message'] ?? "",
          result: CvEnhanceResultModel.fromJson(data),
        );
      } else {
        return CvEnhanceResult(
          success: false,
          message: data['message'] ?? "فشل تحسين الملف",
        );
      }
    } on DioException catch (e) {
      return CvEnhanceResult(
        success: false,
        message: e.response?.data['message'] ?? "حدث خطأ أثناء التحسين",
      );
    } catch (e) {
      return CvEnhanceResult(success: false, message: "حدث خطأ غير متوقع: $e");
    }
  }
}

class CvEnhanceResult {
  final bool success;
  final String message;
  final CvEnhanceResultModel? result;

  CvEnhanceResult({
    required this.success,
    this.message = "",
    this.result,
  });
}