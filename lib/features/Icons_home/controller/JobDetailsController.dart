import 'package:get/get.dart';
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';

import 'package:hobe/features/Icons_home/models/JobPostModel.dart';

class JobDetailsController extends GetxController {
  var isLoading = false.obs;
  Rxn<JobPostModel> jobDetails = Rxn<JobPostModel>();

  // دالة لجلب تفاصيل الوظيفة بناءً على الـ ID
  void fetchJobDetails(int jobId) async {
    try {
      isLoading.value = true;
      final response = await DioService().dio.get(
        ApiConstants.jobDetails(jobId),
      );

      if (response.statusCode == 200) {
        jobDetails.value = JobPostModel.fromJson(response.data);
      }
    } catch (e) {
      print("❌ خطأ في جلب تفاصيل الوظيفة: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
