import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';
import 'package:hobe/features/home/models/export_status_model.dart';


class DataExportService {
  final _dio = DioService().dio;

  /// إنشاء طلب تصدير جديد، يرجع id الطلب
  Future<int> createExportRequest() async {
    final response = await _dio.post(ApiConstants.createExport);
    // ⚠️ ضيف بـ ApiConstants: static const String createExport = "/account/export";

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data['id'];
    }
    throw Exception('فشل إنشاء طلب التصدير');
  }

  /// جلب حالة آخر طلب تصدير
  Future<ExportStatusModel> getExportStatus() async {
    final response = await _dio.get(ApiConstants.exportStatus);
    // ⚠️ ضيف: static const String exportStatus = "/account/export/status";

    if (response.statusCode == 200) {
      return ExportStatusModel.fromJson(response.data);
    }
    throw Exception('فشل جلب حالة التصدير');
  }

  /// تحميل محتوى البيانات المصدّرة كـ JSON كامل
  Future<Map<String, dynamic>> downloadExport(int exportId) async {
    final response = await _dio.get(
      ApiConstants.downloadExport(exportId),
      // ⚠️ ضيف: static String downloadExport(int id) => "/account/export/$id/download";
    );

    if (response.statusCode == 200) {
      return response.data;
    }
    throw Exception('فشل تحميل ملف البيانات');
  }
}
