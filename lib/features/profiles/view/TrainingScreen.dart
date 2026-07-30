import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/onboarding/onboarding_controller.dart';

import '../controller/TrainingController.dart';
import '../mpdel/TrainingModel.dart';

class TrainingScreen extends StatelessWidget {
  final bool isOnboarding;
  TrainingScreen({super.key, this.isOnboarding = false});

  final TrainingController controller = Get.put(TrainingController());

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
                    if (controller.trainings.isEmpty) {
                      return const Center(child: Text("No Training Yet"));
                    }
                    return ListView.builder(
                      itemCount: controller.trainings.length,
                      itemBuilder: (context, index) {
                        final training = controller.trainings[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFE9D5FF)),
                            boxShadow: [
                              BoxShadow(color: const Color(0xFF7C3AED).withOpacity(0.08), blurRadius: 12),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 55,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color: const Color(0xFF7C3AED),
                                    ),
                                    child: const Icon(Icons.school, color: Colors.white),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(training.title ?? "", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                        Text(training.provider ?? ""),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Color(0xFF7C3AED)),
                                    onPressed: () {
                                      controller.fillForEdit(training);
                                      showTrainingSheet(training: training);
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
                                          await controller.deleteTraining(training.id!);
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(child: Text("📅 Start: ${training.startDate}")),
                                  Expanded(child: Text("📅 End: ${training.endDate}")),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("✔ Completed: ${training.isCompleted}"),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      controller.clearFields();
                      showTrainingSheet();
                    },
                    child: Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(colors: [Color(0xFF9F67FF), Color(0xFF7C3AED)]),
                      ),
                      child: const Icon(Icons.add_rounded, color: Colors.white, size: 34),
                    ),
                  ),
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
                        Get.toNamed("/education");
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

void showTrainingSheet({TrainingModel? training}) {
  final controller = Get.find<TrainingController>();

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
                    Text(training == null ? "Add Training" : "Edit Training",
                        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(training == null ? "Fill in the details below" : "Update training details",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 35),
            TextField(
              controller: controller.titleController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.title, color: Color(0xFF7C3AED)),
                labelText: "Title",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: controller.providerController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.business, color: Color(0xFF7C3AED)),
                labelText: "Provider",
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
              controller: controller.completedController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.check_circle_outline, color: Color(0xFF7C3AED)),
                labelText: "Is Completed",
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
                          if (!controller.validateTraining()) return;
                          if (training == null) {
                            await controller.createTraining();
                          } else {
                            await controller.updateTraining(training.id!);
                          }
                          Get.back();
                        },
                        child: Center(
                          child: Text(
                            training == null ? "Add Training" : "Update Training",
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