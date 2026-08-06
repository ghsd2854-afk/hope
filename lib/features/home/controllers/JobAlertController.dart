import 'package:get/get.dart';
// استيراد حزمة ديو صراحة مع إعطائها بادئة (prefix) لمنع أي تداخل
import 'package:dio/dio.dart' as dio_pkg;
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';
import 'package:hobe/features/home/models/JobAlertModel.dart';

class JobAlertController extends GetxController {
  var isLoading = false.obs;
  var jobAlertsList = <JobAlertModel>[].obs;

  // استخدام ديو الموحدة
  final dio = DioService().dio;

  @override
  void onInit() {
    super.onInit();
    fetchJobAlerts();
  }

  // 1. جلب قائمة التنبيهات (GET)
  void fetchJobAlerts() async {
    try {
      isLoading.value = true;
      // تحديد نوع الاستجابة الخاصة بـ dio_pkg لمنع خطأ التعارض
      dio_pkg.Response response = await dio.get(ApiConstants.jobAlerts);

      if (response.statusCode == 200) {
        // التحقق من أن البيانات قادمة بشكل صحيح كـ Map أو List
        var responseData = response.data;
        List data = responseData is Map
            ? (responseData['data'] ?? [])
            : responseData;

        jobAlertsList.value = data
            .map((e) => JobAlertModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "فشل تحميل التنبيهات: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // دالة تعديل تنبيه وظيفي
  // دالة تعديل تنبيه وظيفي
  Future<void> updateJobAlert(int id, JobAlertModel alertModel) async {
    try {
      isLoading.value = true;

      var response = await dio.post(
        '/job-alerts/$id',
        data: alertModel.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // إعادة جلب القائمة لتحديث البيانات بشكل صحيح
        fetchJobAlerts();

        Get.snackbar(
          "نجاح",
          "تم تحديث التنبيه الوظيفي بنجاح",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "حدث خطأ أثناء تحديث التنبيه: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 4. تفعيل أو تعطيل التنبيه (PATCH أو PUT حسب السيرفر)
  // دالة تفعيل أو إيقاف التنبيه
  Future<void> toggleAlertStatus(int id) async {
    try {
      isLoading.value = true;

      // تغيير نوع الطلب من patch إلى post ليتوافق مع إعدادات الباك إند
      var response = await dio.post('/job-alerts/$id/toggle');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // إعادة جلب القائمة لتحديث الحالة بصرياً
        fetchJobAlerts();

        Get.snackbar(
          "نجاح",
          "تم تغيير حالة التنبيه بنجاح",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "حدث خطأ أثناء تغيير الحالة: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 2. إنشاء تنبيه جديد (POST)
  Future<void> createJobAlert(JobAlertModel alertModel) async {
    try {
      isLoading.value = true;

      dio_pkg.Response response = await dio.post(
        ApiConstants.jobAlerts,
        data: alertModel.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "نجاح",
          "تم حفظ التنبيه بنجاح",
          snackPosition: SnackPosition.BOTTOM,
        );
        fetchJobAlerts();
      }
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "حدث خطأ أثناء حفظ التنبيه: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 3. حذف تنبيه (DELETE)
  Future<void> deleteJobAlert(int id) async {
    try {
      dio_pkg.Response response = await dio.delete(
        "${ApiConstants.jobAlerts}/$id",
      );
      if (response.statusCode == 200) {
        jobAlertsList.removeWhere((alert) => alert.id == id);
        Get.snackbar(
          "نجاح",
          "تم حذف التنبيه",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل الحذف: $e", snackPosition: SnackPosition.BOTTOM);
    }
  }
}
