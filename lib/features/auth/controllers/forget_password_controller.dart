import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/app_routes.dart';
import 'package:hobe/features/auth/services/auth_services.dart';

class ForgotPasswordController extends GetxController {

  final emailController =
      TextEditingController();

  var isLoading = false.obs;

  final AuthService _authService =
      AuthService();

  bool validateEmail() {

    final email =
        emailController.text.trim();

    if (email.isEmpty) {

      Get.snackbar(
        "Error",
        "Email is required",
      );

      return false;
    }

    if (!GetUtils.isEmail(email)) {

      Get.snackbar(
        "Error",
        "Enter a valid email address",
      );

      return false;
    }

    return true;
  }

  Future<void> sendResetLink() async {

    if (!validateEmail()) {
      return;
    }

    try {

      isLoading.value = true;

      final response =
          await _authService
              .requestPasswordOtp(
        email:
            emailController.text.trim(),
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
          "isResetPassword": true,
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

    emailController.dispose();

    super.onClose();
  }
}