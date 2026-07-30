import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hobe/features/auth/widgets/custum_input.dart';
import 'package:hobe/features/auth/widgets/gradient_button.dart';

import '../controllers/reset_password_controller.dart';

class ResetNewPasswordScreen extends StatelessWidget {
  ResetNewPasswordScreen({super.key});

  final controller =
      Get.find<ResetPasswordController>();
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

                          "Reset Password",

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

                        "New Password",

                        style: TextStyle(

                          fontSize: 18,

                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Obx(

                        () => CustomInput(

                          hint:
                              "••••••••",

                          icon: Icons
                              .lock_outline,

                          controller:
                              controller
                                  .newPasswordController,

                          isPassword:
                              controller
                                  .isPasswordHidden
                                  .value,

                          suffix:
                              IconButton(

                            icon: Icon(

                              controller
                                      .isPasswordHidden
                                      .value
                                  ? Icons
                                      .visibility_off_outlined
                                  : Icons
                                      .visibility_outlined,
                            ),

                            onPressed:
                                controller
                                    .togglePassword,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      const Text(

                        "Confirm Password",

                        style: TextStyle(

                          fontSize: 18,

                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Obx(

                        () => CustomInput(

                          hint:
                              "••••••••",

                          icon: Icons
                              .lock_outline,

                          controller:
                              controller
                                  .confirmPasswordController,

                          isPassword:
                              controller
                                  .isConfirmHidden
                                  .value,

                          suffix:
                              IconButton(

                            icon: Icon(

                              controller
                                      .isConfirmHidden
                                      .value
                                  ? Icons
                                      .visibility_off_outlined
                                  : Icons
                                      .visibility_outlined,
                            ),

                            onPressed:
                                controller
                                    .toggleConfirm,
                          ),
                        ),
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

                        onTap:
                            controller
                                .resetPassword,

                        child: Center(

                          child:
                              controller
                                      .isLoading
                                      .value
                                  ? const CircularProgressIndicator(
                                      color:
                                          Colors.white,
                                    )
                                  : const Text(

                                      "Update Password",

                                      style:
                                          TextStyle(

                                        color:
                                            Colors.white,

                                        fontSize:
                                            18,

                                        fontWeight:
                                            FontWeight.bold,
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

                    "Back",

                    style: TextStyle(

                      color:
                          Color(0xFF7C3AED),

                      fontSize: 16,

                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
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