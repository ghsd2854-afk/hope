import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio_pkg;
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';

class MyProjectsController extends GetxController {
  var isLoading = false.obs;
  var projectsList = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyProjects();
  }

  void fetchMyProjects() async {
    try {
      isLoading.value = true;
      final dioInstance = DioService().dio;

      final response = await dioInstance.get(
        '${ApiConstants.createStartupProject}/my-projects',
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data != null) {
          projectsList.value = data;
        }
      }
    } on dio_pkg.DioException catch (e) {
      Get.snackbar(
        "خطأ",
        e.response?.data['message'] ?? "فشل في تحميل المشاريع",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
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
}
