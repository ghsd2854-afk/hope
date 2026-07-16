import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/auth/views/otp_screen.dart';


import 'package:hobe/features/auth/widgets/custum_input.dart';
import 'package:hobe/features/auth/widgets/gradient_button.dart';


import '../../../core/theme/colors.dart';



import 'package:hobe/features/auth/views/profile_screen.dart';


import '../controllers/signup_controller.dart';
import 'login_screen.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [

              const SizedBox(height: 40),

              /// 🌍 نفس الأيقونة تبعك (اختياري تنسخيها من Login)
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8, // عرض الصورة 80% من الشاشة
                  height: 250,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/photo_2026-04-28_17-44-40.jpg'), // مسار الصورة
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Title
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
             //     color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 30),

              /// Name
              CustomInput(
                hint: "Full Name",
                icon: Icons.person_outline,
                controller: controller.nameController,
              ),

              const SizedBox(height: 16),

              /// Email
              CustomInput(
                hint: "Email",
                icon: Icons.email_outlined,
                controller: controller.emailController,
              ),

              const SizedBox(height: 16),

              /// Password
              Obx(() => CustomInput(
                    hint: "Password",
                    icon: Icons.lock_outline,
                    controller: controller.passwordController,
                    isPassword: controller.hidePassword.value,
                    suffix: IconButton(
                      icon: Icon(
                        controller.hidePassword.value
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

              const SizedBox(height: 25),

              /// Button
          /// Button
Obx(() => GradientButton(
      text: "Sign Up",
      loading: controller.isLoading.value,
      onTap: controller.register,
    )),

const SizedBox(height: 25),

/// Back to Login
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Text("Already have an account? "),
    TextButton(
      onPressed: () {
        Get.off(() => LoginScreen());
      },
      child: const Text(
        "Log In",
        style: TextStyle(
          color: AppColors.primaryStart,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ],
),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}