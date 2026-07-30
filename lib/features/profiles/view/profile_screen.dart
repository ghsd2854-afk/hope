import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hobe/features/onboarding/onboarding_controller.dart';
import 'package:hobe/features/profiles/controller/profile_controller.dart';
import 'package:hobe/features/auth/widgets/custum_input.dart';
import 'package:hobe/features/auth/widgets/gradient_button.dart';

class ProfileEditScreen extends StatelessWidget {
  /// isOnboarding = true  -> الشاشة مضمنة جوا فلو التسجيل الأول (Onboarding)
  /// isOnboarding = false -> الشاشة مفتوحة عادي من الإعدادات / البروفايل
  ///
  /// - جوا Onboarding: زر "التالي" الكبير هو المحرك الأساسي للفلو (ما بنشيله).
  /// - خارج Onboarding: ما في زر كبير للحفظ ولا "حذف" منفصل بالأسفل؛ بدالهم
  ///   أيقونتين صغار (تعديل/حذف) تحت صورة البروفايل مباشرة، وتحتهم كرت
  ///   "أقسام البروفايل" يوديك على باقي الشاشات (خبرات، مهارات، تعليم...).
  final bool isOnboarding;

  ProfileEditScreen({super.key, this.isOnboarding = false});

  final ProfileController controller = Get.put(ProfileController());

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
              Color(0xFFDCCBFF),
              Color(0xFFF8F7FF),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),

               

                _buildAvatarCard(),
                const SizedBox(height: 20),

                _buildPersonalInfoCard(),
                const SizedBox(height: 20),

                _buildLinksCard(),

                // جوا onboarding بس: زر "التالي" الكبير هو يلي بيحفظ وينقل خطوة
                if (isOnboarding) ...[
                  const SizedBox(height: 25),
                  _buildOnboardingNextButton(),
                ],

                // خارج onboarding: كرت التنقل لباقي أقسام البروفايل
                if (!isOnboarding) ...[
                  const SizedBox(height: 25),
                  _buildSectionsHub(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------- Header --------------------
  Widget _buildHeader() {
    return Row(
      children: [
        if (!isOnboarding)
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF7C3AED)),
          )
        else
          const SizedBox(width: 4),
        Expanded(
          child: Text(
            isOnboarding ? "حابب نعرفك أكتر" : "Edit Profile",
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6C4AB6),
            ),
          ),
        ),
      ],
    );
  }



  // -------------------- Avatar + اسم/هيدلاين + أيقونات تعديل/حذف صغيرة --------------------
  Widget _buildAvatarCard() {
    return _Card(
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Obx(() {
                    final File? localImage = controller.imageFile.value;
                    final String? networkImage = controller.profile.value?.profileImage;

                    ImageProvider? avatarImage;
                    if (localImage != null) {
                      avatarImage = FileImage(localImage);
                    } else if (networkImage != null && networkImage.trim().isNotEmpty) {
                      avatarImage = NetworkImage(networkImage);
                    }

                    return GestureDetector(
                      onTap: controller.pickImage,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [Color(0xFF9F67FF), Color(0xFF7C3AED)]),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: avatarImage,
                          child: avatarImage == null
                              ? const Icon(Icons.camera_alt, size: 32, color: Color(0xFF7C3AED))
                              : null,
                        ),
                      ),
                    );
                  }),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF7C3AED)),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.fullNameController.text.isEmpty ? "اسمك الكامل" : controller.fullNameController.text,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.headlineController.text.isEmpty ? "المسمى الوظيفي" : controller.headlineController.text,
                      style: const TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (controller.summaryController.text.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        controller.summaryController.text,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          // ⭐ أيقونات صغيرة (تعديل / حذف) تحت الصورة مباشرة — بس خارج onboarding
          if (!isOnboarding) ...[
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SmallIconAction(
                    icon: Icons.edit_outlined,
                    label: controller.profile.value == null ? "حفظ" : "تعديل",
                    color: const Color(0xFF7C3AED),
                    loading: controller.isLoading.value,
                    onTap: _saveProfile,
                  ),
                  const SizedBox(width: 22),
                  _SmallIconAction(
                    icon: Icons.delete_outline,
                    label: "حذف",
                    color: Colors.red,
                    onTap: () => _confirmDelete(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // -------------------- المعلومات الشخصية --------------------
  Widget _buildPersonalInfoCard() {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(icon: Icons.person_outline, title: "Personal Information"),
          const SizedBox(height: 16),
          CustomInput(hint: "Full Name", icon: Icons.person, controller: controller.fullNameController),
          const SizedBox(height: 10),
          CustomInput(hint: "Headline", icon: Icons.work, controller: controller.headlineController),
          const SizedBox(height: 10),
          CustomInput(hint: "Summary", icon: Icons.description, controller: controller.summaryController),
          const SizedBox(height: 10),
          CustomInput(hint: "Gender", icon: Icons.people, controller: controller.genderController),
          const SizedBox(height: 10),
          CustomInput(hint: "Phone", icon: Icons.phone, controller: controller.phoneController),
          const SizedBox(height: 10),
          CustomInput(hint: "Address", icon: Icons.location_on, controller: controller.addressController),
          const SizedBox(height: 10),
          CustomInput(hint: "Birth Date", icon: Icons.calendar_month, controller: controller.birthDateController),
          const SizedBox(height: 10),
          CustomInput(hint: "Country", icon: Icons.flag, controller: controller.countryController),
          const SizedBox(height: 10),
          CustomInput(hint: "City", icon: Icons.location_city, controller: controller.cityController),
        ],
      ),
    );
  }

  // -------------------- الروابط --------------------
  Widget _buildLinksCard() {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(icon: Icons.link, title: "Links"),
          const SizedBox(height: 16),
          CustomInput(hint: "LinkedIn", icon: Icons.link, controller: controller.linkedinController),
          const SizedBox(height: 10),
          CustomInput(hint: "GitHub", icon: Icons.code, controller: controller.githubController),
          const SizedBox(height: 10),
          CustomInput(hint: "Portfolio", icon: Icons.web, controller: controller.portfolioController),
        ],
      ),
    );
  }

  // -------------------- منطق الحفظ المشترك (بينادى من الأيقونة الصغيرة وزر onboarding) --------------------
  Future<void> _saveProfile() async {
    if (!controller.validateProfile()) return;

    if (controller.profile.value == null) {
      await controller.createProfile();
    } else {
      await controller.updateProfile();
    }

    if (controller.profile.value != null && isOnboarding) {
      if (Get.isRegistered<OnboardingController>()) {
        Get.find<OnboardingController>().onSubStepSaved();
      }
    } else if (controller.profile.value != null && !isOnboarding) {
      Get.snackbar("تم", "تم حفظ البروفايل بنجاح");
    }
  }

  void _confirmDelete() {
    Get.defaultDialog(
      title: "Delete Profile",
      middleText: "Are you sure?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      onConfirm: () async {
        Get.back();
        await controller.deleteProfile();
        controller.fullNameController.clear();
        controller.headlineController.clear();
        controller.summaryController.clear();
        controller.genderController.clear();
        controller.phoneController.clear();
        controller.addressController.clear();
        controller.birthDateController.clear();
        controller.countryController.clear();
        controller.cityController.clear();
        controller.linkedinController.clear();
        controller.githubController.clear();
        controller.portfolioController.clear();
      },
    );
  }

  // -------------------- زر "التالي" الكبير — onboarding بس --------------------
  Widget _buildOnboardingNextButton() {
    return Obx(
      () => GradientButton(
        text: "التالي",
        loading: controller.isLoading.value,
        onTap: _saveProfile,
      ),
    );
  }

  // -------------------- كرت التنقل لباقي أقسام البروفايل --------------------
  // ⚠️ تأكد إنه أسماء الـ routes هون مطابقة تماماً لأسماء الـ GetPage المسجلة
  // عندك بملف app_pages.dart (خصوصاً "/skills" — حطيتها افتراضياً، بدلها
  // إذا كان اسمها مختلف بمشروعك)
  Widget _buildSectionsHub() {
    final sections = [
      ("الخبرات العملية", Icons.business_center_outlined, "/experiences"),
      ("المشاريع", Icons.folder_special_outlined, "/projects"),
      ("المهارات", Icons.psychology_outlined, "/skills"),
      ("التدريب", Icons.school_outlined, "/training"),
      ("الشهادات", Icons.workspace_premium_outlined, "/certification"),
      ("التعليم", Icons.menu_book_outlined, "/education"),
      ("الاهتمامات", Icons.favorite_border, "/interests"),
      ("اقتراحات المهارات (AI)", Icons.auto_awesome, "/skillSuggestions"),
      ("السيرة الذاتية", Icons.description_outlined, "/cv-hub"),
    ];

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(icon: Icons.dashboard_outlined, title: "أقسام البروفايل"),
          const SizedBox(height: 10),
          ...sections.map(
            (s) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(s.$2, color: const Color(0xFF7C3AED)),
              title: Text(s.$1),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Get.toNamed(s.$3),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------- Widgets مساعدة --------------------

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF7C3AED)),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

/// أيقونة صغيرة + label تحتها (تعديل / حذف) — بديل الأزرار الكبيرة
class _SmallIconAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool loading;

  const _SmallIconAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: loading ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(.1),
                shape: BoxShape.circle,
              ),
              child: loading
                  ? Padding(
                      padding: const EdgeInsets.all(10),
                      child: CircularProgressIndicator(strokeWidth: 2, color: color),
                    )
                  : Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}