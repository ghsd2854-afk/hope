import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/profiles/controller/public_profile_controller.dart';

class PublicProfileViewScreen extends StatelessWidget {
  PublicProfileViewScreen({super.key});

  final PublicProfileController controller =
      Get.find<PublicProfileController>();

  @override
  Widget build(BuildContext context) {
    final slug = Get.arguments as String;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadPublicProfileBySlug(slug);
    });

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
                controller.viewedProfile.value == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = controller.viewedProfile.value;
            if (data == null) {
              return const Center(child: Text("تعذر تحميل البروفايل"));
            }

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
                        "معاينة البروفايل العام",
                        style: TextStyle(
                            fontSize: 20,
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
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: const Color(0xFFEDE9FE),
                          backgroundImage: (data.user.photo != null &&
                                  data.user.photo!.isNotEmpty)
                              ? NetworkImage(
                                  "http://127.0.0.1:8000/storage/${data.user.photo}",
                                )
                              : null,
                          child: (data.user.photo == null ||
                                  data.user.photo!.isEmpty)
                              ? const Icon(Icons.person,
                                  size: 45, color: Color(0xFF7C3AED))
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          data.user.name ?? "بدون اسم",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        if (data.user.headline != null)
                          Text(data.user.headline!,
                              style:
                                  const TextStyle(color: Color(0xFF7C3AED))),
                        const SizedBox(height: 8),
                        if (data.user.summary != null)
                          Text(data.user.summary!,
                              textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                  if (data.experiences.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _sectionCard(
                      title: "الخبرات",
                      children: data.experiences
                          .map((e) => ListTile(
                                title: Text("${e.position} - ${e.company}"),
                                subtitle: Text(e.description ?? ""),
                              ))
                          .toList(),
                    ),
                  ],
                  if (data.educations.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _sectionCard(
                      title: "التعليم",
                      children: data.educations
                          .map((e) => ListTile(
                                title: Text(e.institution),
                                subtitle: Text(e.degree ?? ""),
                              ))
                          .toList(),
                    ),
                  ],
                  if (data.skills.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _sectionCard(
                      title: "المهارات",
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: data.skills
                              .map((s) => Chip(
                                    label: Text(s.name),
                                    backgroundColor:
                                        const Color(0xFFEDE9FE),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ],
                  if (data.projects.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _sectionCard(
                      title: "المشاريع",
                      children: data.projects
                          .map((p) => ListTile(
                                title: Text(p.title),
                                subtitle: Text(p.description ?? ""),
                              ))
                          .toList(),
                    ),
                  ],
                  if (data.certifications.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _sectionCard(
                      title: "الشهادات",
                      children: data.certifications
                          .map((c) => ListTile(
                                title: Text(c.name),
                                subtitle: Text(c.issuer ?? ""),
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _sectionCard(
      {required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12, blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...children,
        ],
      ),
    );
  }
}