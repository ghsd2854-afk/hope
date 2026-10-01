import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:dio/dio.dart' hide Headers;
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';
import 'package:hobe/features/Icons_home/controller/JobDetailsController.dart';
import 'package:hobe/features/home/models/MyApplicationsPaginatedModel.dart';
import 'package:hobe/features/home/models/WithdrawalModel.dart';

class MyApplicationsController extends GetxController {
  var isLoading = false.obs;
  // var applicationsList = <JobApplicationModel>[].obs;
  var applicationsList = <MyApplicationItemModel>[].obs;
  RxList<WithdrawalModel> withdrawalsList = <WithdrawalModel>[].obs;
  RxBool isLoadingWithdrawals = false.obs;
  // متغيرات التقديم
  var selectedFileName = ''.obs;
  var selectedFilePath = ''.obs;
  final TextEditingController coverLetterController = TextEditingController(
    text: '...',
  );

  @override
  void onInit() {
    super.onInit();
    fetchMyApplications();
  }

  Future<void> fetchMyApplications() async {
    try {
      isLoading.value = true;

      final response = await DioService().dio.get(ApiConstants.myApplications);

      if (response.statusCode == 200) {
        // استخدام المودل المستقل الخاص بالتابع
        final paginatedData = MyApplicationsPaginatedModel.fromJson(
          response.data,
        );

        // أسند القائمة للـ RxList بعد استبعاد الطلبات المسحوبة
        applicationsList.assignAll(
          paginatedData.applications
              .where((app) => app.status != 'withdrawn')
              .toList(),
        );
      }
    } catch (e) {
      print("Error fetching applications: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> withdrawApplication(
    int applicationId,
    String reasonCategory,
  ) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final response = await DioService().dio.post(
        '/applications/$applicationId/withdraw',
        data: {'reason_category': reasonCategory},
      );

      Get.back();

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'نجاح',
          'تم سحب الطلب بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
        );
        fetchMyApplications(); // تحديث القائمة
        if (Get.isRegistered<JobDetailsController>()) {
          final jobDetailsCtrl = Get.find<JobDetailsController>();
          // جلب الـ jobId للوظيفة الحالية المخزنة في الكنترولر وإعادة جلب تفاصيلها من السيرفر
          if (jobDetailsCtrl.jobDetails.value != null) {
            int currentJobId = jobDetailsCtrl.jobDetails.value!.id;
            jobDetailsCtrl.fetchJobDetails(currentJobId, forceRefresh: true);
          }
        }
      }
    } on DioException catch (e) {
      Get.back(); // إغلاق الـ Loading في حال الخطأ
      String errorMsg = e.response?.data['message'] ?? 'فشل سحب الطلب';
      Get.snackbar(
        'خطأ',
        errorMsg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
      );
    } catch (e) {
      Get.back();
      Get.snackbar(
        'خطأ',
        'حدث خطأ غير متوقع',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
      );
    }
  }

  Map<String, String> withdrawReasons = {};
  bool isLoadingReasons = false;

  Future<void> fetchWithdrawReasons() async {
    try {
      isLoadingReasons = true;
      update();

      final response = await DioService().dio.get(
        '/applications/withdraw/reasons',
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        Map<String, dynamic> data = response.data['data'];
        withdrawReasons = data.map(
          (key, value) => MapEntry(key, value.toString()),
        );
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تحميل أسباب الانسحاب');
    } finally {
      isLoadingReasons = false;
      update();
    }
  }

  // --- 3. دالة إرسال الطلب مع الـ CV ---
  Future<void> submitApplication(int jobId) async {
    if (selectedFilePath.value.isEmpty) {
      Get.snackbar(
        "تنبيه",
        "يرجى اختيار ملف السيرة الذاتية أولاً",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading(true);

      // تجهيز بيانات الفورم بالشكل الصحيح للـ Dio
      FormData formData = FormData.fromMap({
        'cover_letter': coverLetterController.text.trim(),
        'cv_file': await MultipartFile.fromFile(
          selectedFilePath.value,
          filename: selectedFileName.value,
        ),
      });

      final response = await DioService().dio.post(
        ApiConstants.jobApply(jobId),
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 1. إظهار رسالة نجاح خضراء احترافية
        Get.snackbar(
          "نجاح",
          "تم تقديم طلبك للوظيفة بنجاح!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        // 2. تفريغ الحقول والملفات لكي لا تبقى معلقة
        coverLetterController.clear();
        selectedFilePath.value = '';
        selectedFileName.value = '';

        // 3. تحديث القائمة والخروج من الصفحة
        fetchMyApplications();
        Get.back();
      }
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "فشل إرسال الطلب، يرجى المحاولة لاحقاً",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  // --- 2. دالة اختيار ملف الـ CV من الموبايل ---
  Future<void> pickCvFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.single.path != null) {
        selectedFilePath.value = result.files.single.path!;
        selectedFileName.value = result.files.single.name;
        Get.snackbar(
          "نجاح",
          "تم اختيار الملف: ${selectedFileName.value}",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "تنبيه",
          "لم يتم اختيار أي ملف",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "حدث خطأ أثناء اختيار الملف",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // دالة جلب سجل الانسحابات
  Future<void> fetchMyWithdrawals() async {
    try {
      isLoadingWithdrawals.value = true;
      final response = await DioService().dio.get('/applications/withdrawals');

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        List data = response.data['data'];
        withdrawalsList.value = data
            .map((e) => WithdrawalModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تحميل سجل الانسحابات');
    } finally {
      isLoadingWithdrawals.value = false;
    }
  }
}
