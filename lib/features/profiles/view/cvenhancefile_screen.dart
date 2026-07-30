// lib/features/profiles/screen/cvenhancefile_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cvenhancefile_controller.dart';

class CvEnhanceFileScreen extends StatelessWidget {
  CvEnhanceFileScreen({super.key});

  final CvEnhanceFileController controller =
      Get.put(CvEnhanceFileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تحسين من ملف")),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFDCCBFF), Color(0xFFF8F7FF)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Obx(() {
              if (controller.enhanceResult.value != null) {
                return _resultView();
              }
              return _formView();
            }),
          ),
        ),
      ),
    );
  }

  Widget _formView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "تحسين السيرة الذاتية من ملف",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // ── مصدر الملف ────────────────────────────
          const Text("مصدر الملف", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          Obx(() => Row(
                children: [
                  Expanded(
                    child: _sourceOption(label: "رفع ملف جديد", value: "file"),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _sourceOption(
                        label: "من ملف محفوظ", value: "saved_file"),
                  ),
                ],
              )),

          const SizedBox(height: 20),

          // ── محتوى المصدر (رفع جديد أو اختيار محفوظ) ──
          Obx(() {
            if (controller.selectedSource.value == "file") {
              return GestureDetector(
                onTap: controller.pickCvFile,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE9D5FF)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.upload_file,
                          size: 45, color: Color(0xFF7C3AED)),
                      const SizedBox(height: 10),
                      Text(
                        controller.pickedFileName.value.isEmpty
                            ? "اضغطي لاختيار ملف الـ CV"
                            : controller.pickedFileName.value,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return _savedFilePicker();
            }
          }),

          const SizedBox(height: 20),

          TextField(
            controller: controller.jobTitleController,
            decoration: InputDecoration(
              labelText: "المسمى الوظيفي المستهدف (اختياري)",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: controller.companyController,
            decoration: InputDecoration(
              labelText: "الشركة (اختياري)",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: controller.jobDescriptionController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: "وصف الوظيفة (اختياري)",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),

          const SizedBox(height: 15),

          Obx(() => SwitchListTile(
                value: controller.saveEnabled.value,
                onChanged: (v) => controller.saveEnabled.value = v,
                title: const Text("حفظ النسخة المحسّنة تلقائياً"),
                activeColor: const Color(0xFF7C3AED),
              )),

          const SizedBox(height: 15),

          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF38BDF8), Color(0xFF9333EA)],
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: controller.enhance,
                  child: const Center(
                    child: Text(
                      "تحسين الآن",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _sourceOption({required String label, required String value}) {
    final bool active = controller.selectedSource.value == value;
    return GestureDetector(
      onTap: () => controller.selectedSource.value = value,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF7C3AED) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF7C3AED)),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? Colors.white : const Color(0xFF7C3AED),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _savedFilePicker() {
    return Obx(() {
      if (controller.isLoadingFiles.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.savedFiles.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE9D5FF)),
          ),
          child: const Center(child: Text("لا يوجد ملفات محفوظة")),
        );
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE9D5FF)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            isExpanded: true,
            hint: const Text("اختاري ملفاً محفوظاً"),
            value: controller.selectedFileRecordId.value,
            items: controller.savedFiles.map((file) {
              return DropdownMenuItem<int>(
                value: file.id,
                child: Row(
                  children: [
                    Icon(
                      file.isPdf ? Icons.picture_as_pdf : Icons.description,
                      color: const Color(0xFF7C3AED),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        file.originalName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              controller.selectedFileRecordId.value = value;
            },
          ),
        ),
      );
    });
  }

  Widget _resultView() {
    final result = controller.enhanceResult.value!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "نتيجة التحسين",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),

          if (result.saved)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 8),
                  const Text("تم حفظ النسخة المحسّنة بنجاح"),
                ],
              ),
            ),

          _listCard("التحسينات المطبّقة", result.changes, const Color(0xFF7C3AED)),
          _listCard(
            "مهارات مقترحة للتعلّم",
            result.suggestedSkillsToLearn,
            Colors.blue,
          ),

          const SizedBox(height: 20),
          Center(
            child: TextButton(
              onPressed: controller.clearAll,
              child: const Text("تحسين ملف جديد"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listCard(String title, List<String> items, Color color) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9D5FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 8),
          ...items.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text("• $e"),
              )),
        ],
      ),
    );
  }
}