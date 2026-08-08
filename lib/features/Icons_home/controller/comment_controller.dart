import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hobe/features/APIS/dio_services.dart';
import 'package:hobe/features/Icons_home/controller/JobController.dart';

import 'package:hobe/features/Icons_home/models/comment_model.dart';

class CommentController extends GetxController {
  final Dio _dio = DioService().dio;

  var comments = <CommentModel>[].obs;

  var isLoading = false.obs;
  String? tag;
  @override
  void onClose() {
    super.onClose();
    print("🧹 تم تنظيف الذاكرة للـ Controller ذو الـ tag: $tag");
  }

  Future<void> fetchComments(int postId) async {
    print("🔍 جاري جلب التعليقات للمنشور رقم: $postId");

    try {
      isLoading(true);
      final response = await _dio.get("/posts/$postId/comments");

      if (response.statusCode == 200) {
        // التصحيح هنا: الاستجابة أصبحت مقسمة لصفحات Paginated وتحتوي على مفتاح ['data']
        List<dynamic> commentsJson = response.data['data'];

        comments.value = commentsJson
            .map((e) => CommentModel.fromJson(e))
            .toList();

        print("✅ تم جلب التعليقات وتفاعلاتها بطلب واحد فقط!");
      }
    } catch (e) {
      print("❌ خطأ: $e");
    } finally {
      isLoading(false);
    }
  }
  /*Future<void> fetchComments(int postId) async {
    print("🔍 جاري جلب التعليقات للمنشور رقم: $postId");

    try {
      isLoading(true);
      // comments.clear();
      final response = await _dio.get("/posts/$postId/comments");

      if (response.statusCode == 200) {
        comments.value = (response.data as List)
            .map((e) => CommentModel.fromJson(e))
            .toList();

        print("✅ تم جلب التعليقات وتفاعلاتها بطلب واحد فقط!");
      }
    } catch (e) {
      print("❌ خطأ: $e");
    } finally {
      isLoading(false);
    }
  }*/

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
        CommentModel newComment = CommentModel.fromJson(response.data);
        comments.add(newComment);

        //     await fetchComments(postId);

        final JobController jobController = Get.find<JobController>();
        var post = jobController.jobPosts.firstWhere((p) => p.id == postId);
        post.commentsCount.value++;

        print("✅ تم تحديث عداد التعليقات في المنشور الرئيسي");
      }
    } catch (e) {
      print("❌ خطأ: $e");
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
  /* Future<void> addReply(int postId, int parentId, String content) async {
    try {
      print("🚀 [CommentController] جاري إضافة رد للتعليق: $parentId...");
      final response = await _dio.post(
        "/posts/$postId/comments/reply",
        data: {"content": content, "parent_id": parentId},
      );
      print("✅ [CommentController] تم إضافة الرد بنجاح، جاري تحديث القائمة");

      // 1. جلب البيانات المحدثة من السيرفر
      await fetchComments(postId);

      // 2. استخدم دالة البحث الجديدة بدلاً من rootComments
      var parent = findCommentById(comments, parentId);

      // 3. تحديث الحالة (تأكد من وجود خاصية isExpanded في CommentModel)
      if (parent != null) {
        parent.isExpanded.value = true;
        // comments.refresh();
      }
    } catch (e) {
      print("❌ [CommentController] خطأ في إضافة الرد: $e");
    }
  }*/

  Future<void> updateComment(
    int commentId,
    int postId,
    String newContent,
  ) async {
    try {
      final response = await _dio.put(
        "/comments/$commentId",
        data: {"content": newContent},
      );

      if (response.statusCode == 200) {
        int index = comments.indexWhere((c) => c.id == commentId);
        if (index != -1) {
          comments[index].content = newContent;
          comments.refresh();
        }
        print("✅ تم تعديل التعليق محلياً");
      }
    } catch (e) {
      print("❌ خطأ: $e");
    }
  }
  /* Future<void> updateComment(
    int commentId,
    int postId,
    String newContent,
  ) async {
    try {
      print(
        "✏️ [CommentController] جاري تعديل التعليق (عبر POST): $commentId...",
      );

      // استخدمي .post فقط، لأن السيرفر يدعم POST فقط لهذا المسار
      final response = await _dio.post(
        "/comments/$commentId",
        data: {"content": newContent},
      );

      print("✅ تم التعديل بنجاح: ${response.statusCode}");
      await fetchComments(postId);
    } catch (e) {
      print("❌ خطأ: $e");
    }
  }*/

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
}
