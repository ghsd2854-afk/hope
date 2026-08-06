import 'dart:developer';
import 'package:get/get.dart';
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';
import 'package:hobe/features/home/models/JobApplicationModel.dart';

class MyApplicationsController extends GetxController {
  var isLoading = false.obs;
  var applicationsList = <JobApplicationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyApplications();
  }

  void fetchMyApplications() async {
    try {
      isLoading(true);

      print('==================================================');
      print(
        '🚀 [API Request] جاري جلب طلبات التوظيف من: ${ApiConstants.baseUrl}${ApiConstants.myApplications}',
      );
      print('==================================================');

      // استخدام DioService المشترك في مشروعك (يقوم بحقن الـ Token تلقائياً عبر الـ Interceptor)
      final response = await DioService().dio.get(ApiConstants.myApplications);

      print('📥 [API Response Status Code]: ${response.statusCode}');
      print('📦 [API Response Body]: ${response.data}');

      if (response.statusCode == 200) {
        var jsonResponse = response.data;

        ApplicationResponse appResponse = ApplicationResponse.fromJson(
          jsonResponse,
        );

        if (appResponse.data != null &&
            appResponse.data!.applications != null) {
          applicationsList.value = appResponse.data!.applications!;

          print('✅ [Success] تم ربط الباك إند بنجاح وجلب البيانات!');
          print('📊 عدد الطلبات المستلمة: ${applicationsList.length}');
        } else {
          print('⚠️ [Warning] البيانات المستلمة فارغة أو البنية مختلفة.');
        }
      } else {
        print('❌ [Error] فشل الطلب برمز استجابة: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('🔥 [Exception Error caught]: $e');
      log('StackTrace: $stackTrace');
    } finally {
      isLoading(false);
      print('🏁 [Process Ended] انتهى تنفيذ طلب جلب الطلبات.');
      print('==================================================');
    }
  }
}
