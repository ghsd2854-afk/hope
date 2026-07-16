import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/auth/services/auth_services.dart';
import 'package:hobe/features/auth/views/reset_new_password_screen.dart';

class ResetPasswordController extends GetxController {
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isLoading = false.obs;
  var isPasswordHidden = true.obs;
  var isConfirmHidden = true.obs;
final AuthService _authService =
    AuthService();

late String email;
@override
void onInit() {

  email = Get.arguments ?? "";

  super.onInit();
}
 Future<void> verifyOtp() async {

  try {

    isLoading.value = true;

    final response =
        await _authService.verifyPasswordOtp(
      email: email,
      otp: otpController.text.trim(),
    );

    Get.snackbar(
      "Success",
      response.message,
    );

    Get.to(
      () => ResetNewPasswordScreen(),
      arguments: email,
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

 Future<void> resetPassword() async {

  if (newPasswordController.text !=
      confirmPasswordController.text) {

    Get.snackbar(
      "Error",
      "Passwords do not match",
    );

    return;
  }

  try {

    isLoading.value = true;

    final response =
        await _authService.resetPassword(
      email: email,
      new_password:
          newPasswordController.text,
      new_password_confirmation:
          confirmPasswordController.text,
    );

    Get.snackbar(
      "Success",
      response.message,
    );

    Get.offAllNamed(
      "/login",
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

  void togglePassword() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirm() {
    isConfirmHidden.value = !isConfirmHidden.value;
  }
  

  @override
  void onClose() {
    otpController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}