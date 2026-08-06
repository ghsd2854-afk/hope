import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart'; // تأکدي من استيراد حزمة ديو
import 'package:hobe/features/APIS/dio_services.dart'; // أو مسار الـ DioService لديكِ
import 'package:hobe/features/home/models/ComplaintModel.dart';

class ComplaintController extends GetxController {
  final TextEditingController complaintController = TextEditingController();
  var isLoading = false.obs;

  void submitComplaint(int targetId, String targetType) async {
    // 1. التحقق المحلي (اختياري ولكن يفضل لمنع الإرسال إذا كان النص فارغاً)
    if (complaintController.text.trim().isEmpty) {
      Get.snackbar(
        "تنبيه",
        "الرجاء كتابة تفاصيل الشكوى",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final complaintData = ComplaintModel(
        targetId: targetId,
        complaintText: complaintController.text.trim(),
        targetType: targetType,
      );

      // 2. إرسال الطلب للسيرفر
      await DioService().dio.post('/complaints', data: complaintData.toJson());

      Get.back(); // إغلاق نافذة الشكوى عند النجاح
      complaintController.clear();

      Get.snackbar(
        "نجاح",
        "تم إرسال الشكوى بنجاح، شكراً لتواصلك",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on DioException catch (e) {
      // 3. التقاط خطأ السيرفر (مثل خطأ 422 أو أي رسالة قادمة من الـ Backend)
      String errorMessage = "حدث خطأ ما، حاول مرة أخرى";

      if (e.response != null && e.response?.data != null) {
        // استخراج رسالة الخطأ الواردة من السيرفر تماماً
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }

      Get.snackbar(
        "تنبيه",
        errorMessage, // ستظهر هنا رسالة السيرفر (مثلاً: نص الشكوى يجب أن يكون 10 أحرف على الأقل)
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      // لأي أخطاء أخرى غير متوقعة
      Get.snackbar(
        "خطأ",
        "حدث خطأ غير متوقع",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    complaintController.dispose();
    super.onClose();
  }
}
