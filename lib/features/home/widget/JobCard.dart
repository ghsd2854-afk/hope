import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/core/theme/colors.dart';
import 'package:hobe/features/Icons_home/controller/JobController.dart';
import 'package:hobe/features/Icons_home/controller/ReactionController.dart';
import 'package:hobe/features/Icons_home/controller/comment_controller.dart';
import 'package:hobe/features/Icons_home/models/JobPostModel.dart';
import 'package:hobe/features/Icons_home/screen/JobDetailsScreen.dart'; // 👈 تأكدت من استيراد صفحة التفاصيل
import 'package:hobe/features/Icons_home/screen/ReactionButton.dart';
import 'package:hobe/features/Icons_home/screen/ReactionListScreen.dart';
import 'package:hobe/features/Icons_home/screen/ReportDialog.dart';
import 'package:hobe/features/Icons_home/screen/comment_screen.dart';
import 'package:hobe/features/home/controllers/JobAlertController.dart';
import 'package:hobe/features/home/controllers/block_controller.dart';
import 'package:hobe/features/home/models/JobAlertModel.dart';
import 'package:hobe/features/home/screens/CompanyProfileScreen.dart';

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
      child: InkWell(
        // 👈 الطلب الثاني: الضغط على البوست بالكامل ينقل لصفحة تفاصيل الوظيفة
        onTap: () {
          Get.to(() => JobDetailsScreen(jobId: job.id));
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1️⃣ الجزء العلوي: الأيقونة + (اسم الشركة + العنوان + الموقع) + المتابعة + النقاط الثلاث
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
                      color: AppColors.primaryEnd,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (job.company != null)
                          GestureDetector(
                            onTap: () {
                              Get.to(
                                () => const CompanyProfileScreen(),
                                arguments: job.company!.id,
                              );
                            },
                            child: Text(
                              job.company!.companyName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppColors.primaryEnd,
                              ),
                            ),
                          ),
                        const SizedBox(height: 2),
                        Text(
                          job.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          job.location + (job.isRemote ? " (عن بعد)" : ""),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
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
                              : AppColors.primaryEnd,
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
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                    onSelected: (value) {
                      if (value == 'block') {
                        _confirmBlock(context);
                      } else if (value == 'report') {
                        showDialog(
                          context: context,
                          builder: (context) => ReportDialog(
                            reportableType: 'job_post',
                            reportableId: job.id,
                          ),
                        );
                      } else if (value == 'job_alert') {
                        _showJobAlertBottomSheet(context);
                      }
                    },
                    itemBuilder: (context) => [
                      /*if (job.company != null)
                        const PopupMenuItem(
                          value: 'block',
                          child: Row(
                            children: [
                              Icon(Icons.block, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text('حظر الشركة'),
                            ],
                          ),
                        ),*/
                      const PopupMenuItem(
                        value: 'report',
                        child: Row(
                          children: [
                            Icon(
                              Icons.flag_outlined,
                              size: 18,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 8),
                            Text('إبلاغ عن المنشور'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'job_alert',
                        child: Row(
                          children: [
                            Icon(
                              Icons.notifications_active_outlined,
                              size: 18,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 8),
                            Text('إضافة تنبيه لهذه الوظيفة'),
                          ],
                        ),
                      ),
                    ],
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

              // 3️⃣ الوصف (الطلب الأول: عرض المزيد محلياً بدون طلب سيرفر عبر controller.toggleJobExpansion)
              Obx(() {
                final bool expanded = job.isExpanded.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.description,
                      maxLines: expanded ? null : 2,
                      overflow: expanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    if (job.description.length > 80) ...[
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () => controller.toggleJobExpansion(job),
                        child: Text(
                          expanded ? "عرض أقل" : "... المزيد",
                          style: TextStyle(
                            color: AppColors.primaryEnd,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              }),
              const SizedBox(height: 16),

              // 4️⃣ زر التقديم
              /*  Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: job.isApplied.value
                        ? null
                        : () => controller.applyToJob(job.id),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: job.isApplied.value
                          ? Colors.green.withOpacity(0.1)
                          : AppColors.primaryEnd,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      job.isApplied.value ? "تم التقديم ✓" : "تقديم طلب عمل",
                      style: TextStyle(
                        color: job.isApplied.value
                            ? Colors.green
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),*/
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
                          ? AppColors.primaryEnd
                          : Colors.grey[600],
                      onTap: () => controller.toggleSave(job),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showJobAlertBottomSheet(BuildContext context) {
    List<String> extractedKeywords = job.title.split(' ');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "إنشاء تنبيه لهذه الوظيفة",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 10),
              Text(
                "سيتم إنشاء تنبيه بناءً على عنوان وموقع هذه الوظيفة ليتم إعلامك بالوظائف المشابهة مستقبلاً:",
                style: TextStyle(color: Colors.grey[700], fontSize: 13),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "اسم التنبيه: ${job.title}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "الموقع: ${job.location}",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "الكلمات المفتاحية: ${extractedKeywords.join(', ')}",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryEnd,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final alertController =
                        Get.isRegistered<JobAlertController>()
                        ? Get.find<JobAlertController>()
                        : Get.put(JobAlertController());

                    JobAlertModel newAlert = JobAlertModel(
                      name: job.title,
                      frequency: "daily",
                      notifyEmail: true,
                      notifyPush: true,
                      isActive: true,
                      notifySms: false,
                      criteria: JobCriteria(
                        location: job.location,
                        remote: job.isRemote,
                        keywords: extractedKeywords,
                        jobType: [job.type],
                      ),
                    );

                    alertController.createJobAlert(newAlert);

                    Navigator.pop(context);
                  },
                  child: const Text(
                    "حفظ التنبيه وإرساله",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmBlock(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حظر الشركة'),
        content: Text(
          'لن تظهر لك منشورات "${job.company!.companyName}" بعد الحظر. هل تريد المتابعة؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('تراجع'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              final blockController = Get.isRegistered<BlockController>()
                  ? Get.find<BlockController>()
                  : Get.put(BlockController());

              blockController.blockEntity(
                type: 'company',
                id: job.company!.id,
                name: job.company!.companyName,
              );
            },
            child: const Text('حظر', style: TextStyle(color: Colors.red)),
          ),
        ],
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
    var commentController = Get.put(
      CommentController(),
      tag: job.id.toString(),
    );
    commentController.fetchComments(job.id);
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
