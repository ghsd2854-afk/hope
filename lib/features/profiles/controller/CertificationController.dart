import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../mpdel/CertificationModel.dart';
import '../services/CertificationService.dart';

class CertificationController
    extends GetxController {

  final CertificationService _service =
      CertificationService();

  final nameController =
      TextEditingController();

  final issuerController =
      TextEditingController();

  final issuedAtController =
      TextEditingController();

  final expiresAtController =
      TextEditingController();

  final credentialIdController =
      TextEditingController();

  var isLoading = false.obs;

  var certifications =
      <CertificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getCertifications();
  }

  Future<void> getCertifications() async {

    try {

      isLoading.value = true;

      certifications.value =
          await _service
              .getCertifications();

    } finally {

      isLoading.value = false;
    }
  }

  bool validateCertification() {

    if (nameController.text.isEmpty) {

      Get.snackbar(
        "Error",
        "Certification Name Required",
      );

      return false;
    }

    return true;
  }

  FormData buildFormData() {

    return FormData.fromMap({

      "name":
          nameController.text,

      "issuer":
          issuerController.text,

      "issued_at":
          issuedAtController.text,

      "expires_at":
          expiresAtController.text,

      "credential_id":
          credentialIdController.text,
    });
  }

  Future<void> createCertification() async {

    try {

      isLoading.value = true;

      final result =
          await _service
              .createCertification(
        data: buildFormData(),
      );

      certifications.add(result);

      clearFields();

      Get.back();

      Get.snackbar(
        "Success",
        "Certification Added",
      );

    } on DioException catch (e) {

      Get.snackbar(
        "Error",
        e.response?.data.toString() ??
            "Failed",
      );

    } finally {

      isLoading.value = false;
    }
  }

  Future<void> updateCertification(
    int id,
  ) async {

    try {

      isLoading.value = true;

      final result =
          await _service
              .updateCertification(
        id: id,
        data: buildFormData(),
      );

      final index =
          certifications.indexWhere(
        (e) => e.id == id,
      );

      if (index != -1) {

        certifications[index] =
            result;
      }

      clearFields();

      Get.back();

      Get.snackbar(
        "Success",
        "Certification Updated",
      );

    } finally {

      isLoading.value = false;
    }
  }

  Future<void> deleteCertification(
    int id,
  ) async {

    await _service
        .deleteCertification(id);

    certifications.removeWhere(
      (e) => e.id == id,
    );

    Get.snackbar(
      "Success",
      "Deleted Successfully",
    );
  }

  void fillForEdit(
    CertificationModel certification,
  ) {

    nameController.text =
        certification.name ?? "";

    issuerController.text =
        certification.issuer ?? "";

    issuedAtController.text =
        certification.issuedAt ?? "";

    expiresAtController.text =
        certification.expiresAt ?? "";

    credentialIdController.text =
        certification.credentialId ?? "";
  }

  void clearFields() {

    nameController.clear();

    issuerController.clear();

    issuedAtController.clear();

    expiresAtController.clear();

    credentialIdController.clear();
  }

  @override
  void onClose() {

    nameController.dispose();

    issuerController.dispose();

    issuedAtController.dispose();

    expiresAtController.dispose();

    credentialIdController.dispose();

    super.onClose();
  }
}