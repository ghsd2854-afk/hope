import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/app_routes.dart';
import 'package:hobe/features/auth/services/auth_services.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
final AuthService _authService =
    AuthService();
  var isPasswordHidden = true.obs;
  var isLoading = false.obs;

  void togglePassword() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

Future<void> login() async {

  if (!validateLogin()) {
    return;
  }

  try {

    isLoading.value = true;

    
    final response =
        await _authService.login(
      email: emailController.text.trim(),
      password:
          passwordController.text.trim(),
    );
    print("STATUS = ${response.status}");
print("MESSAGE = ${response.message}");

    Get.snackbar(
      "Success",
      response.message,
    );

  Get.toNamed(
  AppRoutes.otp,
  arguments: {
    "email":
        emailController.text.trim(),
    "isLoginOtp": true,
  },
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
bool validateLogin() {

  if (emailController.text.trim().isEmpty) {

    Get.snackbar(
      "Error",
      "Email is required",
    );

    return false;
  }

  if (!GetUtils.isEmail(
    emailController.text.trim(),
  )) {

    Get.snackbar(
      "Error",
      "Invalid email format",
    );

    return false;
  }

  if (passwordController.text.isEmpty) {

    Get.snackbar(
      "Error",
      "Password is required",
    );

    return false;
  }

  if (passwordController.text.length < 6) {

    Get.snackbar(
      "Error",
      "Password must be at least 6 characters",
    );

    return false;
  }

  return true;
}

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}