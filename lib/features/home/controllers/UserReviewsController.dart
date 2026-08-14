import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/core/theme/colors.dart';
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';
import 'package:hobe/features/home/models/UserReviewModel.dart';

class UserReviewsController extends GetxController {
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var reviewsList = <ReviewItem>[].obs;
  var stats = Rxn<ReviewStats>();

  late int userId;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      if (Get.arguments is int) {
        userId = Get.arguments;
      } else if (Get.arguments is String) {
        userId = int.tryParse(Get.arguments) ?? 0;
      } else {
        userId = int.tryParse(Get.arguments.toString()) ?? 0;
      }

      if (userId > 0) {
        fetchUserReviews();
      } else {
        errorMessage.value = "معرف المستخدم غير صالح";
        isLoading.value = false;
      }
    } else {
      errorMessage.value = "معرف المستخدم غير موجود";
      isLoading.value = false;
    }
  }

  void fetchUserReviews() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await DioService().dio.get(
        ApiConstants.publicProfile(userId),
      );

      if (response.statusCode == 200 &&
          (response.data['success'] == true ||
              response.data['status'] == 'success')) {
        final reviewResponse = UserReviewsModel.fromJson(response.data);
        reviewsList.value = reviewResponse.data.reviews.data;
        stats.value = reviewResponse.data.stats;
      } else {
        errorMessage.value = response.data['message'] ?? 'فشل في جلب التقييمات';
      }
    } catch (e, stackTrace) {
      print("CRITICAL PARSING ERROR: $e");
      print(stackTrace);
      // جعل الخطأ يظهر على الواجهة للمستخدم لتسهيل اكتشافه
      errorMessage.value = 'خطأ في مطابقة بيانات السيرفر: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
