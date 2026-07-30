import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hobe/features/profiles/mpdel/InterestModel.dart';

import '../services/InterestService.dart';

class InterestController
    extends GetxController {

  final InterestService _service =
      InterestService();

  final nameController =
      TextEditingController();

  final categoryController =
      TextEditingController();

  final levelController =
      TextEditingController();

  final descriptionController =
      TextEditingController();

  var isLoading = false.obs;
var interests = <InterestModel>[].obs;
@override
void onInit() {
  super.onInit();
  getInterests();
}
Future<void> getInterests() async {

  try {

    isLoading.value = true;

    interests.value =
        await _service.getInterests();

  } finally {

    isLoading.value = false;

  }
}
  bool validateInterest() {

    if (nameController.text.isEmpty) {

      Get.snackbar(
        "Error",
        "Name Required",
      );

      return false;
    }

    return true;
  }

  FormData buildFormData() {

    return FormData.fromMap({

      "name":
          nameController.text,

      "category":
          categoryController.text,

      "level":
          levelController.text,

      "description":
          descriptionController.text,
    });
  }

Future<void> createInterest() async {

  try {

    isLoading.value = true;

    final result =
        await _service.createInterest(
      data: buildFormData(),
    );

    interests.add(result);

    clearFields();

    Get.back();

    Get.snackbar(
      "Success",
      "Interest Added",
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

  } finally {

    isLoading.value = false;

  }
}
Future<void> updateInterest(
  int id,
) async {

  try {

    isLoading.value = true;

    final result =
        await _service.updateInterest(
      id: id,
      data: buildFormData(),
    );

    final index =
        interests.indexWhere(
      (e) => e.id == id,
    );

    if (index != -1) {

      interests[index] = result;

    }

    clearFields();

    Get.back();

    Get.snackbar(
      "Success",
      "Updated",
    );

  } finally {

    isLoading.value = false;

  }
}
Future<void> deleteInterest(
  int id,
) async {

  await _service.deleteInterest(id);

  interests.removeWhere(
    (e) => e.id == id,
  );

  Get.snackbar(
    "Success",
    "Deleted",
  );
}
void fillForEdit(
  InterestModel interest,
) {

  nameController.text =
      interest.name ?? "";

  categoryController.text =
      interest.category ?? "";

  levelController.text =
      interest.level ?? "";

  descriptionController.text =
      interest.description ?? "";
}
  void clearFields() {

    nameController.clear();

    categoryController.clear();

    levelController.clear();

    descriptionController.clear();
  }

  @override
  void onClose() {

    nameController.dispose();

    categoryController.dispose();

    levelController.dispose();

    descriptionController.dispose();

    super.onClose();
  }
}