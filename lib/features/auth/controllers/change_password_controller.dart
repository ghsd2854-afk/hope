import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  final currentController = TextEditingController();
  final newController = TextEditingController();
  final confirmController = TextEditingController();

  var isLoading = false.obs;
  var hideCurrent = true.obs;
  var hideNew = true.obs;
  var hideConfirm = true.obs;

  void toggleCurrent() => hideCurrent.value = !hideCurrent.value;
  void toggleNew() => hideNew.value = !hideNew.value;
  void toggleConfirm() => hideConfirm.value = !hideConfirm.value;

  String? validate() {
    if (currentController.text.isEmpty) {
      return "Current password is required";
    }
    if (newController.text.length < 6) {
      return "New password must be at least 6 characters";
    }
    if (newController.text != confirmController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  Future<void> submit() async {
    final error = validate();
    if (error != null) {
      Get.snackbar("Error", error);
      return;
    }

    isLoading.value = true;

    // TODO: اربطي API (Laravel) هون
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    Get.snackbar("Success", "Password updated successfully");
    Get.back(); // رجوع للشاشة السابقة
  }

  @override
  void onClose() {
    currentController.dispose();
    newController.dispose();
    confirmController.dispose();
    super.onClose();
  }
}