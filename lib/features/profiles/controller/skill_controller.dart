
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:hobe/features/profiles/mpdel/skill_model.dart';

import '../services/skill_service.dart';

class SkillController extends GetxController {

  final SkillService _service =
      SkillService();

  final nameController =
      TextEditingController();

  final levelController =
      TextEditingController();

  final yearsController =
      TextEditingController();

  final typeController =
      TextEditingController();

  var isLoading = false.obs;

  var skills =
      <SkillModel>[].obs;

  var selectedSkill =
      Rxn<SkillModel>();

  @override
  void onInit() {
    super.onInit();
    getSkills();
  }

  bool validateSkill() {

    if (nameController.text.trim().isEmpty) {

      Get.snackbar(
        "Error",
        "Skill Name Required",
      );

      return false;
    }

    if (levelController.text.trim().isEmpty) {

      Get.snackbar(
        "Error",
        "Level Required",
      );

      return false;
    }

    return true;
  }

  FormData buildFormData() {

    return FormData.fromMap({

      "name":
          nameController.text,

      "level":
          levelController.text,

      "years_experience":
          yearsController.text,

      "type":
          typeController.text,

    });
  }

  Future<void> getSkills() async {

    try {

      isLoading.value = true;

      skills.value =
          await _service.getSkills();

    } finally {

      isLoading.value = false;

    }
  }

  Future<void> createSkill() async {

    try {

      isLoading.value = true;

      final result =
          await _service.createSkill(
        data: buildFormData(),
      );

      skills.add(result);
if (skills.length == 1) {

  Future.delayed(
    const Duration(milliseconds: 500),
    () => Get.snackbar(
      "Great",
      "You can continue to Training",
    ),
  );

}
      clearFields();

      Get.snackbar(
        "Success",
        "Skill Added",
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

  Future<void> updateSkill(
    int id,
  ) async {

    try {

      isLoading.value = true;

      final result =
          await _service.updateSkill(
        id: id,
        data: buildFormData(),
      );

      final index =
          skills.indexWhere(
        (e) => e.id == id,
      );

      if (index != -1) {

     skills[index] = result;
skills.refresh();

      }

      clearFields();

      selectedSkill.value = null;

      Get.back();

      Get.snackbar(
        "Success",
        "Skill Updated",
      );

    } finally {

      isLoading.value = false;

    }
  }

  Future<void> deleteSkill(
    int id,
  ) async {

    await _service.deleteSkill(id);

    skills.removeWhere(
      (e) => e.id == id,
    );

    Get.snackbar(
      "Success",
      "Skill Deleted",
    );
  }

  void fillForEdit(
    SkillModel skill,
  ) {

    selectedSkill.value =
        skill;

    nameController.text =
        skill.name ?? "";

    levelController.text =
        skill.level ?? "";

    yearsController.text =
        skill.yearsExperience ?? "";

    typeController.text =
        skill.type ?? "";
  }

  void clearFields() {

    nameController.clear();
    levelController.clear();
    yearsController.clear();
    typeController.clear();

  }

  @override
  void onClose() {

    nameController.dispose();
    levelController.dispose();
    yearsController.dispose();
    typeController.dispose();

    super.onClose();
  }
}
