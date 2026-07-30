import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hobe/features/profiles/services/PdfService.dart';

class PdfController extends GetxController {
  final PdfService _service = PdfService();

  var isLoading = false.obs;

  Uint8List? pdfBytes;

  final RxString savedFilePath = RxString("");

  Future<void> generatePdf() async {
    try {
      isLoading.value = true;

      pdfBytes = await _service.generatePdf();

      update();

      if (pdfBytes != null) {
        await _saveToDevice(pdfBytes!);
      }

      Get.snackbar(
        "Success",
        "PDF Generated Successfully",
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveToDevice(Uint8List bytes) async {
  try {
    final dir = await getApplicationDocumentsDirectory();

    final fileName = "cv_${DateTime.now().millisecondsSinceEpoch}.pdf";
    final filePath = "${dir.path}\\$fileName";

    final file = File(filePath);
    await file.writeAsBytes(bytes);

    savedFilePath.value = filePath;

    print("📁 PDF SAVED AT: $filePath"); // ⬅️ ضيفي هاد السطر

  } catch (e) {
    Get.snackbar("خطأ بالحفظ", "فشل حفظ الملف على الجهاز: $e");
  }
}
  
}