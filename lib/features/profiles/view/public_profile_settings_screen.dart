import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/profiles/controller/public_profile_controller.dart';
import 'package:hobe/features/auth/widgets/custum_input.dart';
import 'package:hobe/features/auth/widgets/gradient_button.dart';

class PublicProfileSettingsScreen extends StatelessWidget {
  PublicProfileSettingsScreen({super.key});

  final PublicProfileController controller =
      Get.put(PublicProfileController());

  Widget _sectionSwitch(
      String label, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(label),
      value: value,
      activeColor: const Color(0xFF7C3AED),
      onChanged: onChanged,
    );
  }

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
            final data = controller.publicProfile.value;

            if (controller.isLoading.value && data == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (data == null) {
              return const Center(child: Text("تعذر تحميل الإعدادات"));
            }

            final sections = data.visibleSections;

            return SingleChildScrollView(
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
                        "إعدادات البروفايل العام",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6C4AB6)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
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
                        const Text("رابط بروفايلك العام",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        CustomInput(
                          hint: "الرابط المختصر (slug)",
                          icon: Icons.link,
                          controller: controller.slugController,
                        ),
                        const SizedBox(height: 10),
                        Obx(() => GradientButton(
                              text: "تغيير الرابط",
                              loading: controller.isChangingSlug.value,
                              onTap: controller.changeSlug,
                            )),
                        const SizedBox(height: 10),
                        TextButton.icon(
                          onPressed: () => Get.toNamed(
                            "/public-profile-preview",
                            arguments: data.slug,
                          ),
                          icon: const Icon(Icons.remove_red_eye,
                              color: Color(0xFF7C3AED)),
                          label: const Text("معاينة البروفايل العام",
                              style: TextStyle(color: Color(0xFF7C3AED))),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
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
                    child: _sectionSwitch(
                      "البروفايل العام مفعّل",
                      data.isPublic,
                      controller.toggleIsPublic,
                    ),
                  ),
                  const SizedBox(height: 20),
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
                        const Text("الأقسام الظاهرة للزوار",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        _sectionSwitch(
                            "معلومات التواصل",
                            sections.contactInfo,
                            (v) => controller.toggleSection(
                                "contact_info", v)),
                        _sectionSwitch(
                            "الخبرات",
                            sections.experience,
                            (v) =>
                                controller.toggleSection("experience", v)),
                        _sectionSwitch(
                            "التعليم",
                            sections.education,
                            (v) =>
                                controller.toggleSection("education", v)),
                        _sectionSwitch(
                            "المهارات",
                            sections.skills,
                            (v) => controller.toggleSection("skills", v)),
                        _sectionSwitch(
                            "المشاريع",
                            sections.projects,
                            (v) =>
                                controller.toggleSection("projects", v)),
                        _sectionSwitch(
                            "الشهادات",
                            sections.certifications,
                            (v) => controller.toggleSection(
                                "certifications", v)),
                        _sectionSwitch(
                            "التقييمات",
                            sections.reviews,
                            (v) => controller.toggleSection("reviews", v)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
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
                        const Text("عنوان ووصف البروفايل",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 15),
                        CustomInput(
                          hint: "العنوان (Meta Title)",
                          icon: Icons.title,
                          controller: controller.metaTitleController,
                        ),
                        const SizedBox(height: 10),
                        CustomInput(
                          hint: "الوصف (Meta Description)",
                          icon: Icons.description,
                          controller: controller.metaDescriptionController,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Obx(() => GradientButton(
                        text: "حفظ الإعدادات",
                        loading: controller.isSaving.value,
                        onTap: controller.savePublicSettings,
                      )),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}