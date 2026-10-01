import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/home/controllers/MyApplicationsController.dart';

class CvFileScreen extends StatelessWidget {
  const CvFileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // جلب أو حقن الكونترولر
    final controller = Get.find<MyApplicationsController>();

    // استقبال الـ jobId المُمرر عبر Get.arguments بأمان
    final int jobId = Get.arguments is int ? Get.arguments : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("رفع السيرة الذاتية (CV)"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "يرجى رفع ملف الـ CV الخاص بك وإدخال رسالة التغطية لإتمام طلب التقديم:",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // زر اختيار ملف الـ CV من الموبايل
            Obx(
              () => OutlinedButton.icon(
                onPressed: () => controller.pickCvFile(),
                icon: const Icon(Icons.upload_file, color: Colors.blue),
                label: Text(
                  controller.selectedFileName.value.isEmpty
                      ? "اختر ملف الـ CV (PDF / DOCX)"
                      : controller.selectedFileName.value,
                  style: TextStyle(
                    color: controller.selectedFileName.value.isEmpty
                        ? Colors.grey[700]
                        : Colors.black,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: Colors.blue),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // حقل رسالة التغطية (Cover Letter)
            TextField(
              controller: controller.coverLetterController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "رسالة التغطية (Cover Letter)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // زر الإرسال النهائي للطلب
            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.submitApplication(jobId),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        "إرسال طلب التقديم",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
