import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hobe/features/auth/views/login_screen.dart';

class AuthController extends GetxController {

  var isLoading = false.obs;

  /// 🔑 Login (تجريبي)
  // Future<void> login({
  //   required String email,
  //   required String password,
  // }) async {
  //   if (email.isEmpty || password.isEmpty) {
  //     Get.snackbar("Error", "All fields are required");
  //     return;
  //   }

  //   isLoading.value = true;

  //   await Future.delayed(const Duration(seconds: 2)); // simulate

  //   isLoading.value = false;

  //   Get.snackbar("Success", "Logged in (UI فقط)");
  // }

  /// 🚪 Logout (UI فقط)
  void logout() {
    Get.snackbar("Logout", "You have been logged out");

    /// رجوع للوغ إن
    Get.offAll(() => LoginScreen());
  }
}