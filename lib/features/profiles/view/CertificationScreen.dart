import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/onboarding/onboarding_controller.dart';

import '../controller/CertificationController.dart';
import '../mpdel/CertificationModel.dart';

class CertificationScreen extends StatelessWidget {
  final bool isOnboarding;
  CertificationScreen({super.key, this.isOnboarding = false});

  final CertificationController controller =
      Get.put(CertificationController());

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
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // ---- Profile Completion card: تظهر بس لما الشاشة مش جوا onboarding ----
             
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Your Certifications",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.clearFields();
                        _showCertificationSheet();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF38BDF8), Color(0xFF9333EA)],
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.add, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              "Add Certification",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
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
                    if (controller.certifications.isEmpty) {
                      return const Center(child: Text("No Certifications Yet"));
                    }
                    return ListView.builder(
                      itemCount: controller.certifications.length,
                      itemBuilder: (context, index) {
                        final certification = controller.certifications[index];
                        return _certificationCard(certification);
                      },
                    );
                  }),
                ),

                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF38BDF8), Color(0xFF9333EA)],
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        if (isOnboarding) {
                          Get.find<OnboardingController>().onSubStepSaved();
                        } else {
                          Get.toNamed("/interests");
                        }
                      },
                      child: const Center(
                        child: Text(
                          "Next",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
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

  Widget _certificationCard(CertificationModel certification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE9D5FF)),
        boxShadow: [
          BoxShadow(color: const Color(0xFF7C3AED).withOpacity(.08), blurRadius: 12),
        ],
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
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9F67FF), Color(0xFF7C3AED)],
                  ),
                ),
                child: const Icon(Icons.workspace_premium, color: Colors.white),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      certification.name ?? "",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(certification.issuer ?? "", style: TextStyle(color: Colors.grey.shade700)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Color(0xFF7C3AED)),
                onPressed: () {
                  controller.fillForEdit(certification);
                  _showCertificationSheet(certification: certification);
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
                      await controller.deleteCertification(certification.id!);
                    },
                    textConfirm: "Delete",
                    textCancel: "Cancel",
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: Text("📅 ${certification.issuedAt}")),
              Expanded(child: Text("📅 ${certification.expiresAt}")),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Credential ID: ${certification.credentialId}",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showCertificationSheet({CertificationModel? certification}) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 70,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFB794F4), Color(0xFF7C3AED)],
                      ),
                    ),
                    child: const Icon(Icons.workspace_premium, color: Colors.white, size: 40),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        certification == null ? "Add Certification" : "Edit Certification",
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        certification == null ? "Fill in the details below" : "Update certification details",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 35),
              TextField(
                controller: controller.nameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.workspace_premium, color: Color(0xFF7C3AED)),
                  labelText: "Certification Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: controller.issuerController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.business, color: Color(0xFF7C3AED)),
                  labelText: "Issuer",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: controller.issuedAtController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_month, color: Color(0xFF7C3AED)),
                  labelText: "Issued At",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: controller.expiresAtController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.event, color: Color(0xFF7C3AED)),
                  labelText: "Expires At",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: controller.credentialIdController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.badge, color: Color(0xFF7C3AED)),
                  labelText: "Credential ID",
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
                        gradient: const LinearGradient(
                          colors: [Color(0xFFB794F4), Color(0xFF7C3AED)],
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () async {
                            if (!controller.validateCertification()) return;
                            if (certification == null) {
                              await controller.createCertification();
                            } else {
                              await controller.updateCertification(certification.id!);
                            }
                            Get.back();
                          },
                          child: Center(
                            child: Text(
                              certification == null ? "Add Certification" : "Update Certification",
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