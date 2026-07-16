import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hobe/features/auth/controllers/auth_controller.dart';


void showLogoutDialog() {
  Get.defaultDialog(
    title: "Log Out",
    middleText: "Are you sure you want to log out?",

    confirm: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      onPressed: () {
        Get.find<AuthController>().logout();
      },
      child: const Text("Log Out"),
    ),

    cancel: TextButton(
      onPressed: () => Get.back(),
      child: const Text("Cancel"),
    ),
  );
}