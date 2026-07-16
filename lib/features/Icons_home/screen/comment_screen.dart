import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hobe/core/theme/colors.dart';
import 'package:hobe/features/Icons_home/controller/comment_controller.dart';
import 'package:hobe/features/Icons_home/models/comment_model.dart';

class CommentBottomSheet extends StatelessWidget {
  final int postId;
  late final CommentController controller = Get.find<CommentController>(
    tag: postId.toString(),
  );
  final TextEditingController _textController = TextEditingController();
  CommentBottomSheet({super.key, required this.postId});

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
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: controller.comments.length,
                itemBuilder: (context, index) {
                  final comment = controller.comments[index];

                  // نغلف كل تعليق بـ Obx خاص به لضمان تحديثه فقط عند النقر
                  return Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildModernComment(context, comment),

                        if (comment.replies.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 50,
                              bottom: 10,
                            ),
                            child: InkWell(
                              onTap: () {
                                // تغيير القيمة فقط، بدون refresh للقائمة كاملة
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

                        // التصحيح هنا: استخدام .value بدلاً من .sentToStream
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
                                  ),
                                ),
                              )
                              .toList(),
                      ],
                    ),
                  );
                },
              ),
            ),
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
  }) {
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
                      Text(
                        comment.userName ?? "مستخدم",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
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
                      _buildActionText(
                        "تعديل",
                        () => _showEditOrReplyDialog(comment, isEdit: true),
                      ),
                      const SizedBox(width: 10),
                      _buildActionText(
                        "رد",
                        () => _showEditOrReplyDialog(comment, isEdit: false),
                      ),
                      const SizedBox(width: 10),
                      _buildActionText(
                        "حذف",
                        () => controller.deleteComment(comment.id, postId),
                        isDelete: true,
                      ),
                      const SizedBox(width: 10),
                      // هنا يظهر الزر في الواجهة
                      _buildReactionButton(comment),
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
    return Obx(
      () => InkWell(
        onTap: () {
          // منطق التفاعل: إذا كان متفاعلاً، يحذف التفاعل، وإلا يضيفه
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
            // يتغير اللون تلقائياً بفضل Obx
            color: comment.isReacted.value
                ? Colors.red
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildActionText(
    String label,
    VoidCallback onTap, {
    bool isDelete = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isDelete ? Colors.red : AppColors.textSecondary,
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
        // بما أن controller معرف أعلاه بالـ tag، فهو سيجلب النسخة الصحيحة دائماً
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
              if (_textController.text.isNotEmpty) {
                controller.addComment(postId, _textController.text);
                _textController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
