// lib/features/profiles/screen/enhance_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/enhance_controller.dart';

class EnhanceScreen extends StatefulWidget {
  const EnhanceScreen({super.key});

  @override
  State<EnhanceScreen> createState() => _EnhanceScreenState();
}

class _EnhanceScreenState extends State<EnhanceScreen> {
  final EnhanceController controller = Get.put(EnhanceController());

  @override
  void initState() {
    super.initState();
    controller.enhance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تحسين من البروفايل")),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFDCCBFF), Color(0xFFF8F7FF)],
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.enhancedCv.value == null) {
            return _emptyState();
          }

          final cv = controller.enhancedCv.value!.enhancedCv!;
          final header = cv["header"] ?? {};
          final skillsAll = List<String>.from(cv["skills"]?["all"] ?? []);
          final experience = List<dynamic>.from(cv["experience"] ?? []);
          final education = List<dynamic>.from(cv["education"] ?? []);

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── بطاقة الاسم والعنوان ──────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C3AED).withOpacity(.08),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF38BDF8), Color(0xFF9333EA)],
                            ),
                          ),
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                header["name"] ?? "",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                header["title"] ?? "",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  _sectionHeader("الملخص المهني"),
                  const SizedBox(height: 8),
                  Text(cv["summary"] ?? ""),

                  const SizedBox(height: 25),

                  _sectionHeader("المهارات"),
                  const SizedBox(height: 10),
                  if (skillsAll.isEmpty)
                    const Text("لا توجد مهارات مضافة")
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: skillsAll
                          .map((e) => Chip(
                                label: Text(e),
                                backgroundColor:
                                    const Color(0xFF7C3AED).withOpacity(.08),
                                labelStyle:
                                    const TextStyle(color: Color(0xFF7C3AED)),
                                side: BorderSide.none,
                              ))
                          .toList(),
                    ),

                  const SizedBox(height: 25),

                  _sectionHeader("الخبرات"),
                  const SizedBox(height: 10),
                  if (experience.isEmpty)
                    const Text("لا توجد خبرات مضافة")
                  else
                    ...experience.map((e) => _infoCard(
                          title: e["title"] ?? "",
                          subtitle: e["company"] ?? "",
                        )),

                  const SizedBox(height: 25),

                  _sectionHeader("التعليم"),
                  const SizedBox(height: 10),
                  if (education.isEmpty)
                    const Text("لا توجد بيانات تعليمية")
                  else
                    ...education.map((e) => _infoCard(
                          title: e["institution"] ?? "",
                          subtitle: e["degree"] ?? "",
                        )),

                  const SizedBox(height: 30),

                  // ── زر الحفظ ──────────────────────────
                Obx(() {
  final saved = controller.enhancedCv.value?.saved ?? false;

  if (saved) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Text("تم حفظ النسخة المحسّنة"),
        ],
      ),
    );
  }

  return SizedBox(
    width: double.infinity,
    height: 55,
    child: Container(
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
          onTap: () => controller.saveCv(),
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.save, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  "حفظ السيرة المحسّنة",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}),

                  const SizedBox(height: 12),

                  // ── زر توليد PDF ──────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton(
                      onPressed: () => Get.toNamed("/pdf"),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF7C3AED)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "توليد PDF",
                        style: TextStyle(
                          color: Color(0xFF7C3AED),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── زر الرجوع ─────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        "رجوع",
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF7C3AED),
      ),
    );
  }

  Widget _infoCard({required String title, required String subtitle}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9D5FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF7C3AED).withOpacity(.08),
            ),
            child: const Icon(Icons.auto_fix_high,
                size: 40, color: Color(0xFF7C3AED)),
          ),
          const SizedBox(height: 15),
          const Text(
            "لا يوجد سيرة ذاتية محسّنة",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}