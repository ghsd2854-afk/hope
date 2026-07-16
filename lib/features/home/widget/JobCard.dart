import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/core/theme/colors.dart';
import 'package:hobe/features/Icons_home/controller/JobController.dart';
import 'package:hobe/features/Icons_home/controller/ReactionController.dart';
import 'package:hobe/features/Icons_home/controller/comment_controller.dart';
import 'package:hobe/features/Icons_home/models/JobPostModel.dart';
import 'package:hobe/features/Icons_home/screen/ReactionButton.dart';
import 'package:hobe/features/Icons_home/screen/ReactionListScreen.dart';
import 'package:hobe/features/Icons_home/screen/comment_screen.dart';

class JobCard extends StatelessWidget {
  final JobPostModel job;
  final JobController controller;

  const JobCard({Key? key, required this.job, required this.controller})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ReactionController reactionController =
        Get.find<ReactionController>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1️⃣ الجزء العلوي: الأيقونة + (اسم الشركة + العنوان + الموقع) + المتابعة
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryStart.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.business_center_rounded,
                    color: AppColors.primaryStart,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // اسم الشركة
                      if (job.company != null)
                        Text(
                          job.company!.companyName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color.fromARGB(255, 148, 114, 217),
                          ),
                        ),
                      const SizedBox(height: 2),
                      // العنوان الوظيفي
                      Text(
                        job.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      // الموقع
                      Text(
                        job.location + (job.isRemote ? " (عن بعد)" : ""),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => GestureDetector(
                    onTap: () => controller.toggleFollow(job.id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: job.isFollowingCompany.value
                            ? Colors.grey[200]
                            : AppColors.primaryStart,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        job.isFollowingCompany.value ? "متابع" : "متابعة",
                        style: TextStyle(
                          color: job.isFollowingCompany.value
                              ? Colors.grey[700]
                              : Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 2️⃣ التاغات
            Wrap(
              spacing: 8,
              children: [
                _buildJobTag(
                  job.type.replaceAll('_', ' ').toUpperCase(),
                  const Color(0xFFFFC107),
                ),
                if (job.salaryRange.isNotEmpty)
                  _buildJobTag(job.salaryRange, AppColors.primaryStart),
              ],
            ),
            const SizedBox(height: 12),

            // 3️⃣ الوصف
            Text(
              job.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),

            // 4️⃣ زر التقديم
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () => controller.applyToJob(job.id),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: job.isApplied.value
                        ? Colors.green.withOpacity(0.1)
                        : AppColors.primaryStart,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    job.isApplied.value ? "تم التقديم ✓" : "تقديم طلب عمل",
                    style: TextStyle(
                      color: job.isApplied.value ? Colors.green : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(),
            ),

            // 5️⃣ الإحصائيات + أزرار التفاعل
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Obx(
                      () => Text(
                        reactionController.getIconsStringFromStats(
                          job.reactionIcons.toList(),
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => _openReactionList(context),
                      child: Obx(
                        () => Text(
                          "${job.reactionsCount.value}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Obx(
                  () => Text(
                    "${job.commentsCount.value} تعليقات",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ReactionButton(job: job),
                _buildActionButton(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: "تعليق",
                  onTap: () => _openComments(job),
                ),
                Obx(
                  () => _buildActionButton(
                    icon: job.isSaved.value
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    label: "حفظ",
                    color: job.isSaved.value
                        ? AppColors.primaryStart
                        : Colors.grey,
                    onTap: () => controller.toggleSave(job),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Color? color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color ?? Colors.grey[600], size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color ?? Colors.grey[600], fontSize: 13),
          ),
        ],
      ),
    );
  }

  void _openComments(JobPostModel job) {
    var controller = Get.put(CommentController(), tag: job.id.toString());
    controller.fetchComments(job.id);
    Get.bottomSheet(
      CommentBottomSheet(postId: job.id),
      isScrollControlled: true,
      backgroundColor: Colors.white,
    );
  }

  void _openReactionList(BuildContext context) {
    Get.find<ReactionController>().resetReactionData();
    Get.bottomSheet(
      ReactionListScreen(postId: job.id),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }
}
