import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:hobe/features/auth/views/forgot_password_screen.dart';

import 'package:hobe/features/auth/views/signup_screen.dart';

import '../controllers/login_controller.dart';

import '../widgets/custum_input.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,

            end: Alignment.bottomCenter,

            colors: [Color(0xFFDCCBFF), Color(0xFFF8F7FF)],
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),

              child: Column(
                children: [
                  const SizedBox(height: 50),

                  /// LOGO

                  // Image.asset(

                  //   "assets/photo_2026-06-18_12-28-37.jpg",

                  //   height: 150,

                  // ),
                  const SizedBox(height: 50),

                  const Text(
                    "HOPE",

                    style: TextStyle(
                      color: Color(0xFF8B5CF6),

                      fontSize: 34,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 100),

                  /// FORM CARD
                  Container(
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(20),

                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,

                          blurRadius: 12,

                          offset: Offset(0, 4),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Text(
                          "Email",

                          style: TextStyle(
                            fontSize: 18,

                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 10),

                        CustomInput(
                          hint: "mail@example.com",

                          icon: Icons.email_outlined,

                          controller: controller.emailController,
                        ),

                        const SizedBox(height: 25),

                        const Text(
                          "Password",

                          style: TextStyle(
                            fontSize: 18,

                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Obx(
                          () => CustomInput(
                            hint: "••••••••",

                            icon: Icons.lock_outline,

                            controller: controller.passwordController,

                            isPassword: controller.isPasswordHidden.value,

                            suffix: IconButton(
                              icon: Icon(
                                controller.isPasswordHidden.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,

                                color: Colors.grey,
                              ),

                              onPressed: controller.togglePassword,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  /// LOGIN BUTTON
                  Obx(
                    () => Container(
                      width: double.infinity,

                      height: 55,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),

                        gradient: const LinearGradient(
                          colors: [Color(0xFF9F67FF), Color(0xFF7C3AED)],
                        ),
                      ),

                      child: Material(
                        color: Colors.transparent,

                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),

                          onTap: controller.login,

                          child: Center(
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Login",

                                    style: TextStyle(
                                      color: Colors.white,

                                      fontSize: 18,

                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () {
                      Get.to(() => ForgotPasswordScreen());
                    },

                    child: const Text(
                      "Forgot Password?",

                      style: TextStyle(color: Color(0xFF7C3AED), fontSize: 17),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      const Text(
                        "No account? ",

                        style: TextStyle(fontSize: 16),
                      ),

                      GestureDetector(
                        onTap: () {
                          Get.to(() => SignUpScreen());
                        },

                        child: const Text(
                          "Sign Up",

                          style: TextStyle(
                            color: Color(0xFF7C3AED),

                            fontWeight: FontWeight.bold,

                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
