import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/MyReview/controller/MyReviewController.dart';
import 'package:hobe/features/MyReview/model/myReviewmodel.dart';

class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MyReviewController controller = Get.put(MyReviewController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'تقييماتي المهنية',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.reviews.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.rate_review_outlined, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'لا توجد تقييمات مسجلة حتى الآن',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.reviews.length,
          itemBuilder: (context, index) {
            final review = controller.reviews[index];
            return _buildReviewCard(context, review, controller);
          },
        );
      }),
    );
  }

  Widget _buildReviewCard(
    BuildContext context,
    MyReviewModel review,
    MyReviewController controller,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Type & Overall Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    review.type == 'company_to_applicant'
                        ? 'تقييم من شركة'
                        : review.type,
                    style: const TextStyle(
                      color: Colors.indigo,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '${review.overallRating}/5',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Ratings breakdown details
            if (review.technicalSkillsRating != null)
              _buildRatingRow(
                'المهارات التقنية',
                review.technicalSkillsRating!,
              ),
            if (review.communicationRating != null)
              _buildRatingRow('مهارات التواصل', review.communicationRating!),
            if (review.professionalismRating != null)
              _buildRatingRow('الاحترافية', review.professionalismRating!),
            if (review.reliabilityRating != null)
              _buildRatingRow('الموثوقية', review.reliabilityRating!),

            const SizedBox(height: 16),

            // Action Buttons (Respond, React, Flag)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // زر الإبلاغ
                OutlinedButton.icon(
                  onPressed: () =>
                      _showFlagConfirmation(context, controller, review.id),
                  icon: const Icon(
                    Icons.flag_outlined,
                    size: 16,
                    color: Colors.red,
                  ),
                  label: const Text(
                    'إبلاغ',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // زر التفاعل
                OutlinedButton.icon(
                  onPressed: () =>
                      controller.reactToReview(review.id, 'helpful'),
                  icon: const Icon(
                    Icons.thumb_up_alt_outlined,
                    size: 16,
                    color: Colors.blue,
                  ),
                  label: const Text(
                    'مفيد',
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blueAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // زر الرد
                ElevatedButton.icon(
                  onPressed: () =>
                      _showResponseDialog(context, controller, review.id),
                  icon: const Icon(Icons.reply, size: 16),
                  label: const Text('رد', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < value ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 14,
              );
            }),
          ),
        ],
      ),
    );
  }

  // نافذة منبثقة لكتابة الرد
  void _showResponseDialog(
    BuildContext context,
    MyReviewController controller,
    int reviewId,
  ) {
    final TextEditingController textEditingController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('الرد على التقييم'),
        content: TextField(
          controller: textEditingController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'اكتب ردك الاحترافي هنا...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (textEditingController.text.isNotEmpty) {
                controller.respondToReview(
                  reviewId,
                  textEditingController.text,
                );
              }
            },
            child: const Text('إرسال الرد'),
          ),
        ],
      ),
    );
  }

  // تأكيد الإبلاغ
  void _showFlagConfirmation(
    BuildContext context,
    MyReviewController controller,
    int reviewId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الإبلاغ'),
        content: const Text(
          'هل أنت متأكد من رغبتك في الإبلاغ عن هذا التقييم لمراجعته من قبل الإدارة؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              controller.flagReview(reviewId);
            },
            child: const Text(
              'تأكيد الإبلاغ',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
