import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:hobe/features/auth/widgets/custum_input.dart';
import 'package:hobe/features/auth/widgets/gradient_button.dart';


import '../../../core/theme/colors.dart';



import '../controllers/reset_password_controller.dart';

class ResetNewPasswordScreen extends StatelessWidget {
  ResetNewPasswordScreen({super.key});

  final controller = Get.find<ResetPasswordController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 40),

            const Text(
              "Create New Password",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              "Enter your new password below",
              style: TextStyle(color: AppColors.textSecondary),
            ),

            const SizedBox(height: 30),

            /// New Password
            Obx(() => CustomInput(
                  hint: "New Password",
                  icon: Icons.lock_outline,
                  controller: controller.newPasswordController,
                  isPassword: controller.isPasswordHidden.value,
                  suffix: IconButton(
                    icon: Icon(
                      controller.isPasswordHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: controller.togglePassword,
                  ),
                )),

            const SizedBox(height: 16),

            /// Confirm Password
            Obx(() => CustomInput(
                  hint: "Confirm Password",
                  icon: Icons.lock_outline,
                  controller: controller.confirmPasswordController,
                  isPassword: controller.isConfirmHidden.value,
                  suffix: IconButton(
                    icon: Icon(
                      controller.isConfirmHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: controller.toggleConfirm,
                  ),
                )),

            const SizedBox(height: 25),

            Obx(() => GradientButton(
                  text: "Reset Password",
                  loading: controller.isLoading.value,
                  onTap: controller.resetPassword,
                )),
          ],
        ),
      ),
    );
  }
}