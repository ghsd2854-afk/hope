import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:hobe/features/profiles/mpdel/EducationModel.dart';
import 'package:hobe/features/profiles/services/EducationService.dart';



class EducationController extends GetxController {

  final EducationService _service =
      EducationService();

  final institutionController =
      TextEditingController();

  final degreeController =
      TextEditingController();

  final fieldController =
      TextEditingController();

  final startDateController =
      TextEditingController();

  final endDateController =
      TextEditingController();

  final gradeController =
      TextEditingController();

  var isLoading = false.obs;

  var education =
      Rxn<EducationModel>();
      @override
void onInit() {
  super.onInit();
  getEducations();
}

Future<void> getEducations() async {
  try {
    isLoading.value = true;

    educations.value =
        await _service.getEducations();

  } finally {
    isLoading.value = false;
  }
}
Future<void> createEducation() async {

  try {

    isLoading.value = true;

    final result =
        await _service.createEducation(
      data: buildFormData(),
    );

    educations.add(result);

    clearFields();

    Get.back();

    Get.snackbar(
      "Success",
      "Education Added",
    );

  } finally {

    isLoading.value = false;

  }
}
  bool validateEducation() {

    if (institutionController.text.isEmpty) {

      Get.snackbar(
        "Error",
        "Institution Required",
      );

      return false;
    }

    return true;
  }
  var educations = <EducationModel>[].obs;

void clearFields() {
  institutionController.clear();
  degreeController.clear();
  fieldController.clear();
  startDateController.clear();
  endDateController.clear();
  gradeController.clear();
}

void fillForEdit(EducationModel education) {
  institutionController.text =
      education.institution ?? "";

  degreeController.text =
      education.degree ?? "";

  fieldController.text =
      education.fieldOfStudy ?? "";

  startDateController.text =
      education.startDate ?? "";

  endDateController.text =
      education.endDate ?? "";

  gradeController.text =
      education.grade?.toString() ?? "";
}

  FormData buildFormData() {

    return FormData.fromMap({

      "institution":
          institutionController.text,

      "degree":
          degreeController.text,

      "field_of_study":
          fieldController.text,

      "start_date":
          startDateController.text,

      "end_date":
          endDateController.text,

      "grade":
          gradeController.text,

    });
  }


Future<void> updateEducation(
  int id,
) async {

  try {

    isLoading.value = true;

    final result =
        await _service.updateEducation(
      id: id,
      data: buildFormData(),
    );

    final index =
        educations.indexWhere(
      (e) => e.id == id,
    );

    if (index != -1) {
      educations[index] = result;
    }

    clearFields();

    Get.back();

    Get.snackbar(
      "Success",
      "Education Updated",
    );

  } finally {

    isLoading.value = false;

  }
}

Future<void> deleteEducation(
  int id,
) async {

  await _service.deleteEducation(id);

  educations.removeWhere(
    (e) => e.id == id,
  );

  Get.snackbar(
    "Success",
    "Deleted Successfully",
  );
}

  

  @override
  void onClose() {

    institutionController.dispose();
    degreeController.dispose();
    fieldController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    gradeController.dispose();

    super.onClose();
  }
}