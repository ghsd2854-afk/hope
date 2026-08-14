import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/core/theme/colors.dart';
import 'package:hobe/features/home/controllers/UserReviewsController.dart';
import 'package:hobe/features/home/models/UserReviewModel.dart';

class UserReviewsScreen extends GetView<UserReviewsController> {
  const UserReviewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode
        ? AppColors.textDarkPrimary
        : AppColors.textLightPrimary;

    return Scaffold(
      appBar: AppBar(
        title: Text("التقييمات", style: TextStyle(color: textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryEnd),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }

        if (controller.reviewsList.isEmpty) {
          return const Center(child: Text("لا توجد تقييمات متاحة حالياً"));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (controller.stats.value != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode
                          ? Colors.black.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          controller.stats.value!.average.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryEnd,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                          ],
                        ),
                      ],
                    ),
                    Container(height: 40, width: 1, color: AppColors.border),
                    Column(
                      children: [
                        Text(
                          "${controller.stats.value!.total}",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "إجمالي التقييمات",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
            ...controller.reviewsList
                .map(
                  (review) => _buildFullReviewCard(
                    context,
                    review,
                    isDarkMode,
                    textColor,
                  ),
                )
                .toList(),
          ],
        );
      }),
    );
  }

  Widget _buildFullReviewCard(
    BuildContext context,
    ReviewItem review,
    bool isDarkMode,
    Color textColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.1)
                : Colors.grey.withOpacity(0.03),
            blurRadius: 5,
          ),
        ],
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
                    backgroundColor: AppColors.primaryEnd.withOpacity(0.15),
                    backgroundImage: review.reviewer.photo != null
                        ? NetworkImage(review.reviewer.photo!)
                        : null,
                    child: review.reviewer.photo == null
                        ? Text(
                            review.reviewer.name.isNotEmpty
                                ? review.reviewer.name[0].toUpperCase()
                                : "R",
                            style: const TextStyle(
                              color: AppColors.primaryEnd,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    review.reviewer.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              Row(
                children: List.generate(
                  review.overallRating,
                  (index) =>
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.pros,
            style: TextStyle(
              fontSize: 13,
              color: isDarkMode ? Colors.grey[300] : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
