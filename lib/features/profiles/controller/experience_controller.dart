import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:hobe/features/profiles/mpdel/experience_model.dart';
import 'package:hobe/features/profiles/services/experience_services.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ExperienceController extends GetxController {

  final ExperienceService _service =
      ExperienceService();

  final companyController =
      TextEditingController();

  final positionController =
      TextEditingController();

  final startDateController =
      TextEditingController();

  final endDateController =
      TextEditingController();

  final currentController =
      TextEditingController();

  final descriptionController =
      TextEditingController();

  final technologiesController =
      TextEditingController();

  var isLoading = false.obs;

  var experiences =
      <ExperienceModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getExperiences();
  }

  bool validateExperience() {

    if (companyController.text.isEmpty) {

      Get.snackbar(
        "Error",
        "Company Required",
      );

      return false;
    }

    return true;
  }

  FormData buildFormData() {

    final techs =
        technologiesController.text
            .split(",");

    return FormData.fromMap({

      "company":
          companyController.text,

      "position":
          positionController.text,

      "start_date":
          startDateController.text,

      "end_date":
          endDateController.text,

   "is_current": currentController.text.toLowerCase(),

      "description":
          descriptionController.text,

      for (int i = 0;
          i < techs.length;
          i++)
        "technologies_used[$i]":
            techs[i].trim(),
    });
  }

  Future<void> getExperiences() async {

    try {

      isLoading.value = true;

      experiences.value =
          await _service.getExperiences();

    } finally {

      isLoading.value = false;

    }
  }

  Future<void> createExperience() async {

    try {

      isLoading.value = true;

      final result =
          await _service.createExperience(
        data: buildFormData(),
      );

      experiences.add(result);

      clearFields();

      Get.back();

      Get.snackbar(
        "Success",
        "Experience Added",
      );

    } catch (e) {

  if (e is DioException) {

    print(e.response?.data);

    Get.snackbar(
      "Error",
      e.response?.data.toString() ?? "",
    );

  } else {

    Get.snackbar(
      "Error",
      e.toString(),
    );
  }
}finally {

      isLoading.value = false;

    }
  }

  Future<void> updateExperience(
    int id,
  ) async {

    try {

      isLoading.value = true;
print(buildFormData().fields);
      final result =
          await _service.updateExperience(
        id: id,
        data: buildFormData(),
      );

      final index =
          experiences.indexWhere(
        (e) => e.id == id,
      );

      if (index != -1) {
        experiences[index] = result;
      }

      clearFields();

      Get.back();

      Get.snackbar(
        "Success",
        "Updated",
      );

   } catch (e) {

  if (e is DioException) {

    print("STATUS => ${e.response?.statusCode}");
    print("DATA => ${e.response?.data}");

  } else {

    print(e);

  }

} finally {

  isLoading.value = false;

}
  }

  Future<void> deleteExperience(
    int id,
  ) async {

    await _service.deleteExperience(id);

    experiences.removeWhere(
      (e) => e.id == id,
    );

    Get.snackbar(
      "Success",
      "Deleted",
    );
  }

  void fillForEdit(
    ExperienceModel experience,
  ) {

    companyController.text =
        experience.company ?? "";

    positionController.text =
        experience.position ?? "";

    startDateController.text =
        experience.startDate ?? "";

    endDateController.text =
        experience.endDate ?? "";

    currentController.text =
        experience.isCurrent.toString();

    descriptionController.text =
        experience.description ?? "";

    technologiesController.text =
        experience.technologiesUsed
                ?.join(",") ??
            "";
  }

  void clearFields() {

    companyController.clear();
    positionController.clear();
    startDateController.clear();
    endDateController.clear();
    currentController.clear();
    descriptionController.clear();
    technologiesController.clear();
  }
  @override
void onClose() {

  companyController.dispose();
  positionController.dispose();
  startDateController.dispose();
  endDateController.dispose();
  currentController.dispose();
  descriptionController.dispose();
  technologiesController.dispose();

  super.onClose();
}
}