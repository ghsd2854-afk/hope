import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio_pkg;
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';

class AddProjectController extends GetxController {
  // جميع الحقول أصبحت جاهزة لاستقبال مدخلات المستخدم
  final titleController = TextEditingController();
  final summaryController = TextEditingController();
  final descController = TextEditingController();
  final fundingGoalController = TextEditingController();
  final locationController = TextEditingController();
  final websiteUrlController = TextEditingController();

  var selectedCategory = 'tech'.obs;
  var selectedStage = 'idea'.obs;
  var isFunding = false.obs;
  var isMentorship = false.obs;
  var isLoading = false.obs;

  @override
  void onClose() {
    titleController.dispose();
    summaryController.dispose();
    descController.dispose();
    fundingGoalController.dispose();
    locationController.dispose();
    websiteUrlController.dispose();
    super.onClose();
  }

  void submitProject() async {
    // التحقق البسيط من الحقول الإجبارية
    if (titleController.text.isEmpty || descController.text.isEmpty) {
      Get.snackbar(
        "تنبيه",
        "الرجاء تعبئة الحقول الأساسية على الأقل",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      // تجهيز الأنواع المطلوبة (support_types) بناءً على ما يحدده المستخدم
      List<String> supportTypesList = [];
      if (isFunding.value) supportTypesList.add('funding');
      if (isMentorship.value) supportTypesList.add('mentoring');

      // تعبئة البيانات المرسلة من إدخالات المستخدم الحقيقية لتطابق البوستمان تماماً
      dio_pkg.FormData formData = dio_pkg.FormData.fromMap({
        'title': titleController.text,
        'summary': summaryController.text,
        'description': descController.text,
        'stage': selectedStage.value,
        'category': selectedCategory.value,
        'funding_goal': fundingGoalController.text,
        'location': locationController.text,
        'website_url': websiteUrlController.text,
      });

      // إضافة مصفوفة support_types بالشكل المتوافق مع Laravel form-data
      for (int i = 0; i < supportTypesList.length; i++) {
        formData.fields.add(MapEntry('support_types[$i]', supportTypesList[i]));
      }

      // إرسال الطلب عبر Dio واستخدام التوكن تلقائياً من الـ Interceptor
      final dioInstance = DioService().dio;

      final response = await dioInstance.post(
        ApiConstants.createStartupProject,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "نجاح",
          "تم نشر المشروع بنجاح",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.back();
      } else {
        Get.snackbar(
          "خطأ",
          "فشل في إرسال البيانات: ${response.statusCode}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on dio_pkg.DioException catch (e) {
      String errorMessage =
          e.response?.data['message'] ?? "حدث خطأ في الاتصال بالخادم";
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
}
