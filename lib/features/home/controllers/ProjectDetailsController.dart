import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio_pkg;
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';
import 'package:hobe/features/home/models/project_model.dart';

class ProjectDetailsController extends GetxController {
  var isLoading = false.obs;
  var project = ProjectModel().obs;
  late final int projectId;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      projectId = Get.arguments;
      fetchProjectDetails();
    }
  }

  // دالة حذف المشروع
  void deleteProject() async {
    final projectId = project.value.id;

    if (projectId == null) {
      Get.snackbar(
        "خطأ",
        "معرف المشروع غير متوفر",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final dioInstance = DioService().dio;
      // استخدام مسار الـ API لحذف المشروع بناءً على الـ id
      String url = ApiConstants.deleteStartupProject(
        projectId,
      ); // تأكدي من إضافة المسار في ApiConstants أو كتابة الرابط مباشرة

      final response = await dioInstance.delete(url);

      if (response.statusCode == 200 || response.statusCode == 204) {
        Get.snackbar(
          "نجاح",
          "تم حذف المشروع بنجاح",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        // العودة للخلف (شاشة عرض المشاريع) بعد الحذف بنجاح
        Get.back();
      } else {
        Get.snackbar(
          "خطأ",
          "فشل في حذف المشروع",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on dio_pkg.DioException catch (e) {
      String errorMessage =
          e.response?.data['message'] ?? "حدث خطأ أثناء محطة الحذف";
      Get.snackbar(
        "خطأ",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "حدث خطأ غير متوقع: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void fetchProjectDetails() async {
    try {
      isLoading.value = true;
      final dioInstance = DioService().dio;
      final url = ApiConstants.startupProjectDetails(projectId);

      print("Requesting URL: $url");

      final response = await dioInstance.get(url);

      if (response.statusCode == 200) {
        final responseData = response.data['data'] ?? response.data;
        project.value = ProjectModel.fromJson(responseData);
      }
    } on dio_pkg.DioException catch (e) {
      print("Error Code: ${e.response?.statusCode}");
      print("Error Message: ${e.response?.data}");

      Get.snackbar(
        "خطأ",
        e.response?.data['message'] ?? "فشل في تحميل تفاصيل المشروع",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "حدث خطأ غير متوقع: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> respondToInterest(int interestId, String action) async {
    try {
      isLoading.value = true; // من الأفضل تفعيل حالة التحميل أيضاً هنا
      FormData formData = FormData.fromMap({'action': action});

      // استخدام الـ DioService الذي يحتوي على التوكن
      final dioInstance = DioService().dio;

      final response = await dioInstance.post(
        ApiConstants.respondToInterest(
          interestId,
        ), // تأكد أن الرابط كامل أو تعامل معه بناءً على الـ BaseUrl في DioService
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "نجاح",
          action == 'approve' ? "تم قبول الاهتمام بنجاح" : "تم رفض الاهتمام",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // تحديث البيانات بعد النجاح
        fetchProjectDetails();
      }
    } on dio_pkg.DioException catch (e) {
      // إضافة طباعة للخطأ لمعرفة سبب الرفض بالضبط من السيرفر
      print("Error: ${e.response?.data}");

      Get.snackbar(
        "خطأ",
        e.response?.data['message'] ?? "حدث خطأ أثناء الاتصال بالسيرفر",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      print("General Error: $e");
      Get.snackbar(
        "خطأ",
        "حدث خطأ غير متوقع",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void acceptInterest(var interest) {
    // افترض أن المفتاح هو id أو id_ الخاص بالاهتمام
    var interestId = interest['id'];
    respondToInterest(interestId, 'approve');
  }

  void rejectInterest(var interest) {
    var interestId = interest['id'];
    respondToInterest(interestId, 'reject');
  }
}
