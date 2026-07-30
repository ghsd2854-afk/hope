// lib/features/profiles/screen/cv_ai_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/onboarding/onboarding_controller.dart';
import 'package:hobe/features/profiles/controller/cv_ai_controller.dart';
import 'package:hobe/features/profiles/mpdel/cv_ai_model.dart';

class CvScreen extends StatelessWidget {
  final bool isOnboarding;
  CvScreen({super.key, this.isOnboarding = false});

  final CvController controller = Get.put(CvController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // جوا onboarding ما في داعي لسهم رجوع بالـ AppBar (ما في route لل pop-عليه،
      // الرجوع بيصير من OnboardingController)
      appBar: AppBar(
        title: const Text("معاينة السيرة الذاتية"),
        automaticallyImplyLeading: !isOnboarding,
      ),
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

          if (controller.cvData.value == null) {
            return _emptyState();
          }

          final CvFullModel cv = CvFullModel.fromJson(controller.cvData.value!);

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _headerCard(cv.header),
                  const SizedBox(height: 22),

                  if (cv.summary.trim().isNotEmpty) ...[
                    _sectionTitle("الملخص المهني", Icons.description_outlined),
                    const SizedBox(height: 10),
                    _plainCard(Text(cv.summary, style: const TextStyle(height: 1.5))),
                    const SizedBox(height: 22),
                  ],

                  _sectionTitle("المهارات", Icons.psychology_outlined),
                  const SizedBox(height: 10),
                  _skillsCard(cv.skills),
                  const SizedBox(height: 22),

                  if (cv.experience.isNotEmpty) ...[
                    _sectionTitle("الخبرات العملية", Icons.work_outline),
                    const SizedBox(height: 10),
                    ...cv.experience.map((e) => _experienceCard(e)),
                    const SizedBox(height: 12),
                  ],

                  if (cv.education.isNotEmpty) ...[
                    _sectionTitle("التعليم", Icons.school_outlined),
                    const SizedBox(height: 10),
                    ...cv.education.map((e) => _educationCard(e)),
                    const SizedBox(height: 12),
                  ],

                  if (cv.projects.isNotEmpty) ...[
                    _sectionTitle("المشاريع", Icons.folder_special_outlined),
                    const SizedBox(height: 10),
                    ...cv.projects.map((e) => _projectCard(e)),
                    const SizedBox(height: 12),
                  ],

                  if (cv.certifications.isNotEmpty) ...[
                    _sectionTitle("الشهادات", Icons.workspace_premium_outlined),
                    const SizedBox(height: 10),
                    ...cv.certifications.map((e) => _certificationCard(e)),
                    const SizedBox(height: 12),
                  ],

                  if (cv.trainings.isNotEmpty) ...[
                    _sectionTitle("الدورات التدريبية", Icons.menu_book_outlined),
                    const SizedBox(height: 10),
                    ...cv.trainings.map((e) => _trainingCard(e)),
                    const SizedBox(height: 12),
                  ],

                  if (cv.interests.isNotEmpty) ...[
                    _sectionTitle("الاهتمامات", Icons.favorite_border),
                    const SizedBox(height: 10),
                    _interestsCard(cv.interests),
                    const SizedBox(height: 12),
                  ],

                  const SizedBox(height: 15),

                  // ⭐ خارج onboarding: نفس الزر الأصلي للرجوع للوحة السيرة الذاتية
                  if (!isOnboarding)
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: OutlinedButton(
                        onPressed: () => Get.toNamed("/cv-hub"),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF7C3AED)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text(
                          "العودة للوحة السيرة الذاتية",
                          style: TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                  // ⭐ جوا onboarding: زر "التالي" يكمل خطوة cv_file وينقل لآخر خطوة (preferences)
                  if (isOnboarding)
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(colors: [Color(0xFF38BDF8), Color(0xFF9333EA)]),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => Get.find<OnboardingController>().onSubStepSaved(),
                            child: const Center(
                              child: Text(
                                "التالي",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
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

  // ══════════════════ بطاقة الهيدر ══════════════════
  Widget _headerCard(CvHeaderInfo header) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF38BDF8), Color(0xFF9333EA)],
        ),
        boxShadow: [
          BoxShadow(color: const Color(0xFF7C3AED).withOpacity(.25), blurRadius: 18, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(.2),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(header.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    if (header.title.trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(header.title, style: TextStyle(color: Colors.white.withOpacity(.9), fontSize: 14)),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 14,
            runSpacing: 8,
            children: [
              if (header.email.isNotEmpty) _contactChip(Icons.email_outlined, header.email),
              if (header.phone.isNotEmpty) _contactChip(Icons.phone_outlined, header.phone),
              if (header.location.isNotEmpty) _contactChip(Icons.location_on_outlined, header.location),
              if (header.linkedin.isNotEmpty) _contactChip(Icons.link, "LinkedIn"),
              if (header.github.isNotEmpty) _contactChip(Icons.code, "GitHub"),
              if (header.portfolio.isNotEmpty) _contactChip(Icons.language, "Portfolio"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _contactChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 14),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF7C3AED), size: 20),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED))),
      ],
    );
  }

  Widget _plainCard(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: const Color(0xFF7C3AED).withOpacity(.06), blurRadius: 10)],
      ),
      child: child,
    );
  }

  Widget _skillsCard(CvSkillsInfo skills) {
    final all = {...skills.all, ...skills.technical, ...skills.tools, ...skills.languages, ...skills.softSkills}.toList();
    if (all.isEmpty) {
      return _plainCard(Text("لا توجد مهارات مضافة", style: TextStyle(color: Colors.grey.shade600)));
    }
    return _plainCard(
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: all
            .map((e) => Chip(
                  label: Text(e),
                  backgroundColor: const Color(0xFF7C3AED).withOpacity(.08),
                  labelStyle: const TextStyle(color: Color(0xFF7C3AED), fontSize: 13),
                  side: BorderSide.none,
                ))
            .toList(),
      ),
    );
  }

  Widget _experienceCard(CvExperienceInfo e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9D5FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 2),
                    Text(e.company, style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ),
              Text("${e.startDate} - ${e.current ? "الآن" : e.endDate}", style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            ],
          ),
          if (e.highlights.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...e.highlights.map((h) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Text("• $h", style: const TextStyle(height: 1.4)))),
          ],
          if (e.technologies.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: e.technologies
                  .map((t) => Chip(
                        label: Text(t, style: const TextStyle(fontSize: 11)),
                        backgroundColor: const Color(0xFFEDE9FE),
                        side: BorderSide.none,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _educationCard(CvEducationInfo e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9D5FF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.degree, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                if (e.fieldOfStudy.trim().isNotEmpty) Text(e.fieldOfStudy, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                const SizedBox(height: 2),
                Text(e.institution, style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("${e.startDate} - ${e.endDate}", style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              if (e.grade != null) ...[
                const SizedBox(height: 4),
                Text("التقدير: ${e.grade}", style: const TextStyle(fontSize: 12, color: Color(0xFF7C3AED), fontWeight: FontWeight.bold)),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _projectCard(CvProjectInfo e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9D5FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(e.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          if (e.description.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(e.description, style: TextStyle(color: Colors.grey.shade700, height: 1.4)),
          ],
          if (e.technologies.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: e.technologies
                  .map((t) => Chip(
                        label: Text(t, style: const TextStyle(fontSize: 11)),
                        backgroundColor: const Color(0xFFEDE9FE),
                        side: BorderSide.none,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _certificationCard(CvCertificationInfo e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9D5FF)),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(colors: [Color(0xFF38BDF8), Color(0xFF9333EA)]),
            ),
            child: const Icon(Icons.workspace_premium, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(e.issuer, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                if (e.issuedAt.isNotEmpty || e.expiresAt.isNotEmpty)
                  Text("${e.issuedAt} - ${e.expiresAt}", style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _trainingCard(CvTrainingInfo e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9D5FF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(e.provider, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: e.isCompleted ? Colors.green.shade50 : Colors.orange.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              e.isCompleted ? "مكتملة" : "جارية",
              style: TextStyle(fontSize: 11, color: e.isCompleted ? Colors.green.shade800 : Colors.orange.shade800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _interestsCard(List<CvInterestInfo> interests) {
    return _plainCard(
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: interests
            .map((e) => Chip(
                  avatar: const Icon(Icons.favorite, size: 14, color: Color(0xFF7C3AED)),
                  label: Text(e.name),
                  backgroundColor: const Color(0xFF7C3AED).withOpacity(.08),
                  labelStyle: const TextStyle(color: Color(0xFF7C3AED), fontSize: 13),
                  side: BorderSide.none,
                ))
            .toList(),
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
            decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF7C3AED).withOpacity(.08)),
            child: const Icon(Icons.auto_awesome, size: 40, color: Color(0xFF7C3AED)),
          ),
          const SizedBox(height: 15),
          const Text("لم يتم توليد سيرة ذاتية بعد", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 20),
          SizedBox(
            width: 220,
            height: 52,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(colors: [Color(0xFF38BDF8), Color(0xFF9333EA)]),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => Get.find<CvController>().generateCv(),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text("توليد السيرة الذاتية", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}