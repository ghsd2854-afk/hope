import 'package:get/get.dart';
import 'package:hobe/Notification/controller/NotificationController.dart';
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';
import 'package:hobe/features/Icons_home/models/CategoryModel.dart';
import 'package:hobe/features/Icons_home/models/JobPostModel.dart';
import 'package:hobe/features/Icons_home/models/post_model.dart';
import 'package:hobe/features/auth/controllers/profile_controller.dart';
import 'package:hobe/features/home/models/ActivityModel.dart';

class HomeController extends GetxController {
  var selectedFilter = 0.obs;
  var currentIndex = 1.obs;
  var isLoading = false.obs;
  var categories = <CategoryModel>[].obs;
  int? currentCategoryId;
  final NotificationController notificationController = Get.put(
    NotificationController(),
  );

  var posts = <PostModel>[
    PostModel(
      id: 2,
      title: "Marketing App",
      desc: "Looking for marketing expert",
    ),
  ].obs;
  var detailsList = <ActivityModel>[].obs;
  var currentTitle = ''.obs;

  @override
  void onInit() {
    super.onInit();
    notificationController.fetchUnreadCount();
    //  fetchCategories();
    fetchCategories();
    Get.put(ProfileController()).getProfile();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;

      // قمنا بإزالة queryParameters لجلب كل الفئات بكل أنواعها (job_type, sector, project_type...)
      final response = await DioService().dio.get(ApiConstants.getCategories);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        categories.value = data
            .map((json) => CategoryModel.fromJson(json))
            .toList();

        // [اختياري] هنا يمكنك تنفيذ دالة التجميع (Grouping) إذا كنتِ تريدين تقسيمها فور وصولها
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل جلب الفئات");
    } finally {
      isLoading.value = false;
    }
  }

  // متغير لتخزين الوظائف الخاصة بالفئة المحددة
  var selectedCategoryJobs = <JobPostModel>[].obs;
  var isJobsLoading = false.obs;

  // دوال جلب النشاطات الثلاثة
  Future<void> fetchReactions() async {
    currentTitle.value = "التفاعلات";
    await _fetchActivities(ApiConstants.activityReactions);
  }

  Future<void> fetchComments() async {
    currentTitle.value = "التعليقات";
    await _fetchActivities(ApiConstants.activityComments);
  }

  Future<void> fetchViews() async {
    currentTitle.value = "المشاهدات";
    await _fetchActivities(ApiConstants.activityViews);
  }

  Future<void> _fetchActivities(String endpoint) async {
    try {
      isLoading.value = true;
      detailsList.clear();

      final response = await DioService().dio.get(endpoint);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data is List
            ? response.data
            : response.data['data'];

        // استخدام ActivityModel.fromJson لحل المشكلة تماماً
        detailsList.value = data
            .map((json) => ActivityModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل في جلب البيانات: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void toggleLike(PostModel post) {
    post.isLiked = !post.isLiked;
    posts.refresh();
  }

  void toggleSave(PostModel post) {
    post.isSaved = !post.isSaved;
    posts.refresh();
  }

  void changeFilter(int index) {
    selectedFilter.value = index;
  }

  void ChangeIndex(int index) {
    currentIndex.value = index;
  }

  List<PostModel> get MyActivitiesPosts =>
      posts.where((p) => p.isLiked).toList();

  List<PostModel> get savedPosts => posts.where((p) => p.isSaved).toList();
}
