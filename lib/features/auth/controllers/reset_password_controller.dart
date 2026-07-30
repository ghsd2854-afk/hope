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

  if (!validateOtp()) {
    return;
  }

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
bool validateOtp() {

  final otp =
      otpController.text.trim();

  if (otp.isEmpty) {

    Get.snackbar(
      "Error",
      "OTP is required",
    );

    return false;
  }

  if (otp.length != 6) {

    Get.snackbar(
      "Error",
      "OTP must be 6 digits",
    );

    return false;
  }

  if (!GetUtils.isNumericOnly(otp)) {

    Get.snackbar(
      "Error",
      "OTP must contain numbers only",
    );

    return false;
  }

  return true;
}
Future<void> resetPassword() async {

  if (!validatePasswordReset()) {
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
  bool validatePasswordReset() {

  final password =
      newPasswordController.text.trim();

  final confirm =
      confirmPasswordController.text.trim();

  if (password.isEmpty) {

    Get.snackbar(
      "Error",
      "Password is required",
    );

    return false;
  }

  if (password.length < 8) {

    Get.snackbar(
      "Error",
      "Password must be at least 8 characters",
    );

    return false;
  }

  if (!RegExp(r'(?=.*[A-Z])')
      .hasMatch(password)) {

    Get.snackbar(
      "Error",
      "Password must contain at least one uppercase letter",
    );

    return false;
  }

  if (!RegExp(r'(?=.*[0-9])')
      .hasMatch(password)) {

    Get.snackbar(
      "Error",
      "Password must contain at least one number",
    );

    return false;
  }

  if (password != confirm) {

    Get.snackbar(
      "Error",
      "Passwords do not match",
    );

    return false;
  }

  return true;
}

  @override
  void onClose() {
    otpController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}