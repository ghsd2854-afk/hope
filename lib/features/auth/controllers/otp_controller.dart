import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hobe/features/auth/services/auth_services.dart';

class OtpController extends GetxController {
  final otpController = TextEditingController();

  final AuthService _authService = AuthService();

  var isLoading = false.obs;

  late String email;
  late bool isLoginOtp;
  late bool isResetPassword;
  @override
  void onInit() {
    print("OTP CONTROLLER CREATED");

    print("ARGS => ${Get.arguments}");

    final args = Get.arguments;

    email = args["email"];
    isLoginOtp = args["isLoginOtp"] ?? false;

    isResetPassword = args["isResetPassword"] ?? false;

    super.onInit();
  }

  Future<void> verifyOtp() async {
    if (otpController.text.trim().isEmpty) {
      Get.snackbar("Error", "Enter OTP code");
      return;
    }

    try {
      isLoading.value = true;
      final box = GetStorage();

      // 1. منطق الـ Reset Password يبقى كما هو
      if (isResetPassword) {
        final response = await _authService.verifyPasswordOtp(
          email: email,
          otp: otpController.text.trim(),
        );
        Get.snackbar("Success", response.message);
        Get.toNamed("/reset-password", arguments: email);
      }
      // 2. توحيد المسار لكل من Login و Register
      else {
        // تنفيذ الطلب بناءً على الحالة
        if (isLoginOtp) {
          final response = await _authService.verifyLoginOtp(
            email: email,
            otp: otpController.text.trim(),
          );
          await box.write("token", response.token);
          await box.write("name", response.name);
          await box.write("email", response.email);
          Get.snackbar("Success", response.message);
        } else {
          final response = await _authService.verifyOtp(
            email: email,
            otp: otpController.text.trim(),
          );
          await box.write("token", response.token);
          await box.write("email", email);
          Get.snackbar("Success", response.message);
        }

        // الانتقال الموحد هنا
        print("Navigating to Home...");
        Get.offAllNamed("/home");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
