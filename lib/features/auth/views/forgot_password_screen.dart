import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hobe/features/auth/controllers/forget_password_controller.dart';
import 'package:hobe/features/auth/widgets/custum_input.dart';
import 'package:hobe/features/auth/widgets/gradient_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final controller =
      Get.put(ForgotPasswordController());
@override
Widget build(BuildContext context) {

  return Scaffold(

    body: Container(

      width: double.infinity,

      decoration: const BoxDecoration(

        gradient: LinearGradient(

          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,

          colors: [

            Color(0xFFDCCBFF),
            Color(0xFFF8F7FF),

          ],
        ),
      ),

      child: SafeArea(

        child: SingleChildScrollView(

          child: Padding(

            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),

            child: Column(

              children: [

                const SizedBox(
                  height: 60,
                ),

                const Text(

                  "HOPE",

                  style: TextStyle(

                    color:
                        Color(0xFF8B5CF6),

                    fontSize: 34,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 80,
                ),

                /// CARD

                Container(

                  padding:
                      const EdgeInsets.all(
                    20,
                  ),

                  decoration:
                      BoxDecoration(

                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),

                    boxShadow: const [

                      BoxShadow(

                        color:
                            Colors.black12,

                        blurRadius: 12,

                        offset:
                            Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Column(

                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      const Center(

                        child: Text(

                          "Forgot Password",

                          style: TextStyle(

                            fontSize: 28,

                            fontWeight:
                                FontWeight.bold,

                            color: Color(
                              0xFF7C3AED,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      const Text(

                        "Email",

                        style: TextStyle(

                          fontSize: 18,

                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      CustomInput(

                        hint:
                            "mail@example.com",

                        icon: Icons
                            .email_outlined,

                        controller:
                            controller
                                .emailController,
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 35,
                ),

                /// BUTTON

                Obx(

                  () => Container(

                    width:
                        double.infinity,

                    height: 55,

                    decoration:
                        BoxDecoration(

                      borderRadius:
                          BorderRadius
                              .circular(
                        12,
                      ),

                      gradient:
                          const LinearGradient(

                        colors: [

                          Color(
                              0xFF9F67FF),

                          Color(
                              0xFF7C3AED),

                        ],
                      ),
                    ),

                    child: Material(

                      color:
                          Colors.transparent,

                      child: InkWell(

                        borderRadius:
                            BorderRadius
                                .circular(
                          12,
                        ),

                        onTap: controller
                            .sendResetLink,

                        child: Center(

                          child: controller
                                  .isLoading
                                  .value
                              ? const CircularProgressIndicator(
                                  color:
                                      Colors.white,
                                )
                              : const Text(

                                  "Send OTP",

                                  style:
                                      TextStyle(

                                    color:
                                        Colors
                                            .white,

                                    fontSize:
                                        18,

                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                TextButton(

                  onPressed: () {
                    Get.back();
                  },

                  child: const Text(

                    "Back to Login",

                    style: TextStyle(

                      color:
                          Color(0xFF7C3AED),

                      fontSize: 16,

                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}