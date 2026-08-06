import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/core/theme/colors.dart';
import 'package:hobe/features/Icons_home/controller/ReportController.dart';

class ReportDialog extends StatelessWidget {
  final String reportableType;
  final int reportableId;

  ReportDialog({
    Key? key,
    required this.reportableType,
    required this.reportableId,
  }) : super(key: key);

  final TextEditingController reasonController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final ReportController controller = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'تقديم بلاغ',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'الرجاء ذكر سبب الإبلاغ وتفاصيل بسيطة لنتمكن من المراجعة:',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: 'السبب (مثلاً: spam, inappropriate)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: detailsController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'التفاصيل',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
        ),
        Obx(
          () => ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryEnd,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: controller.isLoading.value
                ? null
                : () {
                    if (reasonController.text.trim().isEmpty) {
                      Get.snackbar('تنبیه', 'الرجاء إدخال السبب على الأقل');
                      return;
                    }
                    controller.submitReport(
                      reportableType: reportableType,
                      reportableId: reportableId,
                      reason: reasonController.text.trim(),
                      details: detailsController.text.trim(),
                    );
                  },
            child: controller.isLoading.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'إرسال البلاغ',
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ),
      ],
    );
  }
}
