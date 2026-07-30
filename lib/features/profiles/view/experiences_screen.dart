import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/onboarding/onboarding_controller.dart';
import 'package:hobe/features/profiles/mpdel/experience_model.dart';

import '../controller/experience_controller.dart';

class ExperienceScreen extends StatelessWidget {
  final bool isOnboarding;
  ExperienceScreen({super.key, this.isOnboarding = false});

  final ExperienceController controller = Get.put(ExperienceController());

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
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
               

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Your Experience", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () {
                        controller.clearFields();
                        _showExperienceSheet();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: const LinearGradient(colors: [Color(0xFF38BDF8), Color(0xFF9333EA)]),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.add, color: Colors.white),
                            SizedBox(width: 8),
                            Text("Add Experience", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.experiences.isEmpty) {
                      return const Center(child: Text("No Experience Yet"));
                    }
                    return ListView.builder(
                      itemCount: controller.experiences.length,
                      itemBuilder: (context, index) => _experienceCard(controller.experiences[index]),
                    );
                  }),
                ),

                Container(
                  width: double.infinity,
                  height: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(colors: [Color(0xFF38BDF8), Color(0xFF9333EA)]),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        if (isOnboarding) {
                          Get.find<OnboardingController>().onSubStepSaved();
                        } else {
                          Get.toNamed("/projects");
                        }
                      },
                      child: const Center(
                        child: Text("Next", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _experienceCard(ExperienceModel experience) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE9D5FF)),
        boxShadow: [BoxShadow(color: const Color(0xFF7C3AED).withOpacity(.08), blurRadius: 12)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(colors: [Color(0xFF38BDF8), Color(0xFF9333EA)]),
                ),
                child: const Icon(Icons.business, color: Colors.white),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(experience.company ?? "", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(experience.position ?? "", style: const TextStyle(color: Color(0xFF0EA5E9), fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Color(0xFF7C3AED)),
                onPressed: () {
                  controller.fillForEdit(experience);
                  _showExperienceSheet(experience: experience);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  Get.defaultDialog(
                    title: "Delete",
                    middleText: "Are you sure?",
                    textConfirm: "Delete",
                    textCancel: "Cancel",
                    onConfirm: () async {
                      Get.back();
                      await controller.deleteExperience(experience.id!);
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: experience.technologiesUsed
                      ?.map((e) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(10)),
                            child: Text(e, style: const TextStyle(color: Color(0xFF7C3AED))),
                          ))
                      .toList() ??
                  [],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: Text("📅 ${experience.startDate}")),
              Expanded(child: Text(experience.isCurrent == true ? "Present" : "📅 ${experience.endDate}")),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(experience.description ?? "", style: TextStyle(color: Colors.grey.shade700)),
          ),
        ],
      ),
    );
  }

  void _showExperienceSheet({ExperienceModel? experience}) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 70,
                  height: 5,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(20)),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(colors: [Color(0xFF38BDF8), Color(0xFF9333EA)]),
                    ),
                    child: const Icon(Icons.business_center, color: Colors.white, size: 38),
                  ),
                  const SizedBox(width: 18),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(experience == null ? "Add Experience" : "Edit Experience",
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(experience == null ? "Fill in the details below" : "Update experience details",
                          style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              TextField(
                controller: controller.companyController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.business, color: Color(0xFF7C3AED)),
                  labelText: "Company",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: controller.positionController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.work, color: Color(0xFF7C3AED)),
                  labelText: "Position",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: controller.startDateController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_month, color: Color(0xFF7C3AED)),
                  labelText: "Start Date",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: controller.endDateController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.event, color: Color(0xFF7C3AED)),
                  labelText: "End Date",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: controller.currentController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.check_circle_outline, color: Color(0xFF7C3AED)),
                  labelText: "Current (1 / 0)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: controller.descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.description, color: Color(0xFF7C3AED)),
                  labelText: "Description",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: controller.technologiesController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.code, color: Color(0xFF7C3AED)),
                  labelText: "Technologies",
                  hintText: "PHP,Laravel,Flutter",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 55),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text("Cancel", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(colors: [Color(0xFF38BDF8), Color(0xFF9333EA)]),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () async {
                            if (!controller.validateExperience()) return;
                            if (experience == null) {
                              await controller.createExperience();
                            } else {
                              await controller.updateExperience(experience.id!);
                            }
                            Get.back();
                          },
                          child: Center(
                            child: Text(
                              experience == null ? "Add Experience" : "Update Experience",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}