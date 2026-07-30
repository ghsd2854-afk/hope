import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/onboarding/onboarding_controller.dart';
import 'package:hobe/features/profiles/mpdel/ProjectModel.dart';

import '../controller/ProjectController.dart';

class ProjectsScreen extends StatelessWidget {
  final bool isOnboarding;
  ProjectsScreen({super.key, this.isOnboarding = false});

  final ProjectController controller = Get.put(ProjectController());

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
                    const Text("Your Projects", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () {
                        controller.clearFields();
                        _showProjectSheet();
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
                            Text("Add Project", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.projects.isEmpty) {
                      return const Center(child: Text("No Projects Yet"));
                    }
                    return ListView.builder(
                      itemCount: controller.projects.length,
                      itemBuilder: (context, index) => _projectCard(controller.projects[index]),
                    );
                  }),
                ),

                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(colors: [Color(0xFF38BDF8), Color(0xFF9333EA)]),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        if (isOnboarding) {
                          Get.find<OnboardingController>().onSubStepSaved();
                        } else {
                          Get.toNamed("/certification");
                        }
                      },
                      child: const Center(
                        child: Text("Next", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
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

  Widget _projectCard(ProjectModel project) {
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
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(colors: [Color(0xFF38BDF8), Color(0xFF9333EA)]),
                ),
                child: const Icon(Icons.code, color: Colors.white),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.title ?? "", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(project.description ?? "", maxLines: 2),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Color(0xFF7C3AED)),
                onPressed: () {
                  controller.fillForEdit(project);
                  _showProjectSheet(project: project);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  Get.defaultDialog(
                    title: "Delete",
                    middleText: "Are you sure?",
                    textCancel: "Cancel",
                    textConfirm: "Delete",
                    onConfirm: () async {
                      Get.back();
                      await controller.deleteProject(project.id!);
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: project.technologies!
                  .map((e) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(10)),
                        child: Text(e, style: const TextStyle(color: Color(0xFF7C3AED))),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 15),
          Align(alignment: Alignment.centerLeft, child: Text(project.link ?? "")),
        ],
      ),
    );
  }

  void _showProjectSheet({ProjectModel? project}) {
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
                      gradient: const LinearGradient(colors: [Color(0xFF38BDF8), Color(0xFF9333EA)]),
                    ),
                    child: const Icon(Icons.code, color: Colors.white, size: 40),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(project == null ? "Add Project" : "Edit Project",
                          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text(project == null ? "Fill in the details below" : "Update project details",
                          style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 35),
              TextField(
                controller: controller.titleController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.title, color: Color(0xFF7C3AED)),
                  labelText: "Project Title",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: controller.descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.description, color: Color(0xFF7C3AED)),
                  labelText: "Description",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: controller.linkController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.link, color: Color(0xFF7C3AED)),
                  labelText: "Project Link",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: controller.technologiesController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.code, color: Color(0xFF7C3AED)),
                  labelText: "Technologies",
                  hintText: "Flutter,Laravel,PHP",
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
                            if (!controller.validateProject()) return;
                            if (project == null) {
                              await controller.createProject();
                            } else {
                              await controller.updateProject(project.id!);
                            }
                            Get.back();
                          },
                          child: Center(
                            child: Text(
                              project == null ? "Add Project" : "Update Project",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}