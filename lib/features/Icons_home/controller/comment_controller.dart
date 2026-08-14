import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hobe/features/APIS/dio_services.dart';
import 'package:hobe/features/Icons_home/controller/JobController.dart';

import 'package:hobe/features/Icons_home/models/comment_model.dart';

class CommentController extends GetxController {
  final Dio _dio = DioService().dio;
  final box = GetStorage();

  var comments = <CommentModel>[].obs;

  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  int currentPage = 1;
  bool hasMore = true;
  late ScrollController scrollController;
  String? tag;
  int? postId;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    //  scrollController.addListener(
    //   _scrollListener,
    // ); // ربط المراقب عند بدء الـ Controller
    fetchPublicProfile();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
    print("🧹 تم تنظيف الذاكرة للـ Controller ذو الـ tag: $tag");
  }

  //هاد التعديل ازبطو بعدين  عشان تكرار الاستدعاء
  /* void initController(int id) {
    // 🛑 إذا كان الـ Controller مهيأ مسبقاً لنفس المنشور، لا تكرر الطلب أبداً
    if (postId == id) return;

    postId = id;

    // ربط المراقب مرة واحدة فقط
    if (!scrollController.hasListeners) {
      scrollController.addListener(_scrollListener);
    }

    fetchComments(id);
  }*/
  void initController(int id) {
    if (postId == null) {
      postId = id;
      scrollController.addListener(_scrollListener);
      // initScrollListener(id); // ربط التمرير مع الـ postId الصحيح
      fetchComments(id); // جلب الصفحة الأولى للتعليقات فوراً
    }
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (!isLoadingMore.value && hasMore && postId != null) {
        loadMoreComments(postId!);
      }
    }
  }

  Future<void> fetchComments(int postId) async {
    print("🔍 جاري جلب الصفحة الأولى للتعليقات للمنشور رقم: $postId");

    try {
      isLoading(true);
      currentPage = 1;
      hasMore = true;
      final response = await _dio.get(
        "/posts/$postId/comments?page=$currentPage",
      );

      if (response.statusCode == 200) {
        List<dynamic> commentsJson = response.data['data'];

        comments.value = commentsJson
            .map((e) => CommentModel.fromJson(e))
            .toList();

        if (response.data['next_page_url'] == null || commentsJson.isEmpty) {
          hasMore = false;
        }

        print("✅ تم جلب الصفحة الأولى بنجاح!");
      }
    } catch (e) {
      print("❌ خطأ في جلب التعليقات: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadMoreComments(int postId) async {
    if (isLoadingMore.value || !hasMore) return;

    try {
      isLoadingMore(true);
      currentPage++;

      print("📄 جاري جلب الصفحة رقم: $currentPage");
      final response = await _dio.get(
        "/posts/$postId/comments?page=$currentPage",
      );

      if (response.statusCode == 200) {
        List<dynamic> commentsJson = response.data['data'];

        if (commentsJson.isEmpty || response.data['next_page_url'] == null) {
          hasMore = false;
        }

        List<CommentModel> moreComments = commentsJson
            .map((e) => CommentModel.fromJson(e))
            .toList();

        comments.addAll(moreComments);
        print("✅ تم إضافة المزيد من التعليقات بنجاح");
      }
    } catch (e) {
      print("❌ خطأ في جلب المزيد: $e");
      currentPage--;
    } finally {
      isLoadingMore(false);
    }
  }

  void initScrollListener(int postId) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        if (!isLoadingMore.value && hasMore) {
          loadMoreComments(postId);
        }
      }
    });
  }

  CommentModel? findCommentById(List<CommentModel> list, int id) {
    for (var comment in list) {
      if (comment.id == id) return comment;

      var foundInReplies = findCommentById(comment.replies, id);

      if (foundInReplies != null) return foundInReplies;
    }

    return null;
  }

  Future<void> addComment(int postId, String content) async {
    try {
      print("🚀 [CommentController] جاري إضافة تعليق...");
      final response = await _dio.post(
        "/posts/$postId/comments",
        data: {"content": content},
      );

      if (response.statusCode == 200) {
        print(
          "✅ [CommentController] تم إضافة التعليق، الحالة: ${response.statusCode}",
        );
        final responseData = response.data['data'];

        CommentModel newComment = CommentModel.fromJson(responseData);
        comments.insert(0, newComment);
        try {
          final JobController jobController = Get.find<JobController>();
          var post = jobController.jobPosts.firstWhere((p) => p.id == postId);
          post.commentsCount.value++;
        } catch (e) {
          print("⚠️ لم يتم العثور على المنشور لتحديث العداد محلياً: $e");
        }

        print("✅ تم تحديث عداد التعليقات وعرضه بالواجهة");
      }
    } catch (e) {
      print("❌ خطأ أثناء إضافة التعليق: $e");
    }
  }

  Future<void> addReply(int postId, int parentId, String content) async {
    try {
      print("🚀 [CommentController: $tag] جاري إضافة رد للتعليق: $parentId...");

      final response = await _dio.post(
        "/posts/$postId/comments/reply",
        data: {"content": content, "parent_id": parentId},
      );

      await fetchComments(postId);

      var parent = findCommentById(comments, parentId);

      if (parent != null) {
        parent.isExpanded.value = true;
      }
      final JobController jobController = Get.find<JobController>();
      var post = jobController.jobPosts.firstWhere((p) => p.id == postId);
      post.commentsCount.value++;
    } catch (e) {
      print("❌ [CommentController: $tag] خطأ: $e");
    }
  }

  Future<void> updateComment(
    int commentId,
    int postId,
    String newContent,
  ) async {
    try {
      final response = await DioService().dio.post(
        '/comments/$commentId',
        data: {'content': newContent},
      );

      if (response.statusCode == 200) {
        var targetComment = findCommentById(comments, commentId);
        if (targetComment != null) {
          targetComment.content = newContent;
          comments.refresh();
          print("✅ تم تعديل التعليق/الرد وتحديث الواجهة محلياً");
        }
      }
    } catch (e) {
      print("❌ خطأ: $e");
    }
  }

  Future<void> deleteComment(int commentId, int postId) async {
    try {
      final response = await _dio.delete("/comments/$commentId");

      if (response.statusCode == 200) {
        bool removed = _recursiveRemove(comments, commentId);

        if (removed) {
          final JobController jobController = Get.find<JobController>();
          var post = jobController.jobPosts.firstWhere((p) => p.id == postId);
          post.commentsCount.value--;

          comments.refresh();
        }
        print("✅ تم الحذف وتحديث الواجهة محلياً");
      }
    } catch (e) {
      print("❌ خطأ: $e");
    }
  }

  bool _recursiveRemove(List<CommentModel> list, int id) {
    for (int i = 0; i < list.length; i++) {
      if (list[i].id == id) {
        list.removeAt(i);
        return true;
      }
      if (_recursiveRemove(list[i].replies, id)) {
        return true;
      }
    }
    return false;
  }

  Future<void> addReactionToComment(int commentId, String type) async {
    var targetComment = findCommentById(comments, commentId);

    if (targetComment != null) {
      targetComment.isReacted.value = true;

      targetComment.userReactionType.value = type;

      targetComment.reactionsCount.value += 1;

      comments.refresh();
    }

    try {
      await _dio.post('/comments/$commentId/react', data: {'type': type});

      print("✅ تم إضافة التفاعل بنجاح للتعليق/الرد: $commentId");
    } catch (e) {
      print("❌ خطأ في إضافة التفاعل: $e");

      if (targetComment != null) {
        targetComment.isReacted.value = false;

        targetComment.userReactionType.value = null;

        targetComment.reactionsCount.value -= 1;

        comments.refresh();
      }
    }
  }

  Future<void> deleteReactionFromComment(int commentId, String type) async {
    try {
      final response = await _dio.delete(
        '/comments/$commentId/react',

        data: {'type': type},
      );

      if (response.statusCode == 200) {
        var targetComment = findCommentById(comments, commentId);

        if (targetComment != null) {
          targetComment.isReacted.value = false;

          targetComment.userReactionType.value = null;

          targetComment.reactionsCount.value -= 1;

          comments.refresh();

          print("✅ تم التحديث بنجاح!");
        } else {
          print("⚠️ لم يتم العثور على التعليق رقم $commentId في القائمة.");
        }
      }
    } catch (e) {
      print("❌ خطأ: $e");
    }
  }

  Future<void> fetchPublicProfile() async {
    try {
      final response = await DioService().dio.get('/profile/public');

      if (response.statusCode == 200 && response.data != null) {
        final userId = response.data['data']?['public_profile']?['user_id'];

        if (userId != null) {
          box.write("current_user_id", userId);
          print("✅ [PublicProfile] تم حفظ الـ current_user_id بنجاح: $userId");
        }
      }
    } catch (e) {
      print("❌ خطأ أثناء جلب البروفايل العام: $e");
    }
  }
}
