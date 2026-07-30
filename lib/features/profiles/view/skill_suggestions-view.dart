import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/onboarding/onboarding_controller.dart';
import 'package:hobe/features/profiles/controller/skill_suggestions_controller.dart';
import 'package:hobe/features/profiles/mpdel/skill_suggestions-model.dart';

class SkillSuggestionScreen extends StatelessWidget {
  final bool isOnboarding;
  SkillSuggestionScreen({super.key, this.isOnboarding = false});

  final SkillSuggestionController controller = Get.put(SkillSuggestionController());

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
                    const Text("AI Skill Suggestions", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () => controller.generate(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: const LinearGradient(colors: [Color(0xFF38BDF8), Color(0xFF9333EA)]),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.auto_awesome, color: Colors.white),
                            SizedBox(width: 8),
                            Text("Generate", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                    if (controller.suggestions.isEmpty) {
                      return const Center(child: Text("No Suggestions Yet"));
                    }
                    return ListView.builder(
                      itemCount: controller.suggestions.length,
                      itemBuilder: (context, index) => _skillCard(controller.suggestions[index]),
                    );
                  }),
                ),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      if (isOnboarding) {
                        Get.find<OnboardingController>().onSubStepSaved();
                      } else {
                        Get.toNamed("/cvGenerate");
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("finish", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                      ],
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

  Widget _skillCard(SkillSuggestionModel skill) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF9F67FF), Color(0xFF7C3AED)]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(skill.name ?? "", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(skill.type ?? ""),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(skill.reason ?? ""),
          const SizedBox(height: 15),
          LinearProgressIndicator(value: (skill.priority ?? 0) / 100),
          const SizedBox(height: 5),
          Text("Priority : ${skill.priority}%"),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () => controller.accept(skill),
                  child: const Text("Accept"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () => controller.reject(skill),
                  child: const Text("Reject"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}