// lib/features/profiles/controller/cvfiles_controller.dart

import 'package:get/get.dart';
import '../mpdel/cvfile_model.dart';
import '../services/extractfile_services.dart'; // نفس السيرفس الموجود

class CvFilesController extends GetxController {
  final CvUploadService _service = CvUploadService();

  final RxBool isLoading = false.obs;
  final RxList<CvFileModel> files = <CvFileModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFiles();
  }

  Future<void> fetchFiles() async {
    isLoading.value = true;

    final result = await _service.listFiles();

    isLoading.value = false;

    if (result.success) {
      files.value = result.files;
    } else {
      Get.snackbar("خطأ", result.message);
    }
  }
}