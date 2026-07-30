// lib/features/profiles/controller/cvfile_detail_controller.dart

import 'package:get/get.dart';
import '../mpdel/cvfile_detail_model.dart';
import '../services/extractfile_services.dart';

class CvFileDetailController extends GetxController {
  final CvUploadService _service = CvUploadService();

  final RxBool isLoading = false.obs;
  final Rx<CvFileDetailModel?> file = Rx<CvFileDetailModel?>(null);
  final RxInt selectedTab = 0.obs; // 0 = extracted, 1 = improved

  Future<void> fetchDetails(int id) async {
    isLoading.value = true;

    final result = await _service.showFile(id);

    isLoading.value = false;

    if (result.success) {
      file.value = result.file;
    } else {
      Get.snackbar("خطأ", result.message);
    }
  }
  final RxBool isDownloading = false.obs;
final RxString downloadedPath = RxString("");

Future<void> downloadOriginalFile(int id, String fileName) async {
  isDownloading.value = true;

  final result = await _service.downloadOriginalFile(id, fileName);

  isDownloading.value = false;

  if (result.success) {
    downloadedPath.value = result.filePath ?? "";
    Get.snackbar("تم", "تم تحميل الملف بنجاح");
  } else {
    Get.snackbar("خطأ", result.message);
  }
}
}