import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio_pkg;
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';
import 'package:hobe/app_routes.dart';
import 'package:hobe/features/home/controllers/MyProjectsController.dart';
import 'package:hobe/features/home/controllers/home_controller.dart'; // تأکدي من مسار الـ HomeController الصحيح

class AddProjectController extends GetxController {
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

  bool isEditing = false;
  int? projectId;

  var suggestedCompanies = <Map<String, dynamic>>[].obs;
  var selectedCompanyIds = <int>[].obs;
  int? newlyCreatedProjectId;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      var project = Get.arguments;
      isEditing = true;
      projectId = project.id;

      titleController.text = project.title ?? '';
      summaryController.text = project.summary ?? '';
      descController.text = project.description ?? '';
      fundingGoalController.text = project.fundingGoal?.toString() ?? '';
      locationController.text = project.location ?? '';
      websiteUrlController.text = project.websiteUrl ?? '';

      if (project.category != null && project.category.isNotEmpty) {
        selectedCategory.value = project.category;
      }
      if (project.stage != null && project.stage.isNotEmpty) {
        selectedStage.value = project.stage;
      }
    }
  }

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

  void clearForm() {
    titleController.clear();
    summaryController.clear();
    descController.clear();
    fundingGoalController.clear();
    locationController.clear();
    websiteUrlController.clear();

    selectedCategory.value = 'tech';
    selectedStage.value = 'idea';
    isFunding.value = false;
    isMentorship.value = false;
    suggestedCompanies.clear();
    selectedCompanyIds.clear();
    newlyCreatedProjectId = null;
  }

  void submitProject() async {
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

      List<String> supportTypesList = [];
      if (isFunding.value) supportTypesList.add('funding');
      if (isMentorship.value) supportTypesList.add('mentoring');

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

      for (int i = 0; i < supportTypesList.length; i++) {
        formData.fields.add(MapEntry('support_types[$i]', supportTypesList[i]));
      }

      final dioInstance = DioService().dio;
      dio_pkg.Response response;

      if (isEditing) {
        String url = ApiConstants.updateStartupProject(projectId!);
        response = await dioInstance.post(url, data: formData);
      } else {
        response = await dioInstance.post(
          ApiConstants.createStartupProject,
          data: formData,
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;

        if (!isEditing && responseData is Map) {
          newlyCreatedProjectId =
              responseData['id'] ?? responseData['data']?['id'];

          if (responseData['suggested_companies'] != null) {
            suggestedCompanies.assignAll(
              List<Map<String, dynamic>>.from(
                responseData['suggested_companies'],
              ),
            );

            if (suggestedCompanies.isNotEmpty) {
              showSuggestedCompaniesBottomSheet();
              return;
            }
          }
        }

        if (isEditing) {
          clearForm();
          Get.snackbar(
            "نجاح",
            "تم تعديل المشروع بنجاح",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );

          await Future.delayed(const Duration(milliseconds: 1500));
          Get.back(result: responseData);
          return;
        }

        clearForm();
        Get.snackbar(
          "نجاح",
          "تم نشر المشروع بنجاح",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        await Future.delayed(const Duration(milliseconds: 1500));

        if (Get.isRegistered<MyProjectsController>()) {
          Get.find<MyProjectsController>().fetchMyProjects();
        }

        // --- التعديل هنا: العودة للرئيسية وتفعيل تبويب مشاريعي (رقم 2) ---
        Get.until((route) => Get.currentRoute == AppRoutes.home);
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().currentIndex.value = 2;
        }
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

  void showSuggestedCompaniesBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        height: Get.height * 0.5,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const Text(
              "الشركات المقترحة",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: suggestedCompanies.length,
                itemBuilder: (context, index) {
                  var company = suggestedCompanies[index];
                  int companyId = company['id'];

                  return Obx(() {
                    bool isSelected = selectedCompanyIds.contains(companyId);
                    return CheckboxListTile(
                      title: Text(company['company_name'] ?? ''),
                      subtitle: Text(company['category'] ?? ''),
                      value: isSelected,
                      onChanged: (bool? value) {
                        if (value == true) {
                          selectedCompanyIds.add(companyId);
                        } else {
                          selectedCompanyIds.remove(companyId);
                        }
                      },
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  sendInvitationsToCompanies();
                },
                child: const Text("دعوة الشركات المختارة"),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      isDismissible: false,
    );
  }

  void sendInvitationsToCompanies() async {
    if (selectedCompanyIds.isEmpty) {
      Get.snackbar(
        "تنبيه",
        "الرجاء اختيار شركة واحدة على الأقل",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (newlyCreatedProjectId == null) {
      Get.snackbar(
        "خطأ",
        "معرف المشروع غير متوفر",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      dio_pkg.FormData formData = dio_pkg.FormData();
      for (int i = 0; i < selectedCompanyIds.length; i++) {
        formData.fields.add(
          MapEntry('company_ids[$i]', selectedCompanyIds[i].toString()),
        );
      }

      final dioInstance = DioService().dio;
      String url = ApiConstants.inviteCompaniesToProject(
        newlyCreatedProjectId!,
      );

      final response = await dioInstance.post(url, data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (Get.isBottomSheetOpen ?? false) {
          Get.back();
        }

        clearForm();

        Get.snackbar(
          "نجاح",
          "تم إرسال الدعوات ونشر المشروع بنجاح",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );

        await Future.delayed(const Duration(seconds: 2));

        if (Get.isRegistered<MyProjectsController>()) {
          Get.find<MyProjectsController>().fetchMyProjects();
        }

        // --- التعديل هنا: العودة للرئيسية وتفعيل تبويب مشاريعي (رقم 2) ---
        Get.until((route) => Get.currentRoute == AppRoutes.home);
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().currentIndex.value = 2;
        }
      } else {
        Get.snackbar(
          "خطأ",
          "فشل إرسال الدعوات",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on dio_pkg.DioException catch (e) {
      String errorMessage =
          e.response?.data['message'] ?? "حدث خطأ أثناء إرسال الدعوات";
      Get.snackbar(
        "خطأ",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "حدث غير متوقع: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
