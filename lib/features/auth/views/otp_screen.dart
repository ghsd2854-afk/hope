import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/auth/controllers/otp_controller.dart';

class OtpView extends StatelessWidget {

  OtpView({super.key});

  final OtpController controller =
      Get.put(OtpController());

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

              Color(0xFFD7C2FF),
              Color(0xFFEDE6FF),
              Color(0xFFF8F7FF),

            ],
          ),
        ),

        child: SafeArea(

          child: Center(

            child: Padding(

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 25,
              ),

              child: Container(

                padding:
                    const EdgeInsets.all(25),

                decoration: BoxDecoration(

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

                  mainAxisSize:
                      MainAxisSize.min,

                  children: [

                    const Text(

                      "Enter Reset OTP",

                      style: TextStyle(

                        fontSize: 30,

                        fontWeight:
                            FontWeight.bold,

                        color:
                            Color(0xFF6D3BB3),
                      ),
                    ),

                    const SizedBox(
                      height: 35,
                    ),

                    TextField(

                      controller:
                          controller
                              .otpController,

                      keyboardType:
                          TextInputType.number,

                      textAlign:
                          TextAlign.center,

                      style: const TextStyle(
                        fontSize: 22,
                        letterSpacing: 10,
                      ),

                      decoration:
                          InputDecoration(

                        hintText:
                            "------",

                        hintStyle:
                            TextStyle(
                          color: Colors
                              .grey.shade400,
                          letterSpacing:
                              10,
                        ),

                        filled: true,

                        fillColor:
                            Colors.white,

                        border:
                            OutlineInputBorder(

                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),

                          borderSide:
                              BorderSide(
                            color: Colors
                                .grey.shade300,
                          ),
                        ),

                        enabledBorder:
                            OutlineInputBorder(

                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),

                          borderSide:
                              BorderSide(
                            color: Colors
                                .grey.shade300,
                          ),
                        ),

                        focusedBorder:
                            const OutlineInputBorder(

                          borderRadius:
                              BorderRadius.all(
                            Radius.circular(
                                12),
                          ),

                          borderSide:
                              BorderSide(
                            color:
                                Color(
                                    0xFF8B5CF6),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 25,
                    ),

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

                          color: Colors
                              .transparent,

                          child: InkWell(

                            borderRadius:
                                BorderRadius
                                    .circular(
                              12,
                            ),

                            onTap: controller
                                    .isLoading
                                    .value
                                ? null
                                : controller
                                    .verifyOtp,

                            child: Center(

                              child: controller
                                      .isLoading
                                      .value

                                  ? const CircularProgressIndicator(
                                      color:
                                          Colors
                                              .white,
                                    )

                                  : const Text(

                                      "Verify",

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
                    Obx(() => TextButton(
  onPressed: controller.secondsRemaining.value == 0
      ? controller.resendOtp
      : null,
  child: Text(
    controller.secondsRemaining.value == 0
        ? "إعادة إرسال الرمز"
        : "إعادة الإرسال بعد ${controller.secondsRemaining.value} ثانية",
  ),
))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}