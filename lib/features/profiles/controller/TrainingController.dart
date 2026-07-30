import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hobe/features/profiles/mpdel/TrainingModel.dart';
import 'package:hobe/features/profiles/services/TrainingService.dart';


class TrainingController
    extends GetxController {

  final TrainingService _service =
      TrainingService();

  final titleController =
      TextEditingController();

  final providerController =
      TextEditingController();

  final startDateController =
      TextEditingController();

  final endDateController =
      TextEditingController();

  final completedController =
      TextEditingController();

  var isLoading = false.obs;
  var trainings =
    <TrainingModel>[].obs;

  bool validateTraining() {

    if (titleController.text.isEmpty) {

      Get.snackbar(
        "Error",
        "Title Required",
      );

      return false;
    }

    return true;
  }

  FormData buildFormData() {

    return FormData.fromMap({

      "title":
          titleController.text,

      "provider":
          providerController.text,

      "start_date":
          startDateController.text,

      "end_date":
          endDateController.text,

      "is_completed":
          completedController.text,

    });
  }
@override
void onInit() {
  super.onInit();
  getTrainings();
}
Future<void> getTrainings() async {

  try {

    isLoading.value = true;

    trainings.value =
        await _service.getTrainings();

  } finally {

    isLoading.value = false;
  }
}
  Future<void> createTraining() async {

    try {

      isLoading.value = true;

    final result =
    await _service.createTraining(
  data: buildFormData(),
);

trainings.add(result);

clearFields();

Get.back();

Get.snackbar(
  "Success",
  "Training Added",
);

      Get.toNamed("/education");

    } catch (e) {

  if (e is DioException) {

    print("STATUS => ${e.response?.statusCode}");

    print("DATA => ${e.response?.data}");

  }

  Get.snackbar(
    "Error",
    e.toString(),
  );
}finally {

      isLoading.value = false;

    }
  }
Future<void> updateTraining(
  int id,
) async {

  try {

    isLoading.value = true;

    final result =
        await _service.updateTraining(
      id: id,
      data: buildFormData(),
    );

    final index =
        trainings.indexWhere(
      (e) => e.id == id,
    );

    if (index != -1) {

      trainings[index] = result;
    }

    clearFields();

    Get.back();

    Get.snackbar(
      "Success",
      "Training Updated",
    );

  } finally {

    isLoading.value = false;
  }
}
Future<void> deleteTraining(
  int id,
) async {

  await _service.deleteTraining(id);

  trainings.removeWhere(
    (e) => e.id == id,
  );

  Get.snackbar(
    "Success",
    "Deleted Successfully",
  );
}
void clearFields() {

  titleController.clear();
  providerController.clear();
  startDateController.clear();
  endDateController.clear();
  completedController.clear();
}
void fillForEdit(
  TrainingModel training,
) {

  titleController.text =
      training.title ?? "";

  providerController.text =
      training.provider ?? "";

  startDateController.text =
      training.startDate ?? "";

  endDateController.text =
      training.endDate ?? "";

  completedController.text =
      training.isCompleted
          ?.toString() ?? "";
}
  @override
  void onClose() {

    titleController.dispose();
    providerController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    completedController.dispose();

    super.onClose();
  }
}