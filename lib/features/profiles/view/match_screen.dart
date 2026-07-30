// lib/features/profiles/screen/cvmatch_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/profiles/mpdel/match_model.dart';
import '../controller/cvmatch_controller.dart';

class MatchScreen extends StatelessWidget {
  MatchScreen({super.key});

  final MatchController controller = Get.put(MatchController());
  final TextEditingController jobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("مطابقة السيرة الذاتية")),
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
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7C3AED).withOpacity(.08),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "مطابقة السيرة الذاتية بالذكاء الاصطناعي",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: jobController,
                        maxLines: 8,
                        decoration: InputDecoration(
                          labelText: "وصف الوظيفة",
                          hintText: "الصقي وصف الوظيفة هنا...",
                          alignLabelWithHint: true,
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(bottom: 140),
                            child: Icon(Icons.work, color: Color(0xFF7C3AED)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF38BDF8), Color(0xFF9333EA)],
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () {
                              if (jobController.text.trim().isEmpty) {
                                Get.snackbar(
                                  "تنبيه",
                                  "الرجاء إدخال وصف الوظيفة",
                                );
                                return;
                              }

                              controller.match(
                                jobDescription: jobController.text.trim(),
                              );
                            },
                            child: const Center(
                              child: Text(
                                "مطابقة السيرة الذاتية",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final MatchModel? result = controller.matchResult.value;

                    if (result == null) {
                      return _emptyState();
                    }

                    return ListView(
                      children: [
                        _scoreCard(result.matchScore),
                        const SizedBox(height: 20),
                        _item("المهارات", result.skills, Icons.psychology),
                        _item("الخبرات", result.experience, Icons.work),
                        _item("التعليم", result.education, Icons.school),
                        _item("الأدوات", result.tools, Icons.build),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
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
            child: const Icon(Icons.leaderboard,
                size: 40, color: Color(0xFF7C3AED)),
          ),
          const SizedBox(height: 15),
          const Text(
            "لا توجد نتيجة مطابقة بعد",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 5),
          Text(
            "ألصقي وصف الوظيفة واضغطي مطابقة",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _scoreCard(int score) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withOpacity(.08),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "نسبة التطابق الإجمالية",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 130,
            height: 130,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 10,
                  backgroundColor: const Color(0xFFEDE9FE),
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF7C3AED)),
                ),
                Center(
                  child: Text(
                    "$score%",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(String title, int value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE9D5FF)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withOpacity(.06),
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
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                colors: [Color(0xFF38BDF8), Color(0xFF9333EA)],
              ),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            "$value%",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7C3AED),
            ),
          ),
        ],
      ),
    );
  }
}