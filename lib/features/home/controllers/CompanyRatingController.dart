import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio_pkg;
import 'package:hobe/features/APIS/dio_services.dart';
import 'package:hobe/features/home/models/CompanyReviewModel.dart';

class CompanyRatingController extends GetxController {
  var isLoading = false.obs;
  var isFetchingReviews = false.obs;

  var reviewsList = <CompanyReviewModel>[].obs;

  var overallRating = 0.obs;
  var workEnvironmentRating = 0.obs;
  var salaryBenefitsRating = 0.obs;
  var workLifeBalanceRating = 0.obs;
  var interviewExperienceRating = 0.obs;

  var wouldRecommend = 1.obs;
  var isAnonymous = 0.obs;

  Future<void> submitReview(
    int userId, { // <--- يفضل تسميته userId وفتحه بناءً على المنطق الجديد
    required String title,
    required String pros,
    required String cons,
    required String advice,
  }) async {
    if (overallRating.value == 0) {
      Get.snackbar(
        "تنبيه",
        "يرجى تحديد التقييم العام على الأقل",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      final Map<String, dynamic> requestData = {
        "type": "applicant_to_company",
        "overall_rating": overallRating.value,
        "work_environment_rating": workEnvironmentRating.value,
        "salary_benefits_rating": salaryBenefitsRating.value,
        "work_life_balance_rating": workLifeBalanceRating.value,
        "interview_experience_rating": interviewExperienceRating.value,
        "title": title,
        "pros": pros,
        "cons": cons,
        "advice": advice,
        "would_recommend": wouldRecommend.value,
        "is_anonymous": isAnonymous.value,
      };

      final dio = DioService().dio;

      // تأكد هل الـ Endpoint يتطلب userId أم id الشركة القديم في رابط الـ applications
      await dio.post('/applications/$userId/review', data: requestData);

      Get.back();
      Get.snackbar(
        "نجاح",
        "تم إرسال تقييمك بنجاح",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      fetchCompanyReviews(userId);
      clearForm();
    } on dio_pkg.DioException catch (e) {
      String errorMessage = "حدث خطأ أثناء إرسال التقييم";
      if (e.response != null && e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }
      Get.snackbar(
        "خطأ",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCompanyReviews(int userId) async {
    try {
      isFetchingReviews.value = true;

      final dio = DioService().dio;
      final response = await dio.get('/companies/$userId/reviews');

      final responseData = response.data;
      List dataList = [];

      if (responseData is Map) {
        final dataField = responseData['data'];

        if (dataField is Map) {
          if (dataField['reviews'] is Map &&
              dataField['reviews']['data'] is List) {
            dataList = dataField['reviews']['data'];
          }
        } else if (dataField is List) {
          dataList = dataField;
        }
      } else if (responseData is List) {
        dataList = responseData;
      }

      reviewsList.value = dataList
          .map((json) => CompanyReviewModel.fromJson(json))
          .toList();

      print(
        "✅ [CompanyRatingController] Reviews fetched successfully. Count: ${reviewsList.length}",
      );
    } catch (e) {
      print("❌ [CompanyRatingController] Error fetching reviews: $e");
      reviewsList.clear();
    } finally {
      isFetchingReviews.value = false;
    }
  }

  void clearForm() {
    overallRating.value = 0;
    workEnvironmentRating.value = 0;
    salaryBenefitsRating.value = 0;
    workLifeBalanceRating.value = 0;
    interviewExperienceRating.value = 0;
    wouldRecommend.value = 1;
    isAnonymous.value = 0;
  }
}
