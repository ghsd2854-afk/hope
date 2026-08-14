import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hobe/app_routes.dart';
import 'package:hobe/core/theme/colors.dart';
import 'package:hobe/features/Icons_home/controller/comment_controller.dart';
import 'package:hobe/features/Icons_home/models/comment_model.dart';
import 'package:hobe/features/Icons_home/screen/ReportDialog.dart';

class CommentBottomSheet extends StatelessWidget {
  final int postId;
  //هاد التعديل ازبطو بعدين  عشان تكرار الاستدعاء
  /*late final CommentController controller = Get.put(
    CommentController(),
    tag: postId.toString(),
  );*/
  late final CommentController controller = Get.find<CommentController>(
    tag: postId.toString(),
  );

  final TextEditingController _textController = TextEditingController();
  CommentBottomSheet({super.key, required this.postId}) {
    // 👈 التأكد من تهيئة الـ Controller وجلب التعليقات فور فتح الـ BottomSheet
    controller.initController(postId);
    //  controller.fetchComments(postId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: Get.height * 0.85,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              "التعليقات",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(thickness: 0.5),
          Expanded(
            child: Obx(() {
              // 1. عرض مؤشر تحميل أثناء جلب الصفحة الأولى
              if (controller.isLoading.value && controller.comments.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              // 2. عرض رسالة إذا كانت القائمة فارغة
              if (controller.comments.isEmpty) {
                return const Center(child: Text("لا توجد تعليقات بعد"));
              }

              // 3. القائمة الأساسية مع ربط الـ ScrollController
              return ListView.builder(
                controller: controller
                    .scrollController, // 👈 ربط الـ ScrollController هنا
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount:
                    controller.comments.length +
                    (controller.hasMore
                        ? 1
                        : 0), // 👈 إضافة عنصر إضافي لدائرة التحميل بالأسفل
                itemBuilder: (context, index) {
                  // 👈 إذا وصلنا لنحاية القائمة ويتم جلب المزيد، نعرض دائرة تحميل في الأسفل
                  if (index == controller.comments.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final comment = controller.comments[index];

                  // التحقق هل التعليق الأساسي يخص المستخدم الحالي؟
                  final box = GetStorage();
                  int currentUserId = box.read("current_user_id") ?? 0;
                  bool isMyParentComment =
                      currentUserId != 0 && comment.userId == currentUserId;

                  return Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // تمرير التعليق الأساسي
                        _buildModernComment(
                          context,
                          comment,
                          isParentCommentMyComment: isMyParentComment,
                        ),

                        if (comment.replies.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 50,
                              bottom: 10,
                            ),
                            child: InkWell(
                              onTap: () {
                                comment.isExpanded.value =
                                    !comment.isExpanded.value;
                              },
                              child: Text(
                                comment.isExpanded.value
                                    ? "▲ إخفاء الردود"
                                    : "▼ عرض ${comment.replies.length} ردود",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primaryEnd,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                        if (comment.isExpanded.value &&
                            comment.replies.isNotEmpty)
                          ...comment.replies
                              .map(
                                (reply) => Padding(
                                  padding: const EdgeInsets.only(right: 40),
                                  child: _buildModernComment(
                                    context,
                                    reply,
                                    isReply: true,
                                    isParentCommentMyComment: isMyParentComment,
                                  ),
                                ),
                              )
                              .toList(),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
          _buildModernInput(theme),
        ],
      ),
    );
  }

  Widget _buildModernComment(
    BuildContext context,
    CommentModel comment, {
    bool isReply = false,
    bool isParentCommentMyComment =
        false, // لمعرفة ما إذا كان التعليق الأساسي ملكاً لكِ
  }) {
    final box = GetStorage();
    var rawUserId = box.read("current_user_id");
    int currentUserId = rawUserId is int
        ? rawUserId
        : int.tryParse(rawUserId?.toString() ?? '') ?? 0;

    // هل هذا التعليق (أو الرد) ملكي شخصياً؟
    bool isMyComment = currentUserId != 0 && comment.userId == currentUserId;

    // الصلاحية الكاملة تتوفر إذا كان التعليق ملكي، أو إذا كان رداً واقعاً تحت تعليقي الأساسي
    bool hasFullControl = isMyComment || (isReply && isParentCommentMyComment);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isReply)
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primaryEnd.withOpacity(0.1),
              child: Icon(Icons.person, size: 20, color: AppColors.primaryEnd),
            ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.border.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.userProfile,
                            arguments: comment.userId,
                          );
                        },
                        child: Text(
                          comment.userName ?? "مستخدم",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.primaryEnd,
                          ),
                        ),
                      ),
                      Text(
                        comment.content,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, right: 10),
                  child: Row(
                    children: [
                      // زر التفاعل يظهر للجميع
                      _buildReactionButton(comment),
                      const SizedBox(width: 10),

                      // زر الرد يظهر للجميع
                      _buildActionText(
                        "رد",
                        () => _showEditOrReplyDialog(comment, isEdit: false),
                      ),
                      const SizedBox(width: 10),

                      // شروط الصلاحيات: إذا كان لديك صلاحية كاملة (تعليقك أو رد تحت تعليقك)
                      if (hasFullControl) ...[
                        _buildActionText(
                          "تعديل",
                          () => _showEditOrReplyDialog(comment, isEdit: true),
                        ),
                        const SizedBox(width: 10),
                        _buildActionText(
                          "حذف",
                          () => controller.deleteComment(comment.id, postId),
                          isDelete: true,
                        ),
                      ] else ...[
                        // زر الإبلاغ يظهر لباقي المستخدمين والتعليقات التي لا تملك صلاحية كاملة عليها
                        _buildActionText("إبلاغ", () {
                          showDialog(
                            context: context,
                            builder: (context) => ReportDialog(
                              reportableType: 'comment',
                              reportableId: comment.id,
                            ),
                          );
                        }, isReport: true),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReactionButton(CommentModel comment) {
    return Obx(() {
      bool isReacted = comment.isReacted.value;
      String reactionType = comment.userReactionType.value ?? 'like';

      // تحديد النص أو الأيقونة بناءً على نوع التفاعل الحالي
      String label = "إعجاب";
      Color color = AppColors.textSecondary;

      if (isReacted) {
        switch (reactionType) {
          case 'love':
            label = "أحببته ❤️";
            color = Colors.red;
            break;
          case 'haha':
            label = "ضحكني 😆";
            color = Colors.amber;
            break;
          case 'sad':
            label = "أحزنني 😢";
            color = Colors.orange;
            break;
          case 'angry':
            label = "أغضبني 😡";
            color = Colors.deepOrange;
            break;
          case 'like':
          default:
            label = "أعجبني 👍";
            color = Colors.blue;
            break;
        }
      }

      return GestureDetector(
        // 1. الضغط مرة واحدة: إذا كان متفاعلاً مسبقاً يحذفه، وإذا لم يكن متفاعلاً يرسل "like" مباشرة
        onTap: () {
          if (isReacted) {
            controller.deleteReactionFromComment(comment.id, reactionType);
          } else {
            controller.addReactionToComment(comment.id, "like");
          }
        },
        // 2. الضغط المطول: يظهر نافذة تحتوي على كافة خيارات التفاعلات
        onLongPress: () {
          _showReactionPopup(comment);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 2,
          ), // تم التصحيح هنا
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      );
    });
  }

  // دالة لإظهار كافة خيارات التفاعلات عند الضغط المطول
  void _showReactionPopup(CommentModel comment) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // أعجبني (Like)
              _buildPopupIcon(comment.id, "👍", "like"),
              // أححبته (Love)
              _buildPopupIcon(comment.id, "❤️", "love"),
              // ضحكني (Haha)
              _buildPopupIcon(comment.id, "😆", "haha"),
              // أحزنني (Sad)
              _buildPopupIcon(comment.id, "😢", "sad"),
              // أغضبني (Angry)
              _buildPopupIcon(comment.id, "😡", "angry"),
            ],
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لإنشاء أيقونات النافذة المنسدلة بشكل مرتب ومنسق
  Widget _buildPopupIcon(int commentId, String emoji, String type) {
    return IconButton(
      icon: Text(emoji, style: const TextStyle(fontSize: 22)),
      onPressed: () {
        Get.back();
        controller.addReactionToComment(commentId, type);
      },
    );
  }
  /* Widget _buildReactionButton(CommentModel comment) {
    return Obx(
      () => InkWell(
        onTap: () {
          if (comment.isReacted.value) {
            controller.deleteReactionFromComment(
              comment.id,
              comment.userReactionType.value ?? 'like',
            );
          } else {
            controller.addReactionToComment(comment.id, "like");
          }
        },
        child: Text(
          comment.isReacted.value ? "متفاعل" : "إعجاب",
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: comment.isReacted.value
                ? Colors.red
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }*/

  Widget _buildActionText(
    String label,
    VoidCallback onTap, {
    bool isDelete = false,
    bool isReport = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isDelete
              ? Colors.red
              : (isReport ? Colors.orange : AppColors.textSecondary),
        ),
      ),
    );
  }

  void _showEditOrReplyDialog(CommentModel comment, {required bool isEdit}) {
    if (isEdit) _textController.text = comment.content;
    Get.defaultDialog(
      title: isEdit ? "تعديل التعليق" : "إضافة رد",
      content: TextField(controller: _textController, autofocus: true),
      onConfirm: () {
        isEdit
            ? controller.updateComment(comment.id, postId, _textController.text)
            : controller.addReply(postId, comment.id, _textController.text);
        _textController.clear();
        Get.back();
      },
    );
  }

  Widget _buildModernInput(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: const Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: "اكتب تعليقاً...",
                filled: true,
                fillColor: AppColors.border.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: AppColors.primaryEnd),
            onPressed: () {
              // استخدام trim() للتأكد من أن النص ليس مسافات فارغة
              if (_textController.text.trim().isNotEmpty) {
                final text = _textController.text;
                _textController
                    .clear(); // تفريغ الحقل فوراً لكي يشعر المستخدم بالاستجابة
                controller.addComment(postId, text); // إرسال النص المخزن
              }
            },
          ),
        ],
      ),
    );
  }
}
