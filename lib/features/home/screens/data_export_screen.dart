import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/home/controllers/data_export_controller.dart';


class DataExportScreen extends StatelessWidget {
  const DataExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<DataExportController>()
        ? Get.find<DataExportController>()
        : Get.put(DataExportController());

    return Scaffold(
      appBar: AppBar(title: const Text('تصدير بياناتي')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'يمكنك تصدير نسخة كاملة من بياناتك (الملف الشخصي، المهارات، '
              'الخبرات، الشهادات، المشاريع...) كملف JSON يمكنك حفظه.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: controller.isProcessing.value
                      ? null
                      : controller.exportMyData,
                  icon: controller.isProcessing.value
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.download),
                  label: Text(
                    controller.isProcessing.value
                        ? 'جاري التصدير...'
                        : 'تصدير بياناتي',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.statusMessage.value.isEmpty) {
                return const SizedBox.shrink();
              }
              return Text(
                controller.statusMessage.value,
                style: const TextStyle(fontSize: 13),
              );
            }),
            Obx(() {
              if (controller.savedFilePath.value.isEmpty) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'مسار الملف:\n${controller.savedFilePath.value}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
