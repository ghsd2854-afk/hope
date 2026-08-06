import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';

class ReportController extends GetxController {
  var isLoading = false.obs;

  Future<void> submitReport({
    required String reportableType,
    required int reportableId,
    required String reason,
    required String details,
  }) async {
    try {
      isLoading.value = true;

      // استخدام DioService الجاهز لديكِ لإرسال الطلب مع التوكن تلقائياً
      await DioService().dio.post(
        ApiConstants.Report,
        data: {
          "reportable_type": reportableType,
          "reportable_id": reportableId,
          "reason": reason,
          "details": details,
        },
      );

      Get.back(); // إغلاق نافذة إدخال السبب
      Get.snackbar(
        "تم الإرسال",
        "شكراً لك، تم إرسال البلاغ بنجاح ومراجعته.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on DioException catch (e) {
      // التعامل مع أخطاء الـ API وإظهار رسالة واضحة إن وجدت
      String errorMessage = "حدث خطأ أثناء إرسال البلاغ، حاول مرة أخرى.";
      if (e.response != null && e.response?.data != null) {
        // إذا كان الـ Backend يرسل رسالة خطأ محددة
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }

      Get.snackbar(
        "خطأ",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "حدث خطأ غير متوقع.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
