import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hobe/features/auth/widgets/custum_input.dart';
import 'package:hobe/features/auth/widgets/gradient_button.dart';
import 'package:hobe/features/auth/widgets/showLogoutDialog.dart';

import '../../../core/theme/colors.dart';


import '../controllers/change_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final controller = Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      //  foregroundColor: AppColors.textPrimary,
        title: const Text("Change Password"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            children: [

              const SizedBox(height: 10),

              /// 🧊 Card Container (نفس ستايل التصميم)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  children: [

                    /// Current Password
                    Obx(() => CustomInput(
                          hint: "Current Password",
                          icon: Icons.lock_outline,
                          controller: controller.currentController,
                          isPassword: controller.hideCurrent.value,
                          suffix: IconButton(
                            icon: Icon(
                              controller.hideCurrent.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: controller.toggleCurrent,
                          ),
                        )),

                    const SizedBox(height: 16),

                    /// New Password
                    Obx(() => CustomInput(
                          hint: "New Password",
                          icon: Icons.lock_outline,
                          controller: controller.newController,
                          isPassword: controller.hideNew.value,
                          suffix: IconButton(
                            icon: Icon(
                              controller.hideNew.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: controller.toggleNew,
                          ),
                        )),

                    const SizedBox(height: 16),

                    /// Confirm Password
                    Obx(() => CustomInput(
                          hint: "Confirm New Password",
                          icon: Icons.lock_outline,
                          controller: controller.confirmController,
                          isPassword: controller.hideConfirm.value,
                          suffix: IconButton(
                            icon: Icon(
                              controller.hideConfirm.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: controller.toggleConfirm,
                          ),
                        )),

                    const SizedBox(height: 25),/// Button
                    Obx(() => GradientButton(
                          text: "Update Password",
                          loading: controller.isLoading.value,
                          onTap: controller.submit,
                        )),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// Logout (اختياري مثل التصميم)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.red.withOpacity(0.1),
                ),
                child: TextButton(
                  onPressed: () {
                   showLogoutDialog();
                  },
                  child: const Text(
                    "Log Out",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: () => Get.back(),
                child: const Text("Cancel"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}