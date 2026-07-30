import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/profiles/mpdel/cvfile_detail_model.dart';
import 'package:hobe/features/profiles/mpdel/cvfile_model.dart';
import 'package:hobe/features/profiles/mpdel/extractforfile_model.dart';

class CvUploadService {
  final Dio _dio = Dio();
  final GetStorage box = GetStorage();

  Future<Map<String, String>> _headers() async {
    final token = box.read("token");

    print("TOKEN => $token");

    return {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  Future<CvUploadResult> uploadAndExtractCv(File file) async {
    try {
      final formData = FormData.fromMap({
        "cv_file": await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        ApiConstants.uploadAndExtractCv,
        data: formData,
        options: Options(
          headers: await _headers(),
        ),
      );

      final data = response.data;

      if (data['success'] == true) {
        return CvUploadResult(
          success: true,
          message: data['message'] ?? "",
          fileRecordId: data['file_record_id'],
          extractedCv: CvExtractModel.fromJson(data['extracted_cv']),
        );
      } else {
        return CvUploadResult(
          success: false,
          message: data['message'] ?? "فشل استخراج البيانات",
        );
      }
    } on DioException catch (e) {
      return CvUploadResult(
        success: false,
        message: e.response?.data['message'] ?? "حدث خطأ أثناء رفع الملف",
      );
    } catch (e) {
      return CvUploadResult(
        success: false,
        message: "حدث خطأ غير متوقع: $e",
      );
    }
  }
Future<ConfirmResult> confirmExtractedCv(CvExtractModel reviewedCv) async {
  try {
    final response = await _dio.post(
      ApiConstants.confirmUploadedCv,
      data: {
        "reviewed_cv": reviewedCv.toJson(),
      },
      options: Options(headers: await _headers()),
    );

    final data = response.data;

    return ConfirmResult(
      success: data['success'] == true,
      message: data['message'] ?? "",
    );
  } on DioException catch (e) {
    return ConfirmResult(
      success: false,
      message: e.response?.data['message'] ?? "فشل حفظ البيانات",
    );
  } catch (e) {
    return ConfirmResult(
      success: false,
      message: "حدث خطأ غير متوقع: $e",
    );
  }
}
Future<CvFilesResult> listFiles() async {
  try {
    final response = await _dio.get(
      ApiConstants.listCvFiles,
      options: Options(headers: await _headers()),
    );

    final data = response.data;

    if (data['success'] == true) {
      final files = (data['files'] as List<dynamic>)
          .map((e) => CvFileModel.fromJson(e))
          .toList();

      return CvFilesResult(success: true, files: files);
    } else {
      return CvFilesResult(
        success: false,
        message: data['message'] ?? "فشل جلب الملفات",
      );
    }
  } on DioException catch (e) {
    return CvFilesResult(
      success: false,
      message: e.response?.data['message'] ?? "حدث خطأ أثناء جلب الملفات",
    );
  } catch (e) {
    return CvFilesResult(success: false, message: "حدث خطأ غير متوقع: $e");
  }
}
Future<CvFileDetailResult> showFile(int id) async {
  try {
    final response = await _dio.get(
      "${ApiConstants.baseUrl}/cv/files/$id",
      options: Options(headers: await _headers()),
    );

    final data = response.data;

    if (data['success'] == true) {
      return CvFileDetailResult(
        success: true,
        file: CvFileDetailModel.fromJson(data['file']),
      );
    } else {
      return CvFileDetailResult(
        success: false,
        message: data['message'] ?? "فشل جلب تفاصيل الملف",
      );
    }
  } on DioException catch (e) {
    return CvFileDetailResult(
      success: false,
      message: e.response?.data['message'] ?? "حدث خطأ أثناء جلب التفاصيل",
    );
  } catch (e) {
    return CvFileDetailResult(success: false, message: "حدث خطأ غير متوقع: $e");
  }
}
Future<DownloadResult> downloadOriginalFile(int id, String fileName) async {
  try {
    final response = await _dio.get(
      ApiConstants.downloadCvFile(id),
      options: Options(
        headers: await _headers(),
        responseType: ResponseType.bytes,
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final safeFileName = fileName.isNotEmpty ? fileName : "cv_downloaded_$id.pdf";
    final filePath = "${dir.path}\\$safeFileName";

    final file = File(filePath);
    await file.writeAsBytes(response.data);

    return DownloadResult(success: true, filePath: filePath);
  } on DioException catch (e) {
    return DownloadResult(
      success: false,
      message: "فشل تحميل الملف: ${e.message}",
    );
  } catch (e) {
    return DownloadResult(success: false, message: "حدث خطأ غير متوقع: $e");
  }
}
}
class DownloadResult {
  final bool success;
  final String message;
  final String? filePath;

  DownloadResult({
    required this.success,
    this.message = "",
    this.filePath,
  });
}
class CvFileDetailResult {
  final bool success;
  final String message;
  final CvFileDetailModel? file;

  CvFileDetailResult({
    required this.success,
    this.message = "",
    this.file,
  });
}
class CvFilesResult {
  final bool success;
  final String message;
  final List<CvFileModel> files;

  CvFilesResult({
    required this.success,
    this.message = "",
    this.files = const [],
  });
}
class CvUploadResult {
  final bool success;
  final String message;
  final int? fileRecordId;
  final CvExtractModel? extractedCv;

  CvUploadResult({
    required this.success,
    required this.message,
    this.fileRecordId,
    this.extractedCv,
  });
}
class ConfirmResult {
  final bool success;
  final String message;

  ConfirmResult({
    required this.success,
    required this.message,
  });
}