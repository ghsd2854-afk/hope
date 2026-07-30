import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/onboarding/onboarding_controller.dart';
import 'package:hobe/features/profiles/mpdel/InterestModel.dart';

import '../controller/InterestController.dart';

class InterestScreen extends StatelessWidget {
  final bool isOnboarding;
  InterestScreen({super.key, this.isOnboarding = false});

  final InterestController controller = Get.put(InterestController());

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
                    const Text("Your Interests", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () {
                        controller.clearFields();
                        _showInterestSheet();
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
                            Text("Add Interest", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                    if (controller.interests.isEmpty) {
                      return const Center(child: Text("No Interests Yet"));
                    }
                    return ListView.builder(
                      itemCount: controller.interests.length,
                      itemBuilder: (context, index) {
                        final interest = controller.interests[index];
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
                                    child: const Icon(Icons.favorite, color: Colors.white),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(interest.name ?? "", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 4),
                                        Text(interest.category ?? "", style: TextStyle(color: Colors.grey.shade700)),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Color(0xFF7C3AED)),
                                    onPressed: () {
                                      controller.fillForEdit(interest);
                                      _showInterestSheet(interest: interest);
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
                                          await controller.deleteInterest(interest.id!);
                                        },
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
                                      child: Text(interest.category ?? "", style: const TextStyle(color: Color(0xFF7C3AED))),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(10)),
                                      child: Text("Level ${interest.level}", style: const TextStyle(color: Color(0xFF7C3AED))),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(interest.description ?? "", style: TextStyle(color: Colors.grey.shade700)),
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
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(colors: [Color(0xFF38BDF8), Color(0xFF9333EA)]),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        // ⭐ هاي آخر خطوة بالـ Onboarding (preferences) — لما تنضغط
                        // ومافي صفحات تانية بنفس المجموعة، onSubStepSaved() بتكمل
                        // آخر خطوة عالسيرفر وبتوجه المستخدم لـ /home تلقائياً
                        if (isOnboarding) {
                          Get.find<OnboardingController>().onSubStepSaved();
                        } else {
                          try {
                            Get.toNamed("/skillSuggestions");
                          } catch (e, s) {
                            print(e);
                            print(s);
                          }
                          Get.snackbar("Completed", "Profile Completed Successfully 🎉");
                        }
                      },
                      child: const Text("next", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

  void _showInterestSheet({InterestModel? interest}) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
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
                    child: const Icon(Icons.favorite_outline, color: Colors.white, size: 40),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(interest == null ? "Add Interest" : "Edit Interest",
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text(interest == null ? "Fill interest information" : "Update your interest",
                          style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              TextField(
                controller: controller.nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  prefixIcon: const Icon(Icons.favorite, color: Color(0xFF7C3AED)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: controller.categoryController,
                decoration: InputDecoration(
                  labelText: "Category",
                  prefixIcon: const Icon(Icons.category, color: Color(0xFF7C3AED)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: controller.levelController,
                decoration: InputDecoration(
                  labelText: "Level",
                  prefixIcon: const Icon(Icons.bar_chart, color: Color(0xFF7C3AED)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: controller.descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Description",
                  prefixIcon: const Icon(Icons.description, color: Color(0xFF7C3AED)),
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
                            if (!controller.validateInterest()) return;
                            if (interest == null) {
                              await controller.createInterest();
                            } else {
                              await controller.updateInterest(interest.id!);
                            }
                            Get.back();
                          },
                          child: Center(
                            child: Text(
                              interest == null ? "Add Interest" : "Update Interest",
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