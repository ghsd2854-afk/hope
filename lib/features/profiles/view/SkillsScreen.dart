import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/auth/widgets/gradient_button.dart';
import 'package:hobe/features/onboarding/onboarding_controller.dart';
import 'package:hobe/features/profiles/controller/skill_controller.dart';
import 'package:hobe/features/profiles/mpdel/skill_model.dart';

class SkillsScreen extends StatelessWidget {
  final bool isOnboarding;
  SkillsScreen({super.key, this.isOnboarding = false});

  final SkillController controller = Get.put(SkillController());

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
               

                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.skills.isEmpty) {
                      return const Center(child: Text("No Skills Yet"));
                    }
                    return ListView.builder(
                      itemCount: controller.skills.length,
                      itemBuilder: (context, index) => _skillCard(controller.skills[index]),
                    );
                  }),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      controller.clearFields();
                      _showSkillSheet();
                    },
                    child: Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(colors: [Color(0xFF9F67FF), Color(0xFF7C3AED)]),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFF7C3AED).withOpacity(0.35), blurRadius: 15, offset: const Offset(0, 6)),
                        ],
                      ),
                      child: const Icon(Icons.add_rounded, color: Colors.white, size: 34),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

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
                      if (controller.skills.isEmpty) {
                        Get.snackbar("Warning", "Add at least one skill");
                        return;
                      }
                      if (isOnboarding) {
                        Get.find<OnboardingController>().onSubStepSaved();
                      } else {
                        Get.toNamed("/training");
                      }
                    },
                    child: const Text("Next", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _skillCard(SkillModel skill) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE9D5FF)),
        boxShadow: [BoxShadow(color: const Color(0xFF7C3AED).withOpacity(0.08), blurRadius: 12)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: const Color(0xFF7C3AED)),
                child: const Icon(Icons.code, color: Colors.white),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(skill.name ?? "", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Color(0xFF7C3AED)),
                onPressed: () {
                  controller.fillForEdit(skill);
                  _showSkillSheet(skill: skill);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  Get.defaultDialog(
                    title: "Delete Skill",
                    middleText: "Are you sure?",
                    onConfirm: () async {
                      Get.back();
                      await controller.deleteSkill(skill.id!);
                    },
                    textConfirm: "Delete",
                    textCancel: "Cancel",
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(10)),
                child: Text("Level: ${skill.level}"),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(10)),
                child: Text("Type: ${skill.type}"),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Experience: ${skill.yearsExperience} years"),
          ),
        ],
      ),
    );
  }

  void _showSkillSheet({SkillModel? skill}) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(20)),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.add, color: Color(0xFF7C3AED)),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(skill == null ? "Add Skill" : "Edit Skill", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const Text("Fill in the details below"),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              TextField(
                controller: controller.nameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.code, color: Color(0xFF7C3AED)),
                  labelText: "Skill Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              TextField(
                controller: controller.levelController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.star_outline, color: Color(0xFF7C3AED)),
                  labelText: "Level",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              TextField(
                controller: controller.yearsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_month, color: Color(0xFF7C3AED)),
                  labelText: "Years Experience",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              TextField(
                controller: controller.typeController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.category_outlined, color: Color(0xFF7C3AED)),
                  labelText: "Type",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: GradientButton(
                      text: skill == null ? "Save Skill" : "Update Skill",
                      onTap: () async {
                        if (!controller.validateSkill()) return;
                        if (skill == null) {
                          await controller.createSkill();
                        } else {
                          await controller.updateSkill(skill.id!);
                        }
                        Get.back();
                      },
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