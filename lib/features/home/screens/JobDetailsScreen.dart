import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/core/theme/colors.dart';
import 'package:hobe/features/Icons_home/controller/JobController.dart';
import 'package:hobe/features/Icons_home/controller/JobDetailsController.dart';
import 'package:hobe/features/Icons_home/controller/ReactionController.dart';
import 'package:hobe/features/Icons_home/models/JobPostModel.dart';

class JobDetailsScreen extends StatelessWidget {
  final JobPostModel job;
  final String? activityType;
  final String? activityContent;

  const JobDetailsScreen({
    super.key,
    required this.job,
    this.activityType,
    this.activityContent,
  });

  @override
  Widget build(BuildContext context) {
    final reactionController = Get.isRegistered<ReactionController>()
        ? Get.find<ReactionController>()
        : Get.put(ReactionController());

    final jobDetailsController =
        Get.isRegistered<JobDetailsController>(tag: job.id.toString())
        ? Get.find<JobDetailsController>(tag: job.id.toString())
        : Get.put(JobDetailsController(), tag: job.id.toString());

    // ربط واستدعاء JobController المسؤول عن العمليات مثل التقديم للوظيفة
    final jobController = Get.isRegistered<JobController>()
        ? Get.find<JobController>()
        : Get.put(JobController());

    return Container(
      decoration: const BoxDecoration(
        gradient: GradientExtension.purpleGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            job.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (activityType != null &&
                  activityType != 'view' &&
                  activityContent != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lightCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primaryEnd.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryEnd.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            activityType == 'comment'
                                ? Icons.comment_rounded
                                : Icons.favorite_rounded,
                            color: AppColors.Selection,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            activityType == 'comment'
                                ? "تعليقك على هذا المنشور:"
                                : "تفاعلك مع هذا المنشور:",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.Selection,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      activityType == 'reaction'
                          ? Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: AppColors.backgroundColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: reactionController.getIconWidget(
                                    activityContent,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  activityContent!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textLightPrimary,
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                activityContent!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textLightPrimary,
                                  height: 1.4,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.lightCard,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryEnd.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primaryStart.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.business_rounded,
                            color: AppColors.Selection,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            job.company?.companyName ?? 'شركة غير معروفة',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.Selection,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "الموقع: ${job.location}",
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(color: AppColors.border),
                    ),
                    const Text(
                      "وصف الوظيفة",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLightPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      job.description,
                      style: const TextStyle(
                        height: 1.6,
                        color: AppColors.textLightPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: job.isApplied.value
                        ? null
                        : () => jobController.applyToJob(
                            job.id,
                          ), // استدعاء دالة التقديم من JobController
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
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
