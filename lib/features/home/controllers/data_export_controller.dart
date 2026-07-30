import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:hobe/features/home/services/data_export_service.dart';
import 'package:path_provider/path_provider.dart';
// ⚠️ أضف path_provider بالـ pubspec.yaml إذا مو موجود:
// path_provider: ^2.1.0



class DataExportController extends GetxController {
  final DataExportService _service = DataExportService();

  final RxBool isProcessing = false.obs;
  final RxString statusMessage = ''.obs;
  final RxString savedFilePath = ''.obs;

  Future<void> exportMyData() async {
    try {
      isProcessing.value = true;
      savedFilePath.value = '';
      statusMessage.value = 'جاري إنشاء طلب التصدير...';

      final exportId = await _service.createExportRequest();

      // نتابع الحالة كل ثانيتين لغاية ما تصير "ready" (أو تنتهي المحاولات)
      bool ready = false;
      int attempts = 0;
      const maxAttempts = 15; // 15 * 2s = 30 ثانية كحد أقصى

      while (!ready && attempts < maxAttempts) {
        await Future.delayed(const Duration(seconds: 2));
        final status = await _service.getExportStatus();
        ready = status.isReady;
        attempts++;
        if (!ready) {
          statusMessage.value = 'جاري تجهيز البيانات... ($attempts)';
        }
      }

      if (!ready) {
        throw Exception('استغرق التصدير وقتاً أطول من المتوقع، حاول لاحقاً');
      }

      statusMessage.value = 'جاري تحميل البيانات...';
      final data = await _service.downloadExport(exportId);

      final path = await _saveToFile(data);
      savedFilePath.value = path;
      statusMessage.value = 'تم تصدير بياناتك بنجاح';

      Get.snackbar('تم', 'تم حفظ بياناتك بالملف بنجاح');
    } catch (e) {
      statusMessage.value = '';
      Get.snackbar('خطأ', e.toString());
    } finally {
      isProcessing.value = false;
    }
  }

  Future<String> _saveToFile(Map<String, dynamic> data) async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName =
        'my_data_export_${DateTime.now().millisecondsSinceEpoch}.json';
    final file = File('${dir.path}/$fileName');

    await file.writeAsString(jsonEncode(data));
    return file.path;
  }
}
