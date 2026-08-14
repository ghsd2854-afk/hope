import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:hobe/features/auth/model/profile_model.dart';
import 'package:hobe/features/auth/services/profile_services.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final fullNameController = TextEditingController();
  final headlineController = TextEditingController();
  final summaryController = TextEditingController();
  final genderController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final birthDateController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final linkedinController = TextEditingController();
  final githubController = TextEditingController();
  final portfolioController = TextEditingController();

  final ProfileService _service = ProfileService();

  var profile = Rxn<ProfileModel>();
  var isLoading = false.obs;

  final picker = ImagePicker();
  Rx<File?> imageFile = Rx<File?>(null);

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      imageFile.value = File(picked.path);
    }
  }

  FormData _buildFormData() {
    final formData = FormData();

    formData.fields.addAll([
      MapEntry("full_name", fullNameController.text),
      MapEntry("headline", headlineController.text),
      MapEntry("summary", summaryController.text),
      MapEntry("gender", genderController.text),
      MapEntry("phone", phoneController.text),
      MapEntry("address", addressController.text),
      MapEntry("birth_date", birthDateController.text),
      MapEntry("country", countryController.text),
      MapEntry("city", cityController.text),
      MapEntry("linkedin", linkedinController.text),
      MapEntry("github", githubController.text),
      MapEntry("portfolio", portfolioController.text),
    ]);

    final img = imageFile.value;
    if (img != null) {
      formData.files.add(
        MapEntry(
          "profile_image",
          MultipartFile.fromFileSync(
            img.path,
            filename: img.path.split('/').last,
          ),
        ),
      );
    }

    return formData;
  }

  Future<void> createProfile() async {
    try {
      isLoading.value = true;

      await _service.createProfile(data: _buildFormData());

      Get.snackbar("Success", "Profile Created");
    } catch (e) {
      print("CREATE ERROR: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;

      await _service.updateProfile(data: _buildFormData());

      Get.snackbar("Success", "Profile Updated");
    } catch (e) {
      print("UPDATE ERROR: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getProfile() async {
    try {
      isLoading.value = true;

      final result = await _service.getProfile();
      profile.value = result;
      fullNameController.text = result.fullName ?? "";
      headlineController.text = result.headline ?? "";
      summaryController.text = result.summary ?? "";
      genderController.text = result.gender ?? "";
      phoneController.text = result.phone ?? "";
      addressController.text = result.address ?? "";
      birthDateController.text = result.birthDate ?? "";
      countryController.text = result.country ?? "";
      cityController.text = result.city ?? "";
      linkedinController.text = result.linkedin ?? "";
      githubController.text = result.github ?? "";
      portfolioController.text = result.portfolio ?? "";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProfile() async {
    try {
      await _service.deleteProfile();
      Get.snackbar("Success", "Profile Deleted");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    headlineController.dispose();
    summaryController.dispose();
    genderController.dispose();
    phoneController.dispose();
    addressController.dispose();
    birthDateController.dispose();
    countryController.dispose();
    cityController.dispose();
    linkedinController.dispose();
    githubController.dispose();
    portfolioController.dispose();
    super.onClose();
  }
}
