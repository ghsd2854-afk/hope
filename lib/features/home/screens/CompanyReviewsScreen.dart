import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/home/controllers/CompanyRatingController.dart';

class CompanyReviewsScreen extends StatelessWidget {
  final int companyId;

  const CompanyReviewsScreen({Key? key, required this.companyId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // التأكد من جلب التقييمات عند فتح الشاشة
    final controller = Get.isRegistered<CompanyRatingController>()
        ? Get.find<CompanyRatingController>()
        : Get.put(CompanyRatingController());

    // استدعاء جلب التقييمات مرة واحدة عند البناء
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchCompanyReviews(companyId);
    });

    return Scaffold(
      appBar: AppBar(title: const Text("تقييمات الشركة")),
      body: Obx(() {
        if (controller.isFetchingReviews.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.reviewsList.isEmpty) {
          return const Center(
            child: Text(
              "لا توجد تقييمات لهذه الشركة حتى الآن",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.reviewsList.length,
          itemBuilder: (context, index) {
            final review = controller.reviewsList[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // رأس التقييم: اسم المستخدم (أو مجهول) + التقييم العام
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(child: Icon(Icons.person)),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review.isAnonymous == 1
                                      ? "مستخدم مجهول"
                                      : (review.user?.name ?? "مستخدم"),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                if (review.createdAt != null)
                                  Text(
                                    review.createdAt!.substring(0, 10),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        // عرض النجوم للتقييم العام
                        Row(
                          children: List.generate(
                            5,
                            (starIndex) => Icon(
                              starIndex < review.overallRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),

                    // عنوان التقييم
                    if (review.title.isNotEmpty) ...[
                      Text(
                        review.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    // الإيجابيات
                    if (review.pros.isNotEmpty) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.thumb_up,
                            color: Colors.green,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              "الإيجابيات: ${review.pros}",
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                    ],

                    // السلبيات
                    if (review.cons.isNotEmpty) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.thumb_down,
                            color: Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              "السلبيات: ${review.cons}",
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                    ],

                    // النصيحة للإدارة
                    if (review.advice.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        "نصيحة للإدارة: ${review.advice}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],

                    const SizedBox(height: 8),
                    // حالة التوصية بالعمل
                    Chip(
                      backgroundColor: review.wouldRecommend == 1
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      label: Text(
                        review.wouldRecommend == 1
                            ? "يوصي بالعمل هنا"
                            : "لا يوصي بالعمل هنا",
                        style: TextStyle(
                          color: review.wouldRecommend == 1
                              ? Colors.green
                              : Colors.red,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
