// lib/screen/CvUploadScreen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/profiles/controller/cvenhancefile_controller.dart';
import 'package:hobe/features/profiles/controller/extractforfile_controller.dart';
import 'package:hobe/features/profiles/view/cvenhancefile_screen.dart';

class CvUploadScreen extends StatelessWidget {
  CvUploadScreen({super.key});

  final CvUploadController controller = Get.put(CvUploadController());
  final CvEnhanceFileController enhanceController =
      Get.put(CvEnhanceFileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("استخراج بيانات السيرة الذاتية")),
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
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Obx(() {
              if (!controller.hasExtracted.value) {
                return _uploadState();
              } else {
                return _reviewState();
              }
            }),
          ),
        ),
      ),
    );
  }

  Widget _uploadState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "رفع ملف PDF أو Word وسيتم استخراج بياناتك تلقائياً",
          style: TextStyle(color: Colors.grey.shade700),
        ),
        const SizedBox(height: 30),

        GestureDetector(
          onTap: controller.pickCvFile,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE9D5FF)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7C3AED).withOpacity(.08),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.upload_file, size: 50, color: Color(0xFF7C3AED)),
                const SizedBox(height: 15),
                Obx(() => Text(
                      controller.pickedFileName.value.isEmpty
                          ? "اضغطي لاختيار الملف (PDF, DOC, DOCX)"
                          : controller.pickedFileName.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    )),
              ],
            ),
          ),
        ),

        const SizedBox(height: 25),

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
                onTap: controller.uploadAndExtract,
                child: const Center(
                  child: Text(
                    "استخراج البيانات",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _reviewState() {
    final cv = controller.extractedCv.value!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "راجعي البيانات قبل الحفظ",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionCard("الاسم والعنوان", [cv.header.name, cv.header.title]),
                _sectionCard("الملخص", [cv.summary]),
                _sectionCard("المهارات", cv.skills.technical),
                _sectionCard(
                  "الخبرات",
                  cv.experience.map((e) => "${e.title} - ${e.company}").toList(),
                ),
                _sectionCard(
                  "التعليم",
                  cv.education.map((e) => "${e.degree} - ${e.institution}").toList(),
                ),
                _sectionCard("المشاريع", cv.projects.map((e) => e.title).toList()),
                _sectionCard(
                  "الشهادات",
                  cv.certifications.map((e) => e.name).toList(),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 15),

        // ── صف الأزرار الرئيسية ──────────────────────
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: controller.clearAll,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text("إعادة المحاولة"),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Container(
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
                    onTap: controller.confirmAndSave,
                    child: Obx(() {
                      if (controller.isSaving.value) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }
                      return const Center(
                        child: Text(
                          "حفظ البيانات",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ── زر التحسين المباشر (خارج الـ Row، بعرض كامل) ──
        Obx(() {
          if (enhanceController.isEnhancingPayload.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                enhanceController.enhanceDirect(
                  controller.extractedCv.value!.toJson(),
                  save: false,
                );
                Get.to(() => CvEnhanceFileScreen());
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 50),
                side: const BorderSide(color: Color(0xFF7C3AED)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.auto_fix_high, color: Color(0xFF7C3AED)),
              label: const Text(
                "تحسين مباشر بدون حفظ",
                style: TextStyle(color: Color(0xFF7C3AED)),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _sectionCard(String title, List<String> items) {
    if (items.isEmpty || items.every((e) => e.trim().isEmpty)) {
      return const SizedBox.shrink();
    }
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
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7C3AED)),
          ),
          const SizedBox(height: 8),
          ...items.where((e) => e.trim().isNotEmpty).map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text("• $e"),
                ),
              ),
        ],
      ),
    );
  }
}