import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:hobe/features/profiles/mpdel/ProjectModel.dart';
import 'package:hobe/features/profiles/services/ProjectService.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';


class ProjectController
    extends GetxController {

  final ProjectService _service =
      ProjectService();

  final titleController =
      TextEditingController();

  final descriptionController =
      TextEditingController();

  final linkController =
      TextEditingController();

  final technologiesController =
      TextEditingController();

  var isLoading = false.obs;

  var projects =
      <ProjectModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getProjects();
  }

  bool validateProject() {

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

  final techs =
      technologiesController.text
          .split(",")
          .where(
            (e) => e.trim().isNotEmpty,
          )
          .toList();

  return FormData.fromMap({

    "title":
        titleController.text,

    "description":
        descriptionController.text,

    "link":
        linkController.text,

    for (
      int i = 0;
      i < techs.length;
      i++
    )
      "technologies[$i]":
          techs[i].trim(),
  });
}

  Future<void> getProjects() async {

    try {

      isLoading.value = true;

      projects.value =
          await _service.getProjects();

    } finally {

      isLoading.value = false;

    }
  }

  Future<void> createProject() async {

    try {

      isLoading.value = true;

      final result =
          await _service.createProject(
        data: buildFormData(),
      );

      projects.add(result);

      clearFields();

      Get.back();

      Get.snackbar(
        "Success",
        "Project Added",
      );

    } finally {

      isLoading.value = false;

    }
  }

Future<void> updateProject(
  int id,
) async {

  try {

    isLoading.value = true;

    final result =
        await _service.updateProject(
      id: id,
      data: buildFormData(),
    );

    final index =
        projects.indexWhere(
      (e) => e.id == id,
    );

    if (index != -1) {
      projects[index] = result;
    }

    clearFields();

    Get.back();

    Get.snackbar(
      "Success",
      "Project Updated",
    );

  } finally {

    isLoading.value = false;

  }
}
  Future<void> deleteProject(
    int id,
  ) async {

    await _service.deleteProject(id);

    projects.removeWhere(
      (e) => e.id == id,
    );

    Get.snackbar(
      "Success",
      "Deleted",
    );
  }

  void fillForEdit(
    ProjectModel project,
  ) {

    titleController.text =
        project.title ?? "";

    descriptionController.text =
        project.description ?? "";

    linkController.text =
        project.link ?? "";

    technologiesController.text =
        project.technologies
                ?.join(",") ??
            "";
  }

  void clearFields() {

    titleController.clear();
    descriptionController.clear();
    linkController.clear();
    technologiesController.clear();
  }
}