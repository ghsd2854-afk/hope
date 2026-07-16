import 'package:dio/dio.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:get/get.dart' hide FormData;
import 'package:hobe/features/Icons_home/models/JobPostModel.dart';
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';

class JobController extends GetxController {
  final _dio = DioService().dio;
  var jobPosts = <JobPostModel>[].obs;
  var isLoading = true.obs;
  var savedJobPosts = <JobPostModel>[].obs;
  var isSavedLoading = false.obs;
  var isSearching = false.obs;
  var isProcessing = false.obs;
  var allJobs = <JobPostModel>[].obs; // الوظائف الخام من السيرفر
  var filteredJobs = <JobPostModel>[].obs;
  var selectedJobFilter = 0.obs;
  String currentSearchQuery = ""; // تخزين نص البحث الحالي
  int currentCategoryId = 0;

  @override
  void onInit() {
    fetchJobs();
    super.onInit();
  }

  void filterJobsByCategory(int id) {
    currentCategoryId = id; // نحفظ الفئة المختارة في متغير
    applyFilters();
  }

  void applyFilters() {
    if (currentCategoryId == 0) {
      filteredJobs.assignAll(jobPosts);
    } else {
      filteredJobs.assignAll(
        jobPosts.where((job) => job.categoryId == currentCategoryId).toList(),
      );
    }
  }
  /* void filterJobsByCategory(int id) {
    if (id == 0) {
      filteredJobs.assignAll(jobPosts); // عرض الكل
    } else {
      // الفلترة بناءً على الـ categoryId الذي تأكدنا من وجوده في الموديل
      filteredJobs.assignAll(
        allJobs.where((job) => job.categoryId == id).toList(),
      );
    }
  }*/

  Future<void> fetchJobs() async {
    try {
      isLoading(true);
      final response = await _dio.get(ApiConstants.listJobs);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'] ?? [];
        List<JobPostModel> jobs = data.map((json) {
          return JobPostModel.fromJson(json);
        }).toList();
        jobPosts.assignAll(jobs); // تخزين النسخة الأصلية
        //     jobPosts.assignAll(jobs);
        filteredJobs.assignAll(jobs); // عرض الكل في البداية
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar("خطأ", "فشل جلب الوظائف");
    } finally {
      isLoading(false);
    }
  }

  void toggleFollow(int jobId) async {
    if (isProcessing.value) return;
    int index = jobPosts.indexWhere((j) => j.id == jobId);
    if (index == -1) return;
    int? companyId = jobPosts[index].company?.id;
    if (companyId == null) return;
    isProcessing.value = true;
    try {
      final response = await _dio.post(
        "${ApiConstants.followUnfollow}$companyId/toggle-follow",
      );
      if (response.statusCode == 200) {
        String message = response.data['message'] ?? "";
        bool isNowFollowed = (message == "followed");
        for (var job in jobPosts) {
          if (job.company?.id == companyId) {
            job.isFollowingCompany.value = isNowFollowed;
          }
        }
        for (var job in savedJobPosts) {
          if (job.company?.id == companyId) {
            job.isFollowingCompany.value = isNowFollowed;
          }
        }
        print(
          "✅ السيرفر أكد الحالة الجديدة: $message للشركة $companyId  ${response.data}",
        );
        // print("✅تم متابعة الشركة : $companyId");
      }
    } catch (e) {
      print("❌ خطأ: ${e.toString()}");
      Get.snackbar(
        "تنبيه",
        "فشل الاتصال بالسيرفر، يرجى المحاولة لاحقاً",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isProcessing.value = false;
    }
  }

  // الكود تبع التباع لكن بدون حلقة loop
  void toggleFolloww(int jobId) async {
    int index = jobPosts.indexWhere((j) => j.id == jobId);
    if (index == -1) return;

    int? companyId = jobPosts[index].company?.id;
    if (companyId == null) return;
    bool newState = !jobPosts[index].isFollowingCompany.value;
    try {
      final response = await _dio.post(
        "${ApiConstants.followUnfollow}$companyId/toggle-follow",
      );
      if (response.statusCode == 200) {
        for (var job in jobPosts) {
          if (job.company?.id == companyId) {
            job.isFollowingCompany.value =
                newState; // تحديث الحالة لكل الوظائف التابعة للشركة
          }
        }
        print(
          "✅ Success: Follow state updated for all jobs of company $companyId",
        );
        print("✅ Success: ${response.data}");
      }
    } catch (e) {
      print("❌ Error: ${e.toString()}");
      Get.snackbar("خطأ", "فشل تحديث حالة المتابعة");
    }
  }

  void applyToJob(int jobId) async {
    int index = jobPosts.indexWhere((j) => j.id == jobId);
    if (index == -1) return;
    var job = jobPosts[index];
    bool previousState = job.isApplied.value;
    if (previousState) {
      Get.snackbar("تنبيه", "لقد قمت بالتقديم على هذه الوظيفة مسبقاً");
      return;
    }
    job.isApplied.value = true;
    try {
      await _dio.post(ApiConstants.jobApply(jobId));
      Get.snackbar("نجاح", "تم تقديم طلبك للوظيفة بنجاح!");
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 409) {
        job.isApplied.value = true;
        Get.snackbar("تنبيه", "لقد قمت بالتقديم على هذه الوظيفة مسبقاً");
      } else {
        job.isApplied.value = previousState;
        Get.snackbar("خطأ", "فشل التقديم، يرجى التحقق من اتصالك");
      }
    }
  }

  Future<void> fetchSavedJobs() async {
    isSavedLoading.value = true;
    try {
      final response = await _dio.get("/me/saved-posts");
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;

        List<JobPostModel> processedList = data.map((json) {
          var newJob = JobPostModel.fromJson(json['post']);
          var existingJob = jobPosts.firstWhereOrNull((j) => j.id == newJob.id);

          if (existingJob != null) {
            existingJob.isSaved.value = true;
            return existingJob;
          } else {
            newJob.isSaved.value = true;
            return newJob;
          }
        }).toList();

        savedJobPosts.assignAll(processedList);
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل جلب المحفوظات");
    } finally {
      isSavedLoading.value = false;
    }
  }

  Future<void> toggleSave(JobPostModel job) async {
    bool newState = !job.isSaved.value;
    updateJobState(job.id, newState);
    try {
      await _dio.post("/saved-posts/toggle", data: {'job_post_id': job.id});
      if (!newState) {
        savedJobPosts.removeWhere((j) => j.id == job.id);
      } else {
        if (!savedJobPosts.any((j) => j.id == job.id)) {
          savedJobPosts.add(job);
        }
      }
    } catch (e) {
      updateJobState(job.id, !newState);
      Get.snackbar("خطأ", "فشل تحديث حالة الحفظ");
    }
  }

  void updateJobState(int jobId, bool isSaved) {
    final jobInMain = jobPosts.firstWhereOrNull((post) => post.id == jobId);
    if (jobInMain != null) {
      jobInMain.isSaved.value = isSaved;
    }
    final jobInSaved = savedJobPosts.firstWhereOrNull(
      (post) => post.id == jobId,
    );
    if (jobInSaved != null) {
      jobInSaved.isSaved.value = isSaved;
    }
    jobPosts.refresh();
    savedJobPosts.refresh();
  }

  Future<void> searchJobs(String query) async {
    print("DEBUG: searchJobs called with query: '$query'");
    EasyDebounce.cancel('search-jobs');
    if (query.isEmpty) {
      print("DEBUG: Query is empty, fetching all jobs.");
      fetchJobs();
      return;
    }
    EasyDebounce.debounce(
      'search-jobs',
      const Duration(milliseconds: 500),
      () async {
        isSearching.value = true;
        print("DEBUG: Executing API request for: '$query'");
        try {
          final response = await _dio.get(
            "/search",
            queryParameters: {'q': query},
          );

          if (response.statusCode == 200) {
            final List<dynamic> data = response.data['jobs'] ?? [];

            if (data.isEmpty) {
              print("DEBUG: No results found.");
              Get.snackbar(
                "تنبيه",
                "لا توجد وظائف تطابق بحثك حالياً",
                snackPosition: SnackPosition.BOTTOM,
              );
            } else {
              final List<JobPostModel> searchResults = data.map((json) {
                final newJob = JobPostModel.fromJson(json);
                return jobPosts.firstWhere(
                  (job) => job.id == newJob.id,
                  orElse: () => newJob,
                );
              }).toList();

              jobPosts.assignAll(searchResults);
              applyFilters();
              print("DEBUG: Search successful! Found ${jobPosts.length} jobs.");
            }
          } else {
            print(
              "DEBUG: Server returned non-200 status: ${response.statusCode}",
            );
          }
        } catch (e) {
          print("DEBUG: CRITICAL ERROR during search: $e");
        } finally {
          isSearching.value = false;
          print("DEBUG: Search process finished.");
        }
      },
    );
  }
}
