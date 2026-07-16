
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hobe/features/auth/controllers/profile_controller.dart';

import '../../../core/theme/colors.dart';



import 'package:hobe/features/auth/widgets/custum_input.dart';
import 'package:hobe/features/auth/widgets/gradient_button.dart';






class ProfileEditScreen extends StatelessWidget {
  ProfileEditScreen({super.key});

  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      //  foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
  padding: const EdgeInsets.all(20),
  child: Column(
    children: [

      Obx(
        () => GestureDetector(
          onTap: controller.pickImage,
          child: CircleAvatar(
            radius: 50,
            backgroundImage:
                controller.imageFile.value != null
                    ? FileImage(
                        controller.imageFile.value!,
                      )
                    : null,
            child:
                controller.imageFile.value == null
                    ? const Icon(
                        Icons.camera_alt,
                        size: 35,
                      )
                    : null,
          ),
        ),
      ),

      const SizedBox(height: 20),

      CustomInput(
        hint: "Full Name",
        icon: Icons.person,
        controller:
            controller.fullNameController,
      ),

      const SizedBox(height: 10),

      CustomInput(
        hint: "Headline",
        icon: Icons.work,
        controller:
            controller.headlineController,
      ),

      const SizedBox(height: 10),

      CustomInput(
        hint: "Summary",
        icon: Icons.description,
        controller:
            controller.summaryController,
      ),

      const SizedBox(height: 10),

      CustomInput(
        hint: "Gender",
        icon: Icons.people,
        controller:
            controller.genderController,
      ),

      const SizedBox(height: 10),

      CustomInput(
        hint: "Phone",
        icon: Icons.phone,
        controller:
            controller.phoneController,
      ),

      const SizedBox(height: 10),

      CustomInput(
        hint: "Address",
        icon: Icons.location_on,
        controller:
            controller.addressController,
      ),

      const SizedBox(height: 10),

      CustomInput(
        hint: "Birth Date",
        icon: Icons.calendar_month,
        controller:
            controller.birthDateController,
      ),

      const SizedBox(height: 10),

      CustomInput(
        hint: "Country",
        icon: Icons.flag,
        controller:
            controller.countryController,
      ),

      const SizedBox(height: 10),

      CustomInput(
        hint: "City",
        icon: Icons.location_city,
        controller:
            controller.cityController,
      ),

      const SizedBox(height: 10),

      CustomInput(
        hint: "LinkedIn",
        icon: Icons.link,
        controller:
            controller.linkedinController,
      ),

      const SizedBox(height: 10),

      CustomInput(
        hint: "GitHub",
        icon: Icons.code,
        controller:
            controller.githubController,
      ),

      const SizedBox(height: 10),

      CustomInput(
        hint: "Portfolio",
        icon: Icons.web,
        controller:
            controller.portfolioController,
      ),

      const SizedBox(height: 30),

      Obx(
        () => GradientButton(
          text: "Save Profile",
          loading:
              controller.isLoading.value,
          onTap:
              controller.createProfile,
        ),
        
      ),
       Obx(
        () => GradientButton(
  text: "Update Profile",
  onTap: controller.updateProfile,
)
        
      ),
       Obx(
        () => ElevatedButton(
  onPressed: controller.deleteProfile,
  child: const Text(
    "Delete Profile",
  ),
)
        
      ),
    ],
  ),
)
      ),
    );
  }
}