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
  var allJobs = <JobPostModel>[].obs;
  var filteredJobs = <JobPostModel>[].obs;
  var selectedJobFilter = 0.obs;
  String currentSearchQuery = "";
  int currentCategoryId = 0;
  int currentPage = 1;
  bool hasMoreData = true;
  // int? currentCategoryId;
  var selectedCategoryJobs = <JobPostModel>[].obs;
  var isJobsLoading = false.obs;
  @override
  void onInit() {
    fetchJobs();
    super.onInit();
  }

  // داخل JobController.dart

  /* void filterJobsByCategory(int id) {
    currentCategoryId = id;
    applyFilters();
  }*/

  void applyFilters() {
    if (currentCategoryId == 0) {
      filteredJobs.assignAll(jobPosts);
    } else {
      filteredJobs.assignAll(
        jobPosts.where((job) => job.categoryId == currentCategoryId).toList(),
      );
    }
  }

  Future<void> fetchJobsByCategory(
    int categoryId, {
    bool isLoadMore = false,
  }) async {
    if (!isLoadMore) {
      currentPage = 1;
      hasMoreData = true;
      currentCategoryId = categoryId;
      filteredJobs.clear();
    } else {
      if (!hasMoreData || isJobsLoading.value) return;
      currentPage++;
    }

    try {
      isJobsLoading.value = true;
      String endpoint = categoryId == 0
          ? 'jobs?page=$currentPage'
          : '/categories/$categoryId?page=$currentPage';

      final response = await DioService().dio.get(endpoint);
      var jobsData = categoryId == 0
          ? response.data['data']
          : response.data['data']['jobs']['data'];

      List<JobPostModel> newJobs = (jobsData as List)
          .map((json) => JobPostModel.fromJson(json))
          .toList();

      if (newJobs.isEmpty) {
        hasMoreData = false;
      } else {
        filteredJobs.addAll(newJobs);
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل جلب المزيد من الوظائف");
    } finally {
      isJobsLoading.value = false;
    }
  }

  void loadMoreJobs() {
    if (currentCategoryId == null || currentCategoryId == 0) {
      fetchJobs(isLoadMore: true);
    } else {
      fetchJobsByCategory(currentCategoryId!, isLoadMore: true);
    }
  }

  Future<void> fetchJobs({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      currentPage = 1;
      hasMoreData = true;
      filteredJobs.clear();
    } else {
      if (!hasMoreData || isJobsLoading.value) return;
      currentPage++;
    }

    try {
      isJobsLoading.value = true;
      if (!isLoadMore) isLoading(true);

      final response = await _dio.get(
        '${ApiConstants.listJobs}?page=$currentPage',
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'] ?? [];

        List<JobPostModel> newJobs = data.map((json) {
          return JobPostModel.fromJson(json);
        }).toList();

        if (newJobs.isEmpty) {
          hasMoreData = false;
        } else {
          if (!isLoadMore) {
            jobPosts.assignAll(newJobs);
            filteredJobs.assignAll(newJobs);
          } else {
            jobPosts.addAll(newJobs);
            filteredJobs.addAll(newJobs);
          }
        }
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar("خطأ", "فشل جلب الوظائف");
    } finally {
      isLoading(false);
      isJobsLoading.value = false;
    }
  }

  Future<JobPostModel?> fetchJobDetails(int jobId) async {
    try {
      var existingJob = jobPosts.firstWhereOrNull((j) => j.id == jobId);
      if (existingJob != null) return existingJob;

      // إذا لم تكن موجودة، يمكنك جلبها من السيرفر (حسب مسار الـ API لديك، مثلاً /jobs/{id})
      final response = await _dio.get("${ApiConstants.listJobs}/$jobId");
      if (response.statusCode == 200) {
        return JobPostModel.fromJson(response.data['data'] ?? response.data);
      }
    } catch (e) {
      print("Error fetching job details: $e");
    }
    return null;
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

  /*void applyToJob(int jobId, {String? selectedCvFileId}) async {
    int index = jobPosts.indexWhere((j) => j.id == jobId);
    if (index == -1) return;
    var job = jobPosts[index];
    bool previousState = job.isApplied.value;

    if (previousState) {
      Get.snackbar("تنبيه", "لقد قمت بالتقديم على هذه الوظيفة مسبقاً");
      return;
    }

    // 1. التحقق مما إذا كان لدى المستخدم ملفات CV مدخلة/مرفوعة مسبقاً
    // يمكنك استدعاء الـ CvFilesController أو التحقق من قاعدة البيانات المحلية / المتغيرات لديك
    bool hasCv = false;

    try {
      // محاولة جلب الملفات للتأكد من وجود سيرة ذاتية مسجلة
      final cvFilesController = Get.isRegistered<CvFilesController>()
          ? Get.find<CvFilesController>()
          : Get.put(CvFilesController());

      // تحديث القائمة إن لم تكن محملة
      if (cvFilesController.files.isEmpty) {
        await cvFilesController.fetchFiles();
      }

      if (cvFilesController.files.isNotEmpty) {
        hasCv = true;
      }
    } catch (e) {
      hasCv = false;
    }

    // 2. إذا لم يكن لديه CV، امنع الطلب ونبهه ليقوم بإدخاله
    if (!hasCv) {
      Get.snackbar(
        "تنبيه مطلوب",
        "يجب إدخال أو رفع السيرة الذاتية (CV) قبل التقديم على الوظائف",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );

      // توجيه المستخدم لصفحة ملفات الـ CV أو إنشائها
      Get.toNamed('/cv-files'); // أو الشاشة الخاصة برفع الـ CV لديك
      return;
    }

    // 3. إذا كان الـ CV موجوداً، يتابع النظام الإرسال تلقائياً
    try {
      // استخدام أول ملف متوفر أو الملف المحدد تلقائياً
      // (أو إرسال البيانات بالطريقة التي يطلبها الـ API لديك)
      FormData formData = FormData.fromMap({
        'cover_letter': 'am interested in this position because...',
        // 'cv_file_id': selectedCvFileId ?? ... إذا كان الـ API يطلب معرف الـ CV المخزن
      });

      job.isApplied.value = true;

      await _dio.post(ApiConstants.jobApply(jobId), data: formData);

      Get.snackbar("نجاح", "تم تقديم طلبك للوظيفة بنجاح!");
    } catch (e) {
      job.isApplied.value = previousState; // إرجاع الحالة السابقة عند الفشل

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
          // في حال رد السيرفر بـ 422 لعدم وجود ملف، نقوم بتوجيهه لصفحة الـ CV أيضاً:
          Get.toNamed('/cv-files');
        } else {
          Get.snackbar("خطأ", "فشل التقديم، يرجى التحقق من اتصالك");
        }
      } else {
        Get.snackbar("خطأ", "حدث خطأ غير متوقع");
      }
    }
  }*/

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

  void toggleJobExpansion(JobPostModel job) async {
    job.isExpanded.toggle();
    print(
      "🖱️ تم الضغط على زر المزيد للوظيفة ID: ${job.id} | حالة التوسيع: ${job.isExpanded.value}",
    );

    if (job.isExpanded.value) {
      print(
        "⏳ جاري إرسال طلب للسيرفر لتسجيل المشاهدة للوظيفة رقم ${job.id}...",
      );
      try {
        // استدعي طلب الـ GET الخاص بالتفاصيل هنا إن وجد، أو اتركه ليقوم الباك إند بتسجيله تلقائياً
        //final response = await DioService().dio.get('/jobs/${job.id}');
        print("✅ تم تسجيل المشاهدة بنجاح للسيرفر!");
      } catch (e) {
        print("❌ حدث خطأ: $e");
      }
    }
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
