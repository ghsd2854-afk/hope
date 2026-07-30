// lib/features/profiles/controller/cvanalyzefile_controller.dart

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../mpdel/cvanalysis_model.dart';
import '../services/cvanalyze_services.dart';

class CvAnalyzeFileController extends GetxController {
  final CvAnalyzeService _service = CvAnalyzeService();

  final Rx<File?> pickedFile = Rx<File?>(null);
  final RxString pickedFileName = RxString("");

  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController jobDescriptionController =
      TextEditingController();

  final RxBool isLoading = false.obs;
  final Rx<CvAnalysisResultModel?> analysisResult =
      Rx<CvAnalysisResultModel?>(null);

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


  void clearAll() {
    pickedFile.value = null;
    pickedFileName.value = "";
    analysisResult.value = null;
    jobTitleController.clear();
    companyController.clear();
    jobDescriptionController.clear();
  }
  // lib/features/profiles/controller/cvanalyzefile_controller.dart

final RxString selectedSource = RxString("file"); // "file" أو "merge"

Future<void> analyze() async {
  if (pickedFile.value == null) {
    Get.snackbar("تنبيه", "الرجاء اختيار ملف الـ CV أولاً");
    return;
  }

  isLoading.value = true;

  final result = await _service.analyzeCv(
    source: selectedSource.value,
    file: pickedFile.value!,
    jobTitle: jobTitleController.text,
    jobDescription: jobDescriptionController.text,
    company: companyController.text,
  );

  isLoading.value = false;

  if (result.success && result.result != null) {
    analysisResult.value = result.result;
  } else {
    Get.snackbar("خطأ", result.message);
  }
}
}