import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';
import 'package:hobe/features/home/controllers/block_controller.dart';
import 'package:hobe/features/home/models/ProfileUserModel.dart';

class ProfileUserController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // استخدام كلاس البيانات الأساسي الذي يمثل ما بداخل مفتاح 'data'
  var profileData = Rxn<PublicProfileData>();

  var userId;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      userId = Get.arguments;

      int parsedId = int.tryParse(userId.toString()) ?? 0;
      if (parsedId != 0) {
        fetchPublicProfile(parsedId);
      }
    }
  }

  // داخل ملف block_controller.dar

  Future<void> fetchPublicProfile(int id) async {
    try {
      isLoading(true);
      errorMessage('');

      final response = await DioService().dio.get(
        ApiConstants.publicProfile(id),
      );

      if (response.statusCode == 200) {
        // 💡 التعديل الجوهري هنا: استخراج الـ data من استجابة السيرفر
        profileData.value = PublicProfileData.fromJson(response.data['data']);
        print("RAW RESPONSE: ${response.data}");
      }
    } catch (e) {
      if (e is dio.DioException && e.response?.statusCode == 404) {
        errorMessage.value = 'البروفايل غير موجود أو غير متاح.';
      } else if (e.toString().contains('404')) {
        errorMessage.value = 'البروفايل غير موجود أو غير متاح.';
      } else {
        errorMessage.value = 'حدث خطأ أثناء الاتصال بالخادم: $e';
      }
    } finally {
      isLoading(false);
    }
  }
}
