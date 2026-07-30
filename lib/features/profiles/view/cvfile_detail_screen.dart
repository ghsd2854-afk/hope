// lib/features/profiles/screen/cvfile_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cvfile_detail_controller.dart';

class CvFileDetailScreen extends StatefulWidget {
  const CvFileDetailScreen({super.key});

  @override
  State<CvFileDetailScreen> createState() => _CvFileDetailScreenState();
}

class _CvFileDetailScreenState extends State<CvFileDetailScreen> {
  final CvFileDetailController controller = Get.put(CvFileDetailController());

  @override
  void initState() {
    super.initState();
    final int fileId = Get.arguments as int;
    controller.fetchDetails(fileId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تفاصيل الملف")),
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

          final file = controller.file.value;
          if (file == null) {
            return const Center(child: Text("لم يتم العثور على الملف"));
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.originalName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    file.createdAt,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const SizedBox(height: 15),

                  if (file.hasFile) _downloadButton(),

                  const SizedBox(height: 15),

                  if (file.hasImprovedVersion)
                    Row(
                      children: [
                        Expanded(
                          child: Obx(() => _tabButton(
                                "البيانات الأصلية",
                                0,
                                controller.selectedTab.value == 0,
                              )),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Obx(() => _tabButton(
                                "النسخة المحسّنة",
                                1,
                                controller.selectedTab.value == 1,
                              )),
                        ),
                      ],
                    ),

                  const SizedBox(height: 15),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Obx(() {
                        if (controller.selectedTab.value == 0 &&
                            file.extractedCv != null) {
                          return _extractedView(file.extractedCv!);
                        } else if (controller.selectedTab.value == 1 &&
                            file.improvedCv != null) {
                          return _improvedView(file.improvedCv!);
                        }
                        return const Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Center(child: Text("لا توجد بيانات لعرضها")),
                        );
                      }),
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

  Widget _downloadButton() {
    return Obx(() {
      if (controller.isDownloading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [Color(0xFF38BDF8), Color(0xFF9333EA)],
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                final file = controller.file.value!;
                controller.downloadOriginalFile(file.id, file.originalName);
              },
              child: const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.download, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "تحميل الملف الأصلي",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _tabButton(String title, int index, bool active) {
    return GestureDetector(
      onTap: () => controller.selectedTab.value = index,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF7C3AED) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF7C3AED)),
        ),
        child: Center(
          child: Text(
            title,
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

  Widget _extractedView(dynamic cv) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section("الاسم", cv.header.name),
        _section("العنوان الوظيفي", cv.header.title),
        _section("الملخص", cv.summary),
        _sectionList("المهارات التقنية", cv.skills.technical),
        _sectionList(
          "الخبرات",
          cv.experience
              .map((e) => "${e.title} - ${e.company}")
              .toList()
              .cast<String>(),
        ),
        _sectionList(
          "التعليم",
          cv.education
              .map((e) => "${e.degree} - ${e.institution}")
              .toList()
              .cast<String>(),
        ),
      ],
    );
  }

  Widget _improvedView(Map<String, dynamic> cv) {
    final header = cv['header'] ?? {};
    final skills = cv['skills'] ?? {};
    final experience = (cv['experience'] as List<dynamic>? ?? []);
    final education = (cv['education'] as List<dynamic>? ?? []);
    final changes = (cv['_changes'] as List<dynamic>? ?? []);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section("الاسم", header['name'] ?? ""),
        _section("العنوان الوظيفي", header['title'] ?? ""),
        _section("الملخص", cv['summary'] ?? ""),
        _sectionList("كل المهارات", List<String>.from(skills['all'] ?? [])),
        _sectionList(
          "الخبرات",
          experience
              .map((e) => "${e['title']} - ${e['company']}")
              .toList()
              .cast<String>(),
        ),
        _sectionList(
          "التعليم",
          education
              .map((e) => "${e['degree']} - ${e['institution']}")
              .toList()
              .cast<String>(),
        ),
        if (changes.isNotEmpty)
          _sectionList("التحسينات المطبّقة", changes.cast<String>()),
      ],
    );
  }

  Widget _section(String title, String value) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF7C3AED))),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }

  Widget _sectionList(String title, List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF7C3AED))),
          const SizedBox(height: 4),
          ...items.map((e) => Text("• $e")),
        ],
      ),
    );
  }
}