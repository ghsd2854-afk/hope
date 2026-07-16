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
      appBar: AppBar(
        title: const Text("Verify OTP"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const SizedBox(height: 30),

            TextField(
              controller: controller.otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "OTP",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.verifyOtp,
                child: controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text("Verify"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}