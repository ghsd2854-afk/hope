import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';
import 'package:hobe/features/Icons_home/models/JobPostModel.dart';
import 'package:hobe/features/Icons_home/models/ReactionModel.dart';

class ReactionController extends GetxController {
  var isReactionLoading = false.obs;
  var currentReactionType = ''.obs;
  var allReactions = <ReactionModel>[].obs;
  var totalReactionsCount = 0.obs;
  int lastFetchedPostId = -1;
  var isLoading = false.obs;
  var reactionStats = Rxn<StatsResponse>();
  var reactionsCounts = <int, int>{}.obs;
  var postReactionStats = <int, Map<String, int>>{}.obs;
  var userReactionStatus = <int, bool>{}.obs;
  var userReactionTypes = <int, String?>{}.obs;

  Future<void> addReaction(JobPostModel job, String type) async {
    try {
      final dio = DioService().dio;
      final response = await dio.post(
        "/posts/${job.id}/react",
        data: {'type': type},
      );
      if (response.statusCode == 200) {
        job.reactionsCount.value = response.data['total_reactions'];
        job.reactionIcons.assignAll(
          List<String>.from(response.data['reaction_icons']),
        );
        job.isReacted.value = true;
        job.reactionType.value = type;
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل التفاعل");
    }
  }

  Future<void> deleteReaction(int postId, JobPostModel job) async {
    try {
      final dio = DioService().dio;
      print("🗑️ Sending Delete Request to Server for Post ID: $postId");
      final response = await dio.delete("${ApiConstants.jobLike}$postId/react");
      if (response.statusCode == 200) {
        job.reactionsCount.value = response.data['total_reactions'] ?? 0;
        job.reactionIcons.assignAll(
          List<String>.from(response.data['reaction_icons'] ?? []),
        );
        job.isReacted.value = false;
        job.reactionType.value = null;
        print("🗑️ تم تحديث الواجهة محلياً بعد حذف التفاعل!");
      }
    } catch (e) {
      print("❌ Error deleting reaction: $e");
      Get.snackbar("خطأ", "فشل حذف التفاعل");
    }
  }

  Future<void> getAllReactions(int postId) async {
    if (lastFetchedPostId == postId && allReactions.isNotEmpty) return;

    isLoading.value = true;
    try {
      final dio = DioService().dio;
      final response = await dio.get(
        "${ApiConstants.jobLike}$postId/reactions",
      );
      if (response.statusCode == 200) {
        lastFetchedPostId = postId;
        ViewAllResponse result = ViewAllResponse.fromJson(response.data);
        allReactions.value = result.users;
        print("✅ تم جلب ${allReactions.length} تفاعل");
      }
    } catch (e) {
      print("❌ خطأ جلب التفاعلات: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getStats(int postId) async {
    try {
      final dio = DioService().dio;
      final response = await dio.get(
        "${ApiConstants.jobLike}$postId/reactions/stats",
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['reactions'] != null && data['reactions'] is Map) {
          StatsResponse stats = StatsResponse.fromJson(data);
          reactionStats.value = stats;
          Map<String, int> countsMap = {};
          stats.reactions.forEach((key, group) {
            countsMap[key] = group.count;
          });
          postReactionStats[postId] = countsMap;
        } else {
          reactionStats.value = StatsResponse(total: 0, reactions: {});
          postReactionStats[postId] = {};
        }
      }
    } catch (e) {
      print("❌ خطأ في الإحصائيات: $e");
    }
  }

  Widget getIconWidget(String? reactionType) {
    switch (reactionType?.toLowerCase()) {
      case 'love':
        return const Text('❤️', style: TextStyle(fontSize: 18));
      case 'support':
        return const Text('🤝', style: TextStyle(fontSize: 18));
      case 'insightful':
        return const Text('💡', style: TextStyle(fontSize: 18));
      case 'like':
        return const Text('👍', style: TextStyle(fontSize: 18));
      default:
        return const Icon(
          Icons.thumb_up_outlined,
          size: 20,
          color: Colors.grey,
        );
    }
  }

  String getIconString(String type) {
    const Map<String, String> iconsMap = {
      'love': '❤️',
      'support': '🤝',
      'like': '👍',
      'insightful': '💡',
    };
    return iconsMap[type.toLowerCase()] ?? '❓';
  }

  String getIconsStringFromStats(List<String> stats) {
    String icons = "";
    for (var type in stats) {
      if (type == 'like')
        icons += '👍';
      else if (type == 'love')
        icons += '❤️';
      else if (type == 'support')
        icons += '🤝';
      else if (type == 'insightful')
        icons += '💡';
    }
    return icons;
  }

  Future<void> getTotalReactionsCount(int postId) async {
    try {
      final dio = DioService().dio;
      final response = await dio.get(
        "${ApiConstants.jobLike}$postId/reactions/total",
      );

      if (response.statusCode == 200) {
        reactionsCounts[postId] = response.data['total'] ?? 0;
      }
    } catch (e) {
      print("❌ خطأ في العدد الكلي: $e");
    }
  }

  void resetReactionData() {
    allReactions.clear();
    reactionStats.value = null;
    lastFetchedPostId = -1;
    print("🧹 تم تصفير بيانات التفاعلات السابقة");
  }
}
