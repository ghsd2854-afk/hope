import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:hobe/app_routes.dart';
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';
import 'package:hobe/features/Icons_home/models/JobPostModel.dart';
import 'package:hobe/features/profiles/controller/cvfiles_controller.dart';

class JobDetailsController extends GetxController {
  var isLoading = false.obs;
  Rxn<JobPostModel> jobDetails = Rxn<JobPostModel>();
  late int jobId;
  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      jobId = Get.arguments is int
          ? Get.arguments
          : int.parse(Get.arguments.toString());
      fetchJobDetails(jobId);
    }
  }

  void fetchJobDetails(int jobId) async {
    if (jobDetails.value != null) return;

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

  void applyToJob(JobPostModel job, {String? selectedCvFileId}) async {
    print("🚀 تم الضغط على زر التقديم للوظيفة رقم: ${job.id}");
    bool previousState = job.isApplied.value;

    if (previousState) {
      Get.snackbar("تنبيه", "لقد قمت بالتقديم على هذه الوظيفة مسبقاً");
      return;
    }
    bool hasCv = false;
    try {
      final cvFilesController = Get.isRegistered<CvFilesController>()
          ? Get.find<CvFilesController>()
          : Get.put(CvFilesController());

      if (cvFilesController.files.isEmpty) {
        await cvFilesController.fetchFiles();
      }

      if (cvFilesController.files.isNotEmpty) {
        hasCv = true;
      }
    } catch (e) {
      hasCv = false;
    }
    if (!hasCv) {
      Get.snackbar(
        "تنبيه مطلوب",
        "يجب إدخال أو رفع السيرة الذاتية (CV) قبل التقديم على الوظائف",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );

      // التوجيه باستخدام الثابت الموجود في AppRoutes
      Get.toNamed(AppRoutes.cvUpload);
      return;
    }
    try {
      FormData formData = FormData.fromMap({
        'cover_letter': 'am interested in this position because...',
      });

      job.isApplied.value = true;

      await DioService().dio.post(
        ApiConstants.jobApply(job.id),
        data: formData,
      );

      Get.snackbar("نجاح", "تم تقديم طلبك للوظيفة بنجاح!");
    } catch (e) {
      job.isApplied.value = previousState;

      if (e is DioException) {
        if (e.response?.statusCode == 409) {
          job.isApplied.value = true;
          Get.snackbar("تنبيه", "لقد قمت بالتقديم على هذه الوظيفة مسبقاً");
        } else if (e.response?.statusCode == 422) {
          String message =
              e.response?.data['message'] ??
              "يجب إكمال بيانات السيرة الذاتية أو رفع ملف قبل التقديم";
          Get.snackbar(
            "تنبيه",
            message,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );

          Get.toNamed(AppRoutes.cvUpload);
        } else {
          Get.snackbar("خطأ", "فشل التقديم، يرجى التحقق من اتصالك");
        }
      } else {
        Get.snackbar("خطأ", "حدث خطأ غير متوقع");
      }
    }
  }
}
