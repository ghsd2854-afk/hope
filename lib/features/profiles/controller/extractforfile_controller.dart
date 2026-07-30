// lib/controller/CvUploadController.dart

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:hobe/features/profiles/mpdel/extractforfile_model.dart';
import 'package:hobe/features/profiles/services/extractfile_services.dart';


class CvUploadController extends GetxController {
  final CvUploadService _service = CvUploadService();

  final Rx<File?> pickedFile = Rx<File?>(null);
  final RxString pickedFileName = RxString("");
  final RxBool isLoading = false.obs;
  final RxBool hasExtracted = false.obs;

  final Rx<CvExtractModel?> extractedCv = Rx<CvExtractModel?>(null);
  final RxnInt fileRecordId = RxnInt();

  Future<void> pickCvFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      pickedFile.value = File(result.files.single.path!);
      pickedFileName.value = result.files.single.name;
    }
  }

  Future<void> uploadAndExtract() async {
    if (pickedFile.value == null) {
      Get.snackbar("تنبيه", "الرجاء اختيار ملف الـ CV أولاً");
      return;
    }

    isLoading.value = true;

    final result = await _service.uploadAndExtractCv(pickedFile.value!);

    isLoading.value = false;

    if (result.success && result.extractedCv != null) {
      extractedCv.value = result.extractedCv;
      fileRecordId.value = result.fileRecordId;
      hasExtracted.value = true;

      Get.snackbar("تم", result.message);
    } else {
      Get.snackbar("خطأ", result.message);
    }
  }
final RxBool isSaving = false.obs;

Future<void> confirmAndSave() async {
  if (extractedCv.value == null) {
    Get.snackbar("تنبيه", "لا يوجد بيانات لحفظها");
    return;
  }

  isSaving.value = true;

  final result = await _service.confirmExtractedCv(extractedCv.value!);

  isSaving.value = false;

  if (result.success) {
    Get.snackbar("تم", result.message);
    // ✅ بعد الحفظ الناجح ارجعي المستخدم لصفحة البروفايل أو أي صفحة تحبيها
    Get.back();
  } else {
    Get.snackbar("خطأ", result.message);
  }
}
  void clearAll() {
    pickedFile.value = null;
    pickedFileName.value = "";
    extractedCv.value = null;
    fileRecordId.value = null;
    hasExtracted.value = false;
  }
}