import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/core/theme/colors.dart';
import 'package:hobe/features/Icons_home/controller/JobController.dart';
import 'package:hobe/features/Icons_home/controller/ReactionController.dart';
import 'package:hobe/features/Icons_home/models/JobPostModel.dart';
import 'package:hobe/features/home/screens/JobDetailsScreen.dart';
import '../../home/controllers/home_controller.dart';

class ActivityDetailsView extends StatelessWidget {
  const ActivityDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final jobController = Get.isRegistered<JobController>()
        ? Get.find<JobController>()
        : Get.put(JobController());

    final reactionController = Get.isRegistered<ReactionController>()
        ? Get.find<ReactionController>()
        : Get.put(ReactionController());

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
          title: Obx(
            () => Text(
              homeController.currentTitle.value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 0.5,
              ),
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Obx(() {
          if (homeController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            );
          }

          final details = homeController.detailsList;

          if (details.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.folder_open_rounded,
                      size: 48,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "No activities are available.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.80,
            ),
            itemCount: details.length,
            itemBuilder: (_, i) {
              final item = details[i];

              return FutureBuilder<JobPostModel?>(
                future: item.jobPostId != 0
                    ? jobController.fetchJobDetails(item.jobPostId)
                    : Future.value(null),
                builder: (context, snapshot) {
                  String jobTitle = snapshot.hasData && snapshot.data != null
                      ? snapshot.data!.title
                      : "جاري التحميل...";
                  String companyName =
                      snapshot.hasData &&
                          snapshot.data?.company?.companyName != null
                      ? snapshot.data!.company!.companyName!
                      : "";

                  return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () async {
                      if (snapshot.data != null) {
                        String? type;
                        if (item.title.contains("تعليق")) {
                          type = 'comment';
                        } else if (item.title.contains("تفاعل")) {
                          type = 'reaction';
                        } else {
                          type = 'view';
                        }

                        Get.to(
                          () => JobDetailsActivityScreen(
                            job: snapshot.data!,
                            activityType: type,
                            activityContent: item.desc,
                          ),
                        );
                      } else {
                        Get.snackbar(
                          "تنبيه",
                          "جارٍ تحضير تفاصيل المنشور، يرجى المحاولة بعد قليل",
                          backgroundColor: AppColors.Selection,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 12,
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        // خلفية كارت زجاجية نظيفة وفخمة
                        color: Colors.white.withOpacity(0.94),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // رأس البطاقة مع الأيقونات
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      color: AppColors.Selection.withOpacity(
                                        0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.local_activity_rounded,
                                      color: AppColors.Selection,
                                      size: 18,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 10,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // عنوان الوظيفة
                              Text(
                                jobTitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: AppColors.textLightPrimary,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // اسم الشركة
                              if (companyName.isNotEmpty) ...[
                                Text(
                                  companyName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.Selection,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                              ],
                              const Spacer(),
                              // تفاصيل التفاعل أو الوصف
                              item.title == "تفاعل"
                                  ? Row(
                                      children: [
                                        const Text(
                                          "التفاعل: ",
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 11,
                                          ),
                                        ),
                                        reactionController.getIconWidget(
                                          item.desc,
                                        ),
                                      ],
                                    )
                                  : Text(
                                      item.desc,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 11,
                                        height: 1.2,
                                      ),
                                    ),
                              const SizedBox(height: 8),
                              // التاريخ بشكل أنيق
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time_rounded,
                                    size: 10,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.date.isNotEmpty
                                        ? item.date.substring(0, 10)
                                        : '',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        }),
      ),
    );
  }
}
