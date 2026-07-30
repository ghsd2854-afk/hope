// lib/features/profiles/services/cvanalyze_services.dart

import 'dart:io';



import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hobe/features/APIS/api_constants.dart';

import '../mpdel/cvanalysis_model.dart';

class CvAnalyzeService {
  final Dio _dio = Dio();
 final GetStorage box = GetStorage();
  Future<Map<String, String>> _headers() async {
    final token = box.read("token"); // TODO: اجلبيه من مكان تخزين التوكن عندك
    return {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
  }
// lib/features/profiles/services/cvanalyze_services.dart

Future<CvAnalyzeResult> analyzeCv({
  required String source, // "file" أو "merge"
  required File file,
  String? jobTitle,
  String? jobDescription,
  String? company,
}) async {
  try {
    final formData = FormData.fromMap({
      "source": source,
      "cv_file": await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
      if (jobTitle != null && jobTitle.isNotEmpty) "job_title": jobTitle,
      if (jobDescription != null && jobDescription.isNotEmpty)
        "job_description": jobDescription,
      if (company != null && company.isNotEmpty) "company": company,
    });

    final response = await _dio.post(
      ApiConstants.analyzeCv,
      data: formData,
      options: Options(headers: await _headers()),
    );

    final data = response.data;

    if (data['success'] == true) {
      return CvAnalyzeResult(
        success: true,
        message: data['message'] ?? "",
        result: CvAnalysisResultModel.fromJson(data['result']),
      );
    } else {
      return CvAnalyzeResult(
        success: false,
        message: data['message'] ?? "فشل تحليل البيانات",
      );
    }
  } on DioException catch (e) {
    return CvAnalyzeResult(
      success: false,
      message: e.response?.data['message'] ?? "حدث خطأ أثناء التحليل",
    );
  } catch (e) {
    return CvAnalyzeResult(success: false, message: "حدث خطأ غير متوقع: $e");
  }
}
  Future<CvAnalyzeResult> analyzeFromFile({
    required File file,
    String? jobTitle,
    String? jobDescription,
    String? company,
  }) async {
    try {
      final formData = FormData.fromMap({
        "source": "file",
        "cv_file": await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
        if (jobTitle != null && jobTitle.isNotEmpty) "job_title": jobTitle,
        if (jobDescription != null && jobDescription.isNotEmpty)
          "job_description": jobDescription,
        if (company != null && company.isNotEmpty) "company": company,
      });

      final response = await _dio.post(
        ApiConstants.analyzeCv,
        data: formData,
        options: Options(headers: await _headers()),
      );

      final data = response.data;

      if (data['success'] == true) {
        return CvAnalyzeResult(
          success: true,
          message: data['message'] ?? "",
          result: CvAnalysisResultModel.fromJson(data['result']),
        );
      } else {
        return CvAnalyzeResult(
          success: false,
          message: data['message'] ?? "فشل تحليل الملف",
        );
      }
    } on DioException catch (e) {
      return CvAnalyzeResult(
        success: false,
        message: e.response?.data['message'] ?? "حدث خطأ أثناء التحليل",
      );
    } catch (e) {
      return CvAnalyzeResult(success: false, message: "حدث خطأ غير متوقع: $e");
    }
  }
}

class CvAnalyzeResult {
  final bool success;
  final String message;
  final CvAnalysisResultModel? result;

  CvAnalyzeResult({
    required this.success,
    this.message = "",
    this.result,
  });
}