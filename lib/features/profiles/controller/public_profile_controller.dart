import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/profiles/mpdel/profile_completion_model.dart';
import 'package:hobe/features/profiles/mpdel/public_profile_model.dart';
import 'package:hobe/features/profiles/mpdel/public_profile_view_model.dart';
import 'package:hobe/features/profiles/services/public_profile_service.dart';

class PublicProfileController extends GetxController {
  final PublicProfileService _service = PublicProfileService();

  var completion = Rxn<ProfileCompletionModel>();
  var publicProfile = Rxn<PublicProfileModel>();
  var viewedProfile = Rxn<PublicProfileViewModel>();

  var isLoading = false.obs;
  var isSaving = false.obs;
  var isChangingSlug = false.obs;

  final metaTitleController = TextEditingController();
  final metaDescriptionController = TextEditingController();
  final slugController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadCompletion();
    loadPublicSettings();
  }

  Future<void> loadCompletion() async {
    try {
      isLoading.value = true;
      completion.value = await _service.getCompletion();
    } catch (e) {
      // تجاهل بصمت، الشاشة هتعرض رسالة تعذر التحميل
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> recalculate() async {
    try {
      isLoading.value = true;
      completion.value = await _service.recalculateCompletion();
      Get.snackbar("تم", "تم تحديث نسبة الاكتمال");
    } catch (e) {
      Get.snackbar("خطأ", "تعذر تحديث نسبة الاكتمال");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadPublicSettings() async {
    try {
      isLoading.value = true;
      final result = await _service.getPublicSettings();
      publicProfile.value = result;
      metaTitleController.text = result.metaTitle ?? "";
      metaDescriptionController.text = result.metaDescription ?? "";
      slugController.text = result.slug;
    } catch (e) {
      // تجاهل بصمت
    } finally {
      isLoading.value = false;
    }
  }

  void toggleIsPublic(bool value) {
    final current = publicProfile.value;
    if (current == null) return;
    publicProfile.value = current.copyWith(isPublic: value);
  }

  void toggleSection(String key, bool value) {
    final current = publicProfile.value;
    if (current == null) return;

    final sections = current.visibleSections;
    late VisibleSections updated;

    switch (key) {
      case "contact_info":
        updated = sections.copyWith(contactInfo: value);
        break;
      case "experience":
        updated = sections.copyWith(experience: value);
        break;
      case "education":
        updated = sections.copyWith(education: value);
        break;
      case "skills":
        updated = sections.copyWith(skills: value);
        break;
      case "projects":
        updated = sections.copyWith(projects: value);
        break;
      case "certifications":
        updated = sections.copyWith(certifications: value);
        break;
      case "reviews":
        updated = sections.copyWith(reviews: value);
        break;
      default:
        updated = sections;
    }

    publicProfile.value = current.copyWith(visibleSections: updated);
  }

  Future<void> savePublicSettings() async {
    final current = publicProfile.value;
    if (current == null) return;

    try {
      isSaving.value = true;

      final data = current
          .copyWith(
            metaTitle: metaTitleController.text,
            metaDescription: metaDescriptionController.text,
          )
          .toUpdateJson();

      final result = await _service.updatePublicSettings(data: data);
      publicProfile.value = result;

      Get.snackbar("تم", "تم حفظ إعدادات البروفايل العام");
    } catch (e) {
      Get.snackbar("خطأ", "تعذر حفظ الإعدادات");
    } finally {
      isSaving.value = false;
    }
  }

Future<void> changeSlug() async {
  final newSlug = slugController.text.trim();
  if (newSlug.isEmpty) {
    Get.snackbar("خطأ", "الرجاء إدخال Slug");
    return;
  }

  try {
    isChangingSlug.value = true;
    await _service.changeSlug(slug: newSlug);

    // إعادة تحميل الإعدادات لضمان تطابق الـ slug الجديد
    await loadPublicSettings();

    Get.snackbar("تم", "تم تغيير رابط البروفايل بنجاح");
  } catch (e) {
    Get.snackbar("خطأ", "هذا الرابط مستخدم من قبل، جرب رابط آخر");
  } finally {
    isChangingSlug.value = false;
  }
}

  Future<void> loadPublicProfileBySlug(String slug) async {
    try {
      isLoading.value = true;
      viewedProfile.value = await _service.viewPublicProfile(slug: slug);
    } catch (e) {
      Get.snackbar("خطأ", "تعذر تحميل البروفايل العام");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    metaTitleController.dispose();
    metaDescriptionController.dispose();
    slugController.dispose();
    super.onClose();
  }
}