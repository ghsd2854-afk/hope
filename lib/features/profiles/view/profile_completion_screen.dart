import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/profiles/controller/public_profile_controller.dart';

class ProfileCompletionScreen extends StatelessWidget {
  ProfileCompletionScreen({super.key});

  final PublicProfileController controller =
      Get.put(PublicProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Obx(() {
            if (controller.isLoading.value &&
                controller.completion.value == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = controller.completion.value;
            if (data == null) {
              return const Center(child: Text("تعذر تحميل نسبة الاكتمال"));
            }

            return RefreshIndicator(
              onRefresh: controller.recalculate,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: Color(0xFF7C3AED)),
                        ),
                        const Text(
                          "اكتمال البروفايل",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6C4AB6)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 12,
                              offset: Offset(0, 4)),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 140,
                            height: 140,
                            child: CircularProgressIndicator(
                              value: data.percentage / 100,
                              strokeWidth: 12,
                              backgroundColor: const Color(0xFFEDE9FE),
                              valueColor: const AlwaysStoppedAnimation(
                                  Color(0xFF8B5CF6)),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${data.percentage}%",
                                style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF7C3AED)),
                              ),
                              Text(data.levelLabel,
                                  style:
                                      const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 12,
                              offset: Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("تفاصيل الأقسام",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 15),
                          ...data.sections.entries.map((entry) {
                            final section = entry.value;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    section.completed
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color: section.completed
                                        ? const Color(0xFF22C55E)
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(child: Text(section.label)),
                                  Text(
                                    "${section.points}/${section.weight}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF7C3AED)),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    if (data.recommendations.isNotEmpty) ...[
                      const SizedBox(height: 25),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 12,
                                offset: Offset(0, 4)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("مقترحات لإكمال البروفايل",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 15),
                            ...data.recommendations.map((rec) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.lightbulb_outline,
                                          color: Color(0xFFF59E0B)),
                                      const SizedBox(width: 10),
                                      Expanded(child: Text(rec.message)),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}