// lib/features/profiles/controller/cvenhancefile_controller.dart

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/profiles/mpdel/cvenhanceforfile_model.dart';
import 'package:hobe/features/profiles/services/cvenhanceforfile_services.dart';
import 'package:hobe/features/profiles/services/extractfile_services.dart';


import '../mpdel/cvfile_model.dart'; // موديل الملفات الموجود مسبقاً

class CvEnhanceFileController extends GetxController {
  final CvEnhanceService _service = CvEnhanceService();
  final CvUploadService _filesService = CvUploadService(); 
 

  final Rx<File?> pickedFile = Rx<File?>(null);
  final RxString pickedFileName = RxString("");
  final RxString selectedSource = RxString("file");
  final RxnInt selectedFileRecordId = RxnInt();

  final RxList<CvFileModel> savedFiles = <CvFileModel>[].obs;
  final RxBool isLoadingFiles = false.obs;
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController jobDescriptionController =
      TextEditingController();

  final RxBool saveEnabled = false.obs;
  final RxBool isLoading = false.obs;
  final Rx<CvEnhanceResultModel?> enhanceResult =
      Rx<CvEnhanceResultModel?>(null);

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

 
@override
  void onInit() {
    super.onInit();
    fetchSavedFiles();
  }
final RxBool isEnhancingPayload = false.obs;

Future<void> enhanceDirect(
  Map<String, dynamic> cvPayload, {
  String? jobTitle,
  String? company,
  String? jobDescription,
  bool save = false,
}) async {
  isEnhancingPayload.value = true;

  final result = await _service.enhanceFromPayload(
    cv: cvPayload,
    jobTitle: jobTitle,
    company: company,
    jobDescription: jobDescription,
    save: save,
  );

  isEnhancingPayload.value = false;

  if (result.success && result.result != null) {
    enhanceResult.value = result.result;
    Get.snackbar("تم", result.message);
  } else {
    Get.snackbar("خطأ", result.message);
  }
}
  Future<void> fetchSavedFiles() async {
    isLoadingFiles.value = true;

    final result = await _filesService.listFiles();

    isLoadingFiles.value = false;

    if (result.success) {
      savedFiles.value = result.files;
    }
  }

Future<void> enhance() async {
  isLoading.value = true;

  CvEnhanceResult result;

  if (selectedSource.value == "saved_file") {
    if (selectedFileRecordId.value == null) {
      Get.snackbar("تنبيه", "الرجاء اختيار ملف محفوظ أولاً");
      isLoading.value = false;
      return;
    }

    result = await _service.enhanceFromSavedFile(
      fileRecordId: selectedFileRecordId.value!,
      jobTitle: jobTitleController.text,
      company: companyController.text,
      jobDescription: jobDescriptionController.text,
      save: saveEnabled.value,
    );
  } else {
    if (pickedFile.value == null) {
      Get.snackbar("تنبيه", "الرجاء اختيار ملف الـ CV أولاً");
      isLoading.value = false;
      return;
    }

    result = await _service.enhanceFromFile(
      file: pickedFile.value!,
      jobTitle: jobTitleController.text,
      company: companyController.text,
      jobDescription: jobDescriptionController.text,
      save: saveEnabled.value,
    );
  }

  isLoading.value = false;

  if (result.success && result.result != null) {
    enhanceResult.value = result.result;
    Get.snackbar("تم", result.message);
  } else {
    Get.snackbar("خطأ", result.message);
  }
}

  void clearAll() {
    pickedFile.value = null;
    pickedFileName.value = "";
    enhanceResult.value = null;
    jobTitleController.clear();
    companyController.clear();
    jobDescriptionController.clear();
    saveEnabled.value = false;
  }
}