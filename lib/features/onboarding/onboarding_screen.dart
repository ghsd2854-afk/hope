import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/onboarding/onboarding_controller.dart';
import 'package:hobe/features/profiles/view/CertificationScreen.dart';
import 'package:hobe/features/profiles/view/InterestScreen.dart';
import 'package:hobe/features/profiles/view/ProjectsScreen.dart';
import 'package:hobe/features/profiles/view/SkillsScreen.dart';
import 'package:hobe/features/profiles/view/TrainingScreen.dart';
import 'package:hobe/features/profiles/view/cv_ai_screen.dart';
import 'package:hobe/features/profiles/view/education_screen.dart';
import 'package:hobe/features/profiles/view/experiences_screen.dart';
import 'package:hobe/features/profiles/view/profile_screen.dart';
import 'package:hobe/features/profiles/view/skill_suggestions-view.dart';

class OnboardingView extends StatelessWidget {
  OnboardingView({super.key});

  final OnboardingController controller = Get.put(OnboardingController());

  /// ⚠️ الترتيب هون لازم يطابق تماماً ترتيب stepGroups
  /// بملف onboarding_controller.dart:
  ///
  /// 1) profile      (1 شاشة)  -> index 0
  /// 2) experiences   (2 شاشة)  -> index 1..2
  /// 3) skills        (4 شاشات) -> index 3..6
  /// 4) education     (1 شاشة)  -> index 7
  /// 5) cv_file       (1 شاشة)  -> index 8
  /// 6) preferences   (1 شاشة)  -> index 9
  List<Widget> get _pages => [
        ProfileEditScreen(isOnboarding: true), // 0 - profile

        ExperienceScreen(isOnboarding: true), // 1 - experiences (1/2)
        ProjectsScreen(isOnboarding: true), // 2 - experiences (2/2)

        SkillsScreen(isOnboarding: true), // 3 - skills (1/4)
        TrainingScreen(isOnboarding: true), // 4 - skills (2/4)
        CertificationScreen(isOnboarding: true), // 5 - skills (3/4)
        SkillSuggestionScreen(isOnboarding: true), // 6 - skills (4/4)

        EducationScreen(isOnboarding: true), // 7 - education

        CvScreen(isOnboarding: true), // 8 - cv_file

        InterestScreen(isOnboarding: true), // 9 - preferences
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD7C2FF),
              Color(0xFFEDE6FF),
              Color(0xFFF8F7FF),
            ],
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value && controller.status.value == null) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF7C3AED)),
              );
            }

            return Column(
              children: [
                _buildTopBar(),
                _buildProgressBar(),
                Expanded(
                  child: PageView(
                    controller: controller.pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (i) => controller.currentPageIndex.value = i,
                    children: _pages,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => controller.currentPageIndex.value > 0
              ? IconButton(
                  onPressed: controller.goToPreviousStep,
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF6D3BB3)),
                )
              : const SizedBox(width: 48)),
          TextButton(
            onPressed: controller.skipOnboarding,
            child: const Text(
              "تخطي",
              style: TextStyle(color: Color(0xFF6D3BB3), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// شريط التقدّم بيعتمد على "المجموعة" (خطوة الـ API) مش على عدد الشاشات
  /// الفعلي، عشان المستخدم يشوف "خطوة 3 من 6" مش "8 من 10"
  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Obx(() {
        final total = controller.stepGroups.length;
        final current = controller.currentGroupIndex + 1;
        return Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: current / total,
                minHeight: 8,
                backgroundColor: Colors.white,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "الخطوة $current من $total",
              style: const TextStyle(color: Color(0xFF6D3BB3), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
          ],
        );
      }),
    );
  }
}