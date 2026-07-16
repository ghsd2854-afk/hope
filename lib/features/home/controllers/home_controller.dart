import 'package:get/get.dart';
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';
import 'package:hobe/features/Icons_home/models/CategoryModel.dart';
import 'package:hobe/features/Icons_home/models/post_model.dart';

class HomeController extends GetxController {
  var selectedFilter = 0.obs;
  var currentIndex = 0.obs;
  var isLoading = false.obs;
  var categories = <CategoryModel>[].obs;

  var posts = <PostModel>[
    PostModel(
      id: 2,
      title: "Marketing App",
      desc: "Looking for marketing expert",
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();

    fetchCategories(); // تأكدي أن هذا السطر موجود ويعمل!
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final response = await DioService().dio.get(
        ApiConstants.getCategories,
        queryParameters: {'type': 'job_type'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        categories.value = data
            .map((json) => CategoryModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل جلب الفئات");
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
