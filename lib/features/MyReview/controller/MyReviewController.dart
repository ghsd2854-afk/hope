import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:hobe/features/APIS/api_constants.dart'; // تأكدي من مسار الاستيراد الصحيح حسب مشروعك
import 'package:hobe/features/APIS/dio_services.dart';
import 'package:hobe/features/MyReview/model/myReviewmodel.dart';

class MyReviewController extends GetxController {
  var reviews = <MyReviewModel>[].obs;
  var isLoading = false.obs;

  // استخدام مثيل Dio المجهز مسبقاً في مشروعك والذي يحقن الـ BaseUrl والـ Token تلقائياً
  final dio.Dio _dio = DioService().dio;

  @override
  void onInit() {
    super.onInit();
    fetchMyReviews();
  }

  // 1. جلب تقييمات المستخدم (التقييمات الواردة إليه من الشركات)
  void fetchMyReviews() async {
    try {
      isLoading.value = true;
      // استناداً لملف الـ ApiConstants لديك، المسار الخاص بتقييمات المستخدم هو:
      //  var response = await _dio.get(ApiConstants.companyReviews /* أو مسار تقييمات المستخدم إذا وجد، سنستخدم المسار العام أو المخصص */);
      // ملاحظة: إذا كان المسار المختلف موجوداً مثل عرض تقييمات المستخدم:
      var response = await _dio.get(
        '/my-reviews',
      ); // عدليها حسب المسار الفعلي في لارفل إذا لم تكن مدرجة

      if (response.statusCode == 200) {
        var list = response.data['data'] as List;
        reviews.value = list.map((e) => MyReviewModel.fromJson(e)).toList();
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في تحميل التقييمات: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 2. الرد على التقييم
  Future<void> respondToReview(int reviewId, String responseText) async {
    try {
      // المسار بناءً على هيكل الـ Backend لديك: /api/reviews/{id}/respond
      var response = await _dio.post(
        '/reviews/$reviewId/respond',
        data: {'response': responseText},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back(); // إغلاق النافذة المنبثقة
        Get.snackbar(
          'نجاح',
          'تم إرسال الرد بنجاح',
          snackPosition: SnackPosition.BOTTOM,
        );
        fetchMyReviews();
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في إرسال الرد',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // 3. التفاعل مع التقييم (مثلاً helpful)
  Future<void> reactToReview(int reviewId, String reactionType) async {
    try {
      // المسار: /api/reviews/{id}/react
      var response = await _dio.post(
        '/reviews/$reviewId/react',
        data: {'reaction': reactionType},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'نجاح',
          'تم تسجيل تفاعلك بنجاح',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل تسجيل التفاعل',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // 4. الإبلاغ عن التقييم
  Future<void> flagReview(int reviewId) async {
    try {
      // المسار بناءً على الـ Postman لديك: /api/reviews/{id}/flag
      var response = await _dio.post('/reviews/$reviewId/flag');
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'تنبيه',
          'تم رفع بلاغ ضد التقييم للمراجعة',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل إرسال البلاغ',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
