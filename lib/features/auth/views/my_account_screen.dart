// lib/screens/account/my_account_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/auth/controllers/account_controller.dart';


class MyAccountScreen extends StatelessWidget {
  MyAccountScreen({super.key});

  final AccountController controller = Get.put(AccountController());

  void _showOtpDialog(BuildContext context) {
    final otpController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: TextField(
          controller: otpController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'أدخل رمز OTP'),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () {
                        Get.back();
                        controller.confirmDelete(otpController.text.trim());
                      },
                child: controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text('تأكيد'),
              )),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('حذف الحساب'),
        content: const Text(
          'هل أنت متأكد أنك تريد حذف حسابك؟ سيتم إرسال رمز تأكيد إلى بريدك الإلكتروني.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Get.back();
              await controller.requestDelete();
              if (controller.otpSent.value) {
                _showOtpDialog(context);
              }
            },
            child: const Text('متابعة'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Account')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('البريد الإلكتروني: ${controller.userEmail}'),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text(
                'Delete Account',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () => _showDeleteConfirmDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}