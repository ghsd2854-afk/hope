import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hobe/features/auth/controllers/forget_password_controller.dart';


import '../../../core/theme/colors.dart';




import 'package:hobe/features/auth/widgets/custum_input.dart';
import 'package:hobe/features/auth/widgets/gradient_button.dart';



import '../../auth/views/login_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final controller = Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),

              /// 🔙 Back
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back),
              ),

              const SizedBox(height: 10),

              /// Title
              const Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
               //   color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 10),

              /// Description
              const Text(
                "Enter your email to receive a password reset link.",
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 30),

              /// Email Input
              CustomInput(
                hint: "Email",
                icon: Icons.email_outlined,
                controller: controller.emailController,
              ),

              const SizedBox(height: 25),

              /// Button
              Obx(() => GradientButton(
                    text: "Send Reset Link",
                    loading: controller.isLoading.value,
                onTap: controller.sendResetLink,
                  )),

              const SizedBox(height: 20),

              /// Return to Login
              Center(
                child: TextButton(
                  onPressed: () {
                    Get.offAll(() => LoginScreen());
                  },
                  child: const Text(
                    "Return to Login",
                    style: TextStyle(
                      color: AppColors.primaryStart,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}