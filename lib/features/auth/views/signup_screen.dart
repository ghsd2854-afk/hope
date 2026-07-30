import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/auth/views/otp_screen.dart';


import 'package:hobe/features/auth/widgets/custum_input.dart';
import 'package:hobe/features/auth/widgets/gradient_button.dart';


import '../../../core/theme/colors.dart';



import 'package:hobe/features/profiles/view/profile_screen.dart';


import '../controllers/signup_controller.dart';
import 'login_screen.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final controller = Get.put(SignUpController());
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
                  height: 50,
                ),

                /// LOGO

                const SizedBox(
                  height: 50,
                ),

                const Text(

                  "HOPE",

                  style: TextStyle(

                    color: Color(0xFF8B5CF6),

                    fontSize: 34,

                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 60,
                ),

                /// CARD

                Container(

                  padding: const EdgeInsets.all(
                    20,
                  ),

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),

                    boxShadow: const [

                      BoxShadow(

                        color: Colors.black12,

                        blurRadius: 12,

                        offset: Offset(
                          0,
                          4,
                        ),
                      ),
                    ],
                  ),

                  child: Column(

                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      const Text(

                        "Full Name",

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

                        hint: "Enter Full Name",

                        icon: Icons.person_outline,

                        controller:
                            controller.nameController,
                      ),

                      const SizedBox(
                        height: 20,
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

                        hint: "mail@example.com",

                        icon:
                            Icons.email_outlined,

                        controller:
                            controller.emailController,
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      const Text(

                        "Password",

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

                          hint: "••••••••",

                          icon:
                              Icons.lock_outline,

                          controller:
                              controller.passwordController,

                          isPassword:
                              controller
                                  .hidePassword
                                  .value,

                          suffix:
                              IconButton(

                            icon: Icon(

                              controller
                                      .hidePassword
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

                          hint: "••••••••",

                          icon:
                              Icons.lock_outline,

                          controller:
                              controller.confirmController,

                          isPassword:
                              controller
                                  .hideConfirm
                                  .value,

                          suffix:
                              IconButton(

                            icon: Icon(

                              controller
                                      .hideConfirm
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

                /// SIGN UP BUTTON

                Obx(

                  () => Container(

                    width: double.infinity,

                    height: 55,

                    decoration:
                        BoxDecoration(

                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),

                      gradient:
                          const LinearGradient(

                        colors: [

                          Color(0xFF9F67FF),
                          Color(0xFF7C3AED),

                        ],
                      ),
                    ),

                    child: Material(

                      color:
                          Colors.transparent,

                      child: InkWell(

                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),

                        onTap:
                            controller.register,

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

                                      "Sign Up",

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
                  height: 20,
                ),

                Row(

                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [

                    const Text(

                      "Already have an account? ",
                    ),

                    GestureDetector(

                      onTap: () {

                        Get.off(
                          () =>
                              LoginScreen(),
                        );
                      },

                      child: const Text(

                        "Log In",

                        style: TextStyle(

                          color:
                              Color(0xFF7C3AED),

                          fontWeight:
                              FontWeight.bold,

                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 40,
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