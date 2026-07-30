import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/onboarding/onboarding_controller.dart';

import '../controller/education_controller.dart';
import '../mpdel/EducationModel.dart';

class EducationScreen extends StatelessWidget {
  final bool isOnboarding;
  EducationScreen({super.key, this.isOnboarding = false});

  final EducationController controller = Get.put(EducationController());

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
                    const Text("Your Education", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () {
                        controller.clearFields();
                        showEducationSheet();
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
                            Text("Add Education", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                    if (controller.educations.isEmpty) {
                      return const Center(child: Text("No Education Yet"));
                    }
                    return ListView.builder(
                      itemCount: controller.educations.length,
                      itemBuilder: (context, index) {
                        final education = controller.educations[index];
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
                                      gradient: const LinearGradient(colors: [Color(0xFF9F67FF), Color(0xFF7C3AED)]),
                                    ),
                                    child: const Icon(Icons.school, color: Colors.white),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(education.institution ?? "", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 4),
                                        Text(education.degree ?? "", style: TextStyle(color: Colors.grey.shade700)),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Color(0xFF7C3AED)),
                                    onPressed: () {
                                      controller.fillForEdit(education);
                                      showEducationSheet(education: education);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      Get.defaultDialog(
                                        title: "Delete",
                                        middleText: "Are you sure?",
                                        onConfirm: () async {
                                          Get.back();
                                          await controller.deleteEducation(education.id!);
                                        },
                                        textConfirm: "Delete",
                                        textCancel: "Cancel",
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Wrap(
                                  spacing: 8,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(10)),
                                      child: Text(education.fieldOfStudy ?? "", style: const TextStyle(color: Color(0xFF7C3AED))),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(10)),
                                      child: Text(education.degree ?? "", style: const TextStyle(color: Color(0xFF7C3AED))),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18),
                              Row(
                                children: [
                                  Expanded(child: Text("📅 ${education.startDate}")),
                                  Expanded(child: Text("📅 ${education.endDate}")),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("⭐ Grade: ${education.grade}"),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      if (isOnboarding) {
                        Get.find<OnboardingController>().onSubStepSaved();
                      } else {
                        Get.toNamed("/experiences");
                      }
                    },
                    child: const Text("Next"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showEducationSheet({EducationModel? education}) {
  final controller = Get.find<EducationController>();

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 70,
              height: 6,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(20)),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: const LinearGradient(colors: [Color(0xFFB794F4), Color(0xFF7C3AED)]),
                  ),
                  child: const Icon(Icons.school_outlined, color: Colors.white, size: 40),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(education == null ? "Add Education" : "Edit Education",
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(education == null ? "Fill in the details below" : "Update education details",
                        style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 35),
            TextField(
              controller: controller.institutionController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.account_balance, color: Color(0xFF7C3AED)),
                labelText: "Institution",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: controller.degreeController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.workspace_premium, color: Color(0xFF7C3AED)),
                labelText: "Degree",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: controller.fieldController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.menu_book, color: Color(0xFF7C3AED)),
                labelText: "Field Of Study",
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
              controller: controller.gradeController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.star_outline, color: Color(0xFF7C3AED)),
                labelText: "Grade",
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
                      gradient: const LinearGradient(colors: [Color(0xFFB794F4), Color(0xFF7C3AED)]),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () async {
                          if (!controller.validateEducation()) return;
                          if (education == null) {
                            await controller.createEducation();
                          } else {
                            await controller.updateEducation(education.id!);
                          }
                          Get.back();
                        },
                        child: Center(
                          child: Text(
                            education == null ? "Add Education" : "Update Education",
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