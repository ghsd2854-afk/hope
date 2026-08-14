import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/core/theme/colors.dart';
import 'package:hobe/features/Icons_home/controller/JobController.dart';
import 'package:hobe/features/home/controllers/CompanyProfileController.dart';
import 'package:hobe/features/home/controllers/CompanyRatingController.dart';
import 'package:hobe/features/home/controllers/block_controller.dart';
import 'package:hobe/features/home/screens/CompanyReviewsScreen.dart';
import 'package:hobe/features/home/screens/ComplaintWidget.dart';
import 'package:hobe/features/home/screens/showCompanyRating.dart';

class CompanyProfileScreen extends StatelessWidget {
  const CompanyProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CompanyProfileController());
    final ratingController = Get.put(CompanyRatingController());
    // جلب التقييمات بمجرد فتح الشاشة بناءً على معرف الشركة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final company = controller.companyData.value?.company;
      if (company != null && company.userId != 0) {
        ratingController.fetchCompanyReviews(
          company.userId, // <--- التعديل هنا: استخدام userId الخاص بالشركة
        );
      }
    });

    // جلب أو تسجيل الـ JobController
    final JobController jobController = Get.isRegistered<JobController>()
        ? Get.find<JobController>()
        : Get.put(JobController());

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryEnd),
          );
        }

        final data = controller.companyData.value;
        if (data == null || data.company == null) {
          return const Center(child: Text("لا توجد بيانات متاحة للشركة"));
        }

        final company = data.company!;
        final stats = data.stats;
        final jobs = data.jobs;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [AppColors.darkBackground, AppColors.darkCard]
                  : [AppColors.backgroundColor, AppColors.lightBackground],
            ),
          ),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 270.0,
                pinned: true,
                backgroundColor: AppColors.primaryEnd,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
                actions: [
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (value) {
                      if (value == 'toggle_notifications') {
                        Get.snackbar(
                          "الإشعارات",
                          "تم تغيير حالة الإشعارات بنجاح",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'toggle_notifications',
                        child: Row(
                          children: [
                            Icon(Icons.notifications_active_outlined, size: 20),
                            SizedBox(width: 8),
                            Text("تفعيل الإشعارات"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryEnd,
                              AppColors.primaryStart,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      Container(color: Colors.black.withOpacity(0.2)),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.white,
                              child: Text(
                                company.companyName.isNotEmpty
                                    ? company.companyName[0].toUpperCase()
                                    : "C",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryEnd,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    company.companyName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (company.isVerified == 1) ...[
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.verified,
                                    color: Colors.blueAccent,
                                    size: 16,
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              company.category ?? "شركة تقنية وبرمجيات",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            if (company.localAddress != null &&
                                company.localAddress!.isNotEmpty)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.white60,
                                    size: 13,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      company.localAddress!,
                                      style: const TextStyle(
                                        color: Colors.white60,
                                        fontSize: 11,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Obx(() {
                                    var job = jobController.jobPosts
                                        .firstWhereOrNull(
                                          (j) =>
                                              j.company?.id ==
                                              controller.companyId,
                                        );

                                    bool isFollowing =
                                        job?.isFollowingCompany.value ?? false;

                                    return ElevatedButton.icon(
                                      onPressed: () {
                                        if (job != null) {
                                          jobController.toggleFollow(job.id);
                                        } else {
                                          jobController.toggleFollow(
                                            controller.companyId,
                                          );
                                        }
                                      },
                                      icon: Icon(
                                        isFollowing ? Icons.check : Icons.add,
                                        size: 16,
                                      ),
                                      label: Text(
                                        isFollowing ? "تمت المتابعة" : "متابعة",
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isFollowing
                                            ? Colors.grey.shade200
                                            : AppColors.primaryEnd,
                                        foregroundColor: isFollowing
                                            ? Colors.black87
                                            : Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 2,
                                  child: OutlinedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.chat_bubble_outline,
                                      size: 16,
                                    ),
                                    label: const Text(
                                      "مراسلة",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: const BorderSide(
                                        color: Colors.white70,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white70),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.more_vert,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _showOptionsMenu(context, company);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // قسم إحصائيات الشركة
                      if (stats != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem("الوظائف", "${stats.totalJobs}"),
                              _buildDivider(),
                              _buildStatItem(
                                "المشاريع",
                                "${stats.totalProjects}",
                              ),
                              _buildDivider(),
                              _buildStatItem("المتابعين", "${stats.followers}"),
                            ],
                          ),
                        ),
                      const SizedBox(height: 20),

                      // عن الشركة
                      Text(
                        "عن الشركة",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textDarkPrimary
                              : AppColors.textLightPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        company.description ??
                            "لا توجد نبذة تعريفية متاحة حالياً.",
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? Colors.white70
                              : AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ما تقدمه الشركة
                      if (company.supportOffers.isNotEmpty) ...[
                        Text(
                          "ما تقدمه الشركة",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.textDarkPrimary
                                : AppColors.textLightPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: company.supportOffers.map((offer) {
                            return Chip(
                              label: Text(offer),
                              backgroundColor: AppColors.primaryStart
                                  .withOpacity(0.3),
                              labelStyle: TextStyle(
                                color: isDark
                                    ? AppColors.textDarkPrimary
                                    : AppColors.textLightPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide.none,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // معلومات التواصل (رقم الهاتف والموقع الإلكتروني)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            if (company.phone != null)
                              _buildInfoRow(
                                Icons.phone,
                                "رقم الهاتف",
                                company.phone!,
                              ),
                            if (company.phone != null &&
                                company.websiteUrl != null)
                              const Divider(height: 20),
                            if (company.websiteUrl != null)
                              _buildInfoRow(
                                Icons.language,
                                "الموقع الإلكتروني",
                                company.websiteUrl!,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 🌟 قسم التقييمات وآراء الموظفين (عرض آخر 2 تقييم + زر أضف تقييم + زر عرض الكل)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "تقييمات وآراء ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 6),
                              /* Obx(
                                () => Text(
                                  '(${ratingController.reviewsList.length})',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),*/
                            ],
                          ),
                          TextButton.icon(
                            onPressed: () {
                              final companyObj =
                                  controller.companyData.value?.company;
                              if (companyObj != null) {
                                showCompanyRatingDialog(
                                  context,
                                  companyObj.userId,
                                );
                              }
                            },
                            icon: const Icon(Icons.star_rate_rounded, size: 18),
                            label: const Text("أضف تقييمك"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // عرض قائمة التقييمات أو حالة التحميل أو حالة عدم وجود تقييمات
                      Obx(() {
                        if (ratingController.isFetchingReviews.value) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (ratingController.reviewsList.isEmpty) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkCard : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.rate_review_outlined,
                                  size: 40,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "لا توجد تقييمات لهذه الشركة بعد",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    final companyObj =
                                        controller.companyData.value?.company;
                                    if (companyObj != null) {
                                      showCompanyRatingDialog(
                                        context,
                                        companyObj.userId,
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.rate_review_outlined),
                                  label: const Text("كن أول من يقيم الشركة"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryEnd,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        // أخذ آخر تقييمين فقط لمعاينتهم في صفحة البروفايل
                        final previewReviews = ratingController.reviewsList
                            .take(2)
                            .toList();

                        return Column(
                          children: [
                            ...previewReviews.map(
                              (review) => Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.darkCard
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            review.title.isNotEmpty
                                                ? review.title
                                                : "تقييم عام",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.amber.withOpacity(
                                              0.15,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                review.overallRating.toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.amber,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    if (review.pros.isNotEmpty) ...[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.check_circle_outline,
                                            color: Colors.green,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              "الإيجابيات: ${review.pros}",
                                              style: const TextStyle(
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                    ],
                                    if (review.cons.isNotEmpty) ...[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.remove_circle_outline,
                                            color: Colors.red,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              "السلبيات: ${review.cons}",
                                              style: const TextStyle(
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // زر عرض كل التقييمات
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {
                                  final companyObj =
                                      controller.companyData.value?.company;
                                  if (companyObj != null) {
                                    Get.to(
                                      () => CompanyReviewsScreen(
                                        companyId: companyObj.userId,
                                      ),
                                    );
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: AppColors.primaryEnd,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                child: Text(
                                  'عرض كل التقييمات (${ratingController.reviewsList.length})',
                                  style: const TextStyle(
                                    color: AppColors.primaryEnd,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 24),

                      // الوظائف المتاحة
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "الوظائف المتاحة (${jobs.length})",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.textDarkPrimary
                                  : AppColors.textLightPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      jobs.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: Text(
                                  "لا توجد وظائف متاحة حالياً من هذه الشركة",
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: jobs.length,
                              itemBuilder: (context, index) {
                                final job = jobs[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.03),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              job.title,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: isDark
                                                    ? AppColors.textDarkPrimary
                                                    : AppColors
                                                          .textLightPrimary,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryStart
                                                  .withOpacity(0.4),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              job.type,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            size: 14,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            job.location,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          if (job.isRemote)
                                            const Row(
                                              children: [
                                                Icon(
                                                  Icons.wifi,
                                                  size: 14,
                                                  color: Colors.green,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  "عن بُعد",
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _confirmBlock(BuildContext context, dynamic company) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حظر الشركة'),
        content: Text(
          'لن تظهر لك منشورات "${company.companyName}" بعد الحظر. هل تريد المتابعة؟',
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
                id: company.id,
                name: company.companyName,
              );
            },
            child: const Text('حظر', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu(BuildContext context, dynamic company) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: const Text(
                  "حظر الشركة",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmBlock(context, company);
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag_outlined, color: Colors.orange),
                title: const Text(
                  "شكوى على الشركة",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ComplaintUI.showComplaintDialog(
                    context,
                    company.id,
                    'company',
                    "تقديم شكوى على الشركة",
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryEnd,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 25, width: 1, color: Colors.grey.withOpacity(0.3));
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryEnd, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
/*



  void _confirmBlock(BuildContext context, dynamic company) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حظر الشركة'),
        content: Text(
          'لن تظهر لك منشورات "${company.companyName}" بعد الحظر. هل تريد المتابعة؟',
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
                id: company.id,
                name: company.companyName,
              );
            },
            child: const Text('حظر', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu(BuildContext context, dynamic company) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: const Text(
                  "حظر الشركة",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmBlock(context, company);
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag_outlined, color: Colors.orange),
                title: const Text(
                  "شكوى على الشركة",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ComplaintUI.showComplaintDialog(
                    context,
                    company.id,
                    'company',
                    "تقديم شكوى على الشركة",
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

 
              // 🌟 4️⃣ قسم معاينة التقييمات (آخر 3 تقييمات فقط + زر عرض الكل)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'التقييمات والآراء',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Obx(
                    () => Text(
                      '(${ratingController.reviewsList.length})',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Obx(() {
                if (ratingController.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (ratingController.reviewsList.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      'لا توجد تقييمات لهذه الشركة حتى الآن.',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  );
                }

                // عرض أحدث 3 تقييمات كمعاينة فقط لتجنب إطالة الصفحة
                final previewReviews = ratingController.reviewsList
                    .take(3)
                    .toList();

                return Column(
                  children: [
                    ...previewReviews.map(
                      (review) => _buildReviewPreviewCard(review),
                    ),
                    const SizedBox(height: 12),

                    // زر عرض كل التقييمات
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          // الانتقال لصفحة التقييمات الكاملة وإرسال الـ userId الخاص بالشركة
                          final companyUserId = company.userId;
                          Get.to(
                            () =>
                                CompanyReviewsScreen(companyId: company.userId),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primaryEnd),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'عرض كل التقييمات (${ratingController.reviewsList.length})',
                          style: const TextStyle(
                            color: AppColors.primaryEnd,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  // 🔹 تصميم مصغر لكارت التقييم في صفحة البروفايل
  Widget _buildReviewPreviewCard(CompanyReviewModel review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${review.overallRating}.0',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Text(
                review.createdAt ?? '',
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            review.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (review.pros.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'المميزات: ${review.pros}',
              style: const TextStyle(fontSize: 12, color: Colors.green),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  // 🔹 دالة مساعدة لصفوف المعلومات
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(color: Colors.grey)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );*/