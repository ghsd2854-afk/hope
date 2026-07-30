// lib/features/profiles/screen/cv_hub_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CvHubScreen extends StatelessWidget {
  CvHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("السيرة الذاتية")),
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
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                "إنشاء وإدارة السيرة الذاتية",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                "كل أدوات السيرة الذاتية بمكان واحد",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 25),

              _sectionTitle("إنشاء السيرة الذاتية"),
              const SizedBox(height: 12),

              _hubCard(
                icon: Icons.picture_as_pdf,
                title: "توليد CV من البروفايل",
                subtitle: "إنشاء PDF جاهز من بياناتك الحالية",
                onTap: () => Get.toNamed('/pdf'),
              ),

              _hubCard(
                icon: Icons.upload_file,
                title: "استخراج بيانات من ملف",
                subtitle: "رفع CV جاهز (PDF/Word) واستخراج بياناته",
                onTap: () => Get.toNamed("/cv-upload"),
              ),

              const SizedBox(height: 28),
              _sectionTitle("التحليل والمطابقة"),
              const SizedBox(height: 12),

              _hubCard(
                icon: Icons.analytics,
                title: "تحليل من البروفايل",
                subtitle: "تحليل تلقائي بمساعدة الذكاء الاصطناعي",
                onTap: () => Get.toNamed("/analyze"),
              ),

              _hubCard(
                icon: Icons.description_outlined,
                title: "تحليل CV من ملف",
                subtitle: "رفع ملف CV مع وصف وظيفة لتحليل التوافق",
                onTap: () => Get.toNamed("/cv-analyze-file"),
              ),

              _hubCard(
                icon: Icons.leaderboard,
                title: "مطابقة CV مع وظيفة",
                subtitle: "مدى توافق سيرتك الذاتية مع وصف وظيفي",
                onTap: () => Get.toNamed("/match"),
              ),

              const SizedBox(height: 28),
              _sectionTitle("تحسين السيرة الذاتية"),
              const SizedBox(height: 12),

              _hubCard(
                icon: Icons.auto_fix_high,
                title: "تحسين من البروفايل",
                subtitle: "تحسين تلقائي لبيانات بروفايلك الحالية",
                onTap: () => Get.toNamed("/enhance"),
              ),

              _hubCard(
                icon: Icons.auto_awesome,
                title: "تحسين من ملف",
                subtitle: "رفع ملف أو اختيار ملف محفوظ وتحسينه تلقائياً",
                onTap: () => Get.toNamed("/cv-enhance-file"),
              ),

              const SizedBox(height: 28),
              _sectionTitle("الإدارة"),
              const SizedBox(height: 12),

              _hubCard(
                icon: Icons.folder_open,
                title: "قائمة ملفاتك",
                subtitle: "عرض كل الملفات المرفوعة والمولّدة سابقاً",
                onTap: () => Get.toNamed("/cv-files"),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFF7C3AED),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7C3AED),
          ),
        ),
      ],
    );
  }

  Widget _hubCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF38BDF8), Color(0xFF9333EA)],
                    ),
                  ),
                  child: Icon(icon, color: Colors.white),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_left, color: Color(0xFF7C3AED)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}