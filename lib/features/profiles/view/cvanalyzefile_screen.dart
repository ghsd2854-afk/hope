// lib/features/profiles/screen/cvanalyzefile_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cvanalyzefile_controller.dart';

class CvAnalyzeFileScreen extends StatelessWidget {
  CvAnalyzeFileScreen({super.key});

  final CvAnalyzeFileController controller = Get.put(CvAnalyzeFileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تحليل CV من ملف")),
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
              if (controller.analysisResult.value != null) {
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
            "تحليل السيرة الذاتية",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // ── طريقة التحليل (خارج صندوق رفع الملف) ──────────
          const Text(
            "طريقة التحليل",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Obx(() => Row(
                children: [
                  Expanded(
                    child: _sourceOption(label: "من الملف فقط", value: "file"),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _sourceOption(
                        label: "دمج البروفايل + الملف", value: "merge"),
                  ),
                ],
              )),

          const SizedBox(height: 20),

          // ── صندوق رفع الملف ────────────────────────────
          GestureDetector(
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
                  const Icon(Icons.upload_file, size: 45, color: Color(0xFF7C3AED)),
                  const SizedBox(height: 10),
                  Obx(() => Text(
                        controller.pickedFileName.value.isEmpty
                            ? "اضغطي لاختيار ملف الـ CV"
                            : controller.pickedFileName.value,
                        textAlign: TextAlign.center,
                      )),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: controller.jobTitleController,
            decoration: InputDecoration(
              labelText: "المسمى الوظيفي المستهدف",
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
              labelText: "وصف الوظيفة",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
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
                  onTap: controller.analyze,
                  child: const Center(
                    child: Text(
                      "تحليل الآن",
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

  Widget _resultView() {
    final result = controller.analysisResult.value!;
    final analysis = result.analysis;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "نتيجة التحليل",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              _scoreCircle("ATS", analysis.atsScore),
              const SizedBox(width: 12),
              _scoreCircle("Match", analysis.matchScore),
              const SizedBox(width: 12),
              _scoreCircle("Overall", analysis.finalScore.round()),
            ],
          ),

          const SizedBox(height: 20),

          _infoRow("مستوى الخبرة", analysis.seniorityLevel),
          _infoRow("ملاءمة السوق", analysis.marketFit),
          _infoRow("سنوات الخبرة", "${analysis.totalExperienceYears}"),

          const SizedBox(height: 15),
          _listCard("نقاط القوة", analysis.strengths, Colors.green),
          _listCard("نقاط الضعف", analysis.weaknesses, Colors.red),
          _listCard("التحسينات المقترحة", analysis.improvements, Colors.blue),

          const SizedBox(height: 20),
          Center(
            child: TextButton(
              onPressed: controller.clearAll,
              child: const Text("تحليل ملف جديد"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scoreCircle(String label, int value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE9D5FF)),
        ),
        child: Column(
          children: [
            Text(
              "$value%",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7C3AED),
              ),
            ),
            const SizedBox(height: 5),
            Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
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