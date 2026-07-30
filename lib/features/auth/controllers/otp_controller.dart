import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hobe/features/auth/services/auth_services.dart';
import 'package:hobe/features/profiles/services/profile_services.dart';

class OtpController extends GetxController {
  final otpController = TextEditingController();
final profileService = ProfileService();
  final AuthService _authService = AuthService();

  var isLoading = false.obs;

  late String email;
  late bool isLoginOtp;
late bool   isResetPassword ;

  var secondsRemaining = 0.obs;
  Timer? _timer;

  void startCooldown() {
    secondsRemaining.value = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining.value <= 1) {
        t.cancel();
        secondsRemaining.value = 0;
      } else {
        secondsRemaining.value--;
      }
    });
  }

  Future<void> resendOtp() async {
    if (secondsRemaining.value > 0) return; // الزر معطل أثناء العد

    try {
      isLoading.value = true;

      final response = await _authService.resendOtp(email: email);
      // ^ رح أضبط اسم الدالة/الشكل بالظبط بعد ما تبعتيلي auth_services.dart

      Get.snackbar("تم", response.message);
      startCooldown();

    } catch (e) {
      Get.snackbar("خطأ", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
@override
void onInit() {

  print("OTP CONTROLLER CREATED");

  print("ARGS => ${Get.arguments}");

  final args = Get.arguments;

  email = args["email"];
  isLoginOtp =
      args["isLoginOtp"] ?? false;

  isResetPassword =
      args["isResetPassword"] ?? false;
startCooldown();
  super.onInit();
}

 Future<void> verifyOtp() async {
  if (otpController.text.trim().isEmpty) {
    Get.snackbar(
      "Error",
      "Enter OTP code",
    );
    return;
  }

  try {
    isLoading.value = true;

    final box = GetStorage();

    // ===== FORGOT PASSWORD =====
    if (isResetPassword) {

      final response =
          await _authService.verifyPasswordOtp(
        email: email,
        otp: otpController.text.trim(),
      );

      Get.snackbar(
        "Success",
        response.message,
      );

      Get.toNamed(
        "/reset-password",
        arguments: email,
      );
    }

    // ===== LOGIN OTP =====
// ===== LOGIN OTP =====
    else if (isLoginOtp) {

      final response =
          await _authService.verifyLoginOtp(
        email: email,
        otp: otpController.text.trim(),
      );

      await box.write("token", response.token);
      await box.write("name", response.name);
      await box.write("email", response.email);

      Get.snackbar("Success", response.message);

      // منفحص هل عندو بروفايل محفوظ ولا لأ
      try {
        await profileService.getProfile();
        Get.offAllNamed("/home");
      } catch (e) {
        Get.offAllNamed("/onboarding");
      }
    }

    // ===== REGISTER OTP =====
    else {

      final response =
          await _authService.verifyOtp(
        email: email,
        otp: otpController.text.trim(),
      );

      await box.write(
        "token",
        response.token,
      );

      await box.write(
        "email",
        email,
      );

      Get.snackbar(
        "Success",
        response.message,
      );

      Get.offAllNamed(
        "/onboarding",
      );
    }

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
   
    
    _timer?.cancel();
    otpController.dispose();
    super.onClose();
  }
}