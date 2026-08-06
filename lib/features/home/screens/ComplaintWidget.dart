import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/home/controllers/ComplaintController.dart';

class ComplaintUI {
  static void showComplaintDialog(
    BuildContext context,
    int targetId,
    String targetType,
    String titleText,
  ) {
    // حقن أو جلب الكونترولر
    final ComplaintController controller = Get.put(ComplaintController());

    // إعادة تعيين النص عند فتح النافذة
    controller.complaintController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(titleText),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "الرجاء كتابة تفاصيل الشكوى ليتم مراجعتها من قبل الإدارة:",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller.complaintController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "اكتب شكواك هنا...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إلغاء", style: TextStyle(color: Colors.grey)),
            ),
            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.submitComplaint(targetId, targetType),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text("إرسال"),
              ),
            ),
          ],
        );
      },
    );
  }
}
