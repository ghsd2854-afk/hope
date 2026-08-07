import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/core/theme/colors.dart';
import 'package:hobe/features/Icons_home/controller/JobController.dart';
import 'package:hobe/features/Icons_home/controller/JobDetailsController.dart';
import 'package:hobe/features/Icons_home/controller/ReactionController.dart';
import 'package:hobe/features/Icons_home/models/JobPostModel.dart';

class JobDetailsActivityScreen extends StatelessWidget {
  final JobPostModel job;
  final String? activityType;
  final String? activityContent;

  const JobDetailsActivityScreen({
    super.key,
    required this.job,
    this.activityType,
    this.activityContent,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Get.isRegistered<ReactionController>()
        ? Get.find<ReactionController>()
        : Get.put(ReactionController());

    Get.isRegistered<JobDetailsController>(tag: job.id.toString())
        ? Get.find<JobDetailsController>(tag: job.id.toString())
        : Get.put(JobDetailsController(), tag: job.id.toString());

    Get.isRegistered<JobController>()
        ? Get.find<JobController>()
        : Get.put(JobController());

    // ألوان تتكيف تلقائياً مع الثيم الحالي
    final cardBgColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final primaryTextColor = isDark
        ? AppColors.textDarkPrimary
        : AppColors.textLightPrimary;
    final accentColor = isDark ? AppColors.primaryStart : AppColors.Selection;
    final subCardBgColor = isDark
        ? AppColors.darkBackground
        : AppColors.backgroundColor.withOpacity(0.4);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        // لون الـ AppBar: نهدي فاتح بالوضع النهاري وأسود بالوضع الليلي
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.primaryStart,
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
      body: Stack(
        children: [
          // خلفية الشاشة: تدرج بالنهاري، وأسود/داكن بالليلي
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : null,
              gradient: isDark ? null : GradientExtension.purpleGradient,
            ),
          ),
          // المحتوى الأساسي
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // بطاقة النشاط (تعليق / تفاعل)
                if (activityType != null &&
                    activityType != 'view' &&
                    activityContent != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? Colors.white10 : AppColors.border,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
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
                              color: accentColor,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              activityType == 'comment'
                                  ? "تعليقك على هذا المنشور:"
                                  : "تفاعلك مع هذا المنشور:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: accentColor,
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
                                    decoration: BoxDecoration(
                                      color: subCardBgColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Get.find<ReactionController>()
                                        .getIconWidget(activityContent),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    activityContent!,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: primaryTextColor,
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: subCardBgColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  activityContent!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: primaryTextColor,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // بطاقة تفاصيل الوظيفة الرئيسيّة
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.25 : 0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: isDark ? Colors.white10 : AppColors.border,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryStart.withOpacity(
                                isDark ? 0.15 : 0.25,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.business_rounded,
                              color: accentColor,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              job.company?.companyName ?? 'شركة غير معروفة',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: accentColor,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Divider(
                          color: isDark ? Colors.white12 : AppColors.border,
                        ),
                      ),
                      Text(
                        "وصف الوظيفة",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        job.description,
                        style: TextStyle(
                          height: 1.6,
                          color: isDark
                              ? AppColors.textDarkPrimary.withOpacity(0.85)
                              : AppColors.textLightPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
