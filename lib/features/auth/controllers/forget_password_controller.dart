import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/app_routes.dart';
import 'package:hobe/features/auth/services/auth_services.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  var isLoading = false.obs;

  final AuthService _authService = AuthService();

  Future<void> sendResetLink() async {
    if (emailController.text.isEmpty) {
      Get.snackbar("Error", "Enter your email");
      return;
    }

    try {
      isLoading.value = true;

      final response = await _authService.requestPasswordOtp(
        email: emailController.text.trim(),
      );

      Get.snackbar("Success", response.message);

      Get.toNamed(
        AppRoutes.otp,
        arguments: {
          "email": emailController.text.trim(),
          "isLoginOtp": false,
          "isResetPassword": true,
        },
      );

    } catch (e) {
      Get.snackbar("Error", e.toString());
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

