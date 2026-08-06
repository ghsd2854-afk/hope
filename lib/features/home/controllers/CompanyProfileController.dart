import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hobe/core/theme/colors.dart';
import 'package:hobe/features/APIS/dio_services.dart';
import 'package:hobe/features/home/models/companyProfileModel.dart';
// 1️⃣ استيراد كونترولر التقييمات الخاص بكِ
import 'package:hobe/features/home/controllers/CompanyRatingController.dart'; // عدلي المسار إذا لزم الأمر

class CompanyProfileController extends GetxController {
  var isLoading = true.obs;
  var companyData = Rxn<CompanyProfileModel>();

  // متغير حالة المتابعة (مبدئياً false أو يمكن قراءته من البيانات القادمة من الـ API إن وجدت)
  var isFollowing = false.obs;

  late int companyId;

  @override
  void onInit() {
    super.onInit();

    // 1️⃣ استقبال الـ ID المرسل، وإذا لم يُرسل يتم افتراض قيمة 1
    companyId = Get.arguments ?? 1;
    print(
      "🟢 [CompanyProfileController] onInit: Initialized with companyId = $companyId",
    );

    fetchCompanyProfile();
  }

  // دالة مساعدة لجلب التقييمات تلقائياً
  void _fetchReviewsForCompany(int userId) {
    try {
      final ratingController = Get.isRegistered<CompanyRatingController>()
          ? Get.find<CompanyRatingController>()
          : Get.put(CompanyRatingController());

      ratingController.fetchCompanyReviews(
        userId,
      ); // <--- تمرير الـ userId الصحيح
    } catch (e) {
      print("❌ [CompanyProfileController] Error fetching reviews: $e");
    }
  }

  void fetchCompanyProfile() async {
    try {
      isLoading.value = true;
      print(
        "⏳ [CompanyProfileController] fetchCompanyProfile: Starting request for company ID: $companyId...",
      );

      final response = await DioService().dio.get(
        '/companies/$companyId/profile',
      );

      print(
        "📡 [CompanyProfileController] Response Status Code: ${response.statusCode}",
      );
      print("📦 [CompanyProfileController] Response Data: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        companyData.value = CompanyProfileModel.fromJson(response.data);

        print(
          "✅ [CompanyProfileController] Data parsed successfully and assigned to companyData!",
        );

        // 🌟 التعديل هنا: جلب التقييمات باستخدام الـ userId الخاص بالشركة بعد توفره
        final companyUserId = companyData.value?.company?.userId;
        if (companyUserId != null) {
          _fetchReviewsForCompany(companyUserId);
        }
      } else {
        print(
          "⚠️ [CompanyProfileController] Response was successful, but data is null or status code is not 200.",
        );
      }
    } catch (e, stackTrace) {
      print(
        "❌ [CompanyProfileController] Error occurred while fetching profile: $e",
      );
      debugPrint("🔍 StackTrace: $stackTrace");

      Get.snackbar(
        "خطأ",
        "فشل في جلب بيانات الشركة: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primaryEnd,
        colorText: AppColors.textDarkPrimary,
      );
    } finally {
      isLoading.value = false;
      print(
        "🏁 [CompanyProfileController] fetchCompanyProfile finished. isLoading: ${isLoading.value}",
      );
    }
  }

  // دالة تبديل حالة المتابعة (متابعة / إلغاء متابعة)
  void toggleFollowCompany() async {
    try {
      // عكس الحالة مؤقتاً للتفاعل السريع (Optimistic UI)
      bool previousState = isFollowing.value;
      isFollowing.value = !previousState;

      final response = await DioService().dio.post(
        '/companies/$companyId/follow', // تعديل الرابط حسب الـ API الخاص بك
      );

      if (response.statusCode == 200) {
        print(
          "✅ [CompanyProfileController] Follow status updated successfully.",
        );
      } else {
        // في حال فشل الطلب، نعيد الحالة لما كانت عليه
        isFollowing.value = previousState;
        Get.snackbar(
          "تنبيه",
          "فشل تحديث حالة المتابعة",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      // إعادة الحالة القديمة عند حدوث خطأ
      isFollowing.value = !isFollowing.value;
      print("❌ [CompanyProfileController] Error in toggleFollowCompany: $e");
      Get.snackbar(
        "خطأ",
        "حدث خطأ ما، يرجى المحاولة لاحقاً",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
