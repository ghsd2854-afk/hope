import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/app_routes.dart';
import 'package:hobe/features/auth/services/auth_services.dart';
import 'package:hobe/features/auth/views/otp_screen.dart';

class SignUpController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
final AuthService _authService = AuthService();
  var isLoading = false.obs;
  var hidePassword = true.obs;
  var hideConfirm = true.obs;

  void togglePassword() => hidePassword.value = !hidePassword.value;
  void toggleConfirm() => hideConfirm.value = !hideConfirm.value;

  String? validate() {
    if (nameController.text.isEmpty) {
      return "Name is required";
    }
    if (emailController.text.isEmpty) {
      return "Email is required";
    }
    if (passwordController.text.length < 6) {
      return "Password must be at least 6 characters";
    }
    if (passwordController.text != confirmController.text) {
      return "Passwords do not match";
    }
    return null;
  }





Future<void> register() async {
  final error = validate();

  if (error != null) {
    Get.snackbar(
      "Error",
      error,
    );
    return;
  }

  try {
    isLoading.value = true;

    final response =
        await _authService.register(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      passwordConfirmation:
          confirmController.text.trim(),
    );

 Get.snackbar(
  "Success",
  response.message,
);

Get.toNamed(
  AppRoutes.otp,
  arguments: {
    "email":
        emailController.text.trim(),
    "isLoginOtp": false,
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
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.onClose();
  }
}