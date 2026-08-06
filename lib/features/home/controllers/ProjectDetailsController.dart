import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

      // استخدام المسار الصحيح المعتمد على الـ id
      final url = ApiConstants.startupProjectDetails(projectId);
      // أو مباشرة: final url = '/startup-projects/$projectId';

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

  /* void fetchProjectDetails() async {
    try {
      isLoading.value = true;
      final dioInstance = DioService().dio;

      // استخدام ApiConstants.createStartupProject بالطريقة الصحيحة
      final url = '${ApiConstants.createStartupProject}/$projectId';
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
    } finally {
      isLoading.value = false;
    }
  }*/
}
