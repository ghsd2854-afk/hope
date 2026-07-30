import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:hobe/features/profiles/mpdel/profile_model.dart';
import 'package:hobe/features/profiles/services/profile_services.dart';
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
@override
void onInit() {
  super.onInit();
  getProfile();
}
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

    final result = await _service.createProfile(

      data: _buildFormData(),
    );

    profile.value = result;
await getProfile();
    Get.snackbar("Success", "Profile Created");

    Get.toNamed("/skills");

  } catch (e) {

  if (e is DioException) {

    print("STATUS => ${e.response?.statusCode}");

    print("DATA => ${e.response?.data}");

  }

}
}

Future<void> updateProfile() async {
  try {
    isLoading.value = true;

    final result = await _service.updateProfile(
      data: _buildFormData(),
    );

    profile.value = result;

    Get.snackbar("Success", "Profile Updated");

    // بس رجّعها للخلف، من غير ما تفرض التنقل لـ skills
    if (Get.previousRoute.isNotEmpty) {
      Get.back();
    }

  } catch (e) {
    Get.snackbar("Error", e.toString());
  } finally {
    isLoading.value = false;
  }
}

Future<void> getProfile() async {
  try {
    isLoading.value = true;

    final result = await _service.getProfile();

    if (result == null) {
      profile.value = null;
      return;
    }

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

  } catch (e) {
    profile.value = null;
  } finally {
    isLoading.value = false;
  }
}
Future<void> deleteProfile() async {
  try {

    await _service.deleteProfile();

    profile.value = null;

    Get.snackbar(
      "Success",
      "Profile Deleted",
    );

  } catch (e) {

    Get.snackbar(
      "Error",
      e.toString(),
    );
  }
}
bool validateProfile() {
  if (fullNameController.text.trim().isEmpty) {
    Get.snackbar("خطأ", "الاسم الكامل مطلوب");
    return false;
  }

  if (phoneController.text.trim().isEmpty) {
    Get.snackbar("خطأ", "رقم الهاتف مطلوب");
    return false;
  }

  if (cityController.text.trim().isEmpty) {
    Get.snackbar("خطأ", "المدينة مطلوبة");
    return false;
  }

  // الصورة اختيارية بالكامل - لا حاجة للتحقق منها إطلاقاً
  return true;
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