import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/core/theme/colors.dart';
import 'package:hobe/features/home/controllers/CompanyRatingController.dart';
import 'package:hobe/features/home/models/CompanyReviewModel.dart';
import 'package:hobe/features/home/screens/showCompanyRating.dart';
// استبدل هذا المسار بالمسار الصحيح لشاشة إضافة التقييم لديك
// import 'package:hobe/features/home/views/AddReviewScreen.dart';

class CompanyReviewsScreen extends StatelessWidget {
  final int companyId;

  const CompanyReviewsScreen({Key? key, required this.companyId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CompanyRatingController ratingController =
        Get.find<CompanyRatingController>();
    final controller = Get.isRegistered<CompanyRatingController>()
        ? Get.find<CompanyRatingController>()
        : Get.put(CompanyRatingController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchCompanyReviews(companyId);
    });

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode
        ? AppColors.textDarkPrimary
        : AppColors.textLightPrimary;

    return Scaffold(
      appBar: AppBar(
        title: Text("تقييمات الشركة", style: TextStyle(color: textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Get.back(),
        ),
      ),
      // إضافة زر "أضف تقييمك" بشكل احترافي
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        /*  final companyObj =
                                  controller.companyData.value?.company;
                              if (companyObj != null) {
                                showCompanyRatingDialog(
                                  context,
                                  companyObj.userId,
                                );
                              }
        },
        */
        backgroundColor: AppColors.primaryEnd,
        icon: const Icon(Icons.star_rate_rounded, color: Colors.white),
        label: const Text(
          "أضف تقييمك",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (controller.isFetchingReviews.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryEnd),
          );
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(
            16,
            16,
            16,
            80,
          ), // زيادة البادينج من الأسفل ليظهر الزر
          children: [
            if (controller.stats.value != null) ...[
              _buildStatsCard(context, controller, isDarkMode, textColor),
            ],
            if (controller.reviewsList.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Center(child: Text("لا توجد تقييمات لهذه الشركة")),
              )
            else
              ...controller.reviewsList.map(
                (review) =>
                    _buildReviewCard(context, review, isDarkMode, textColor),
              ),
          ],
        );
      }),
    );
  }

  // كود البطاقة الإحصائية (تم فصله لتنظيم الكود)
  Widget _buildStatsCard(
    BuildContext context,
    CompanyRatingController controller,
    bool isDarkMode,
    Color textColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              controller.stats.value!.average.toStringAsFixed(1),
              "المعدل العام",
              AppColors.primaryEnd,
            ),
          ),
          Container(height: 40, width: 1, color: Colors.grey.withOpacity(0.3)),
          Expanded(
            child: _buildStatItem(
              "${controller.stats.value!.total}",
              "إجمالي التقييمات",
              textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildReviewCard(
    BuildContext context,
    CompanyReviewModel review,
    bool isDarkMode,
    Color textColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.primaryEnd.withOpacity(0.1),
                    child: Text(
                      review.user?.name?[0].toUpperCase() ?? "U",
                      style: const TextStyle(
                        color: AppColors.primaryEnd,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    review.user?.name ?? "مستخدم مجهول",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < review.overallRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Text(
            review.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          if (review.pros.isNotEmpty)
            Text(
              "👍 إيجابيات: ${review.pros}",
              style: const TextStyle(fontSize: 13, color: Colors.green),
            ),
          if (review.cons.isNotEmpty)
            Text(
              "👎 سلبيات: ${review.cons}",
              style: const TextStyle(fontSize: 13, color: Colors.red),
            ),
        ],
      ),
    );
  }
}
