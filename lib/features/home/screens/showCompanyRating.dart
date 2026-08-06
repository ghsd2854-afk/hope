import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/home/controllers/CompanyRatingController.dart';

void showCompanyRatingDialog(BuildContext context, int companyId) {
  final controller = Get.isRegistered<CompanyRatingController>()
      ? Get.find<CompanyRatingController>()
      : Get.put(CompanyRatingController());

  controller.clearForm();

  final titleController = TextEditingController();
  final prosController = TextEditingController();
  final consController = TextEditingController();
  final adviceController = TextEditingController();

  // تم تعديل تصميم صف التقييم ليصبح عمودياً (Column) لمنع الـ Overflow تماماً
  Widget buildRatingRow(String label, RxInt ratingObs) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(5, (index) {
                return IconButton(
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  icon: Icon(
                    index < ratingObs.value ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 26, // تكبير النجوم قليلاً لتصبح مريحة بالضغط
                  ),
                  onPressed: () => ratingObs.value = index + 1,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "تقييم الشركة",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              const SizedBox(height: 4),

              buildRatingRow(
                "التقييم العام (Overall):",
                controller.overallRating,
              ),
              buildRatingRow("بيئة العمل:", controller.workEnvironmentRating),
              buildRatingRow(
                "الرواتب والمزايا:",
                controller.salaryBenefitsRating,
              ),
              buildRatingRow(
                "التوازن بين الحياة والعمل:",
                controller.workLifeBalanceRating,
              ),
              buildRatingRow(
                "تجربة المقابلة:",
                controller.interviewExperienceRating,
              ),

              const SizedBox(height: 12),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "عنوان التقييم (مثال: شركة ممتازة)",
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: prosController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "الإيجابيات (Pros)",
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: consController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "السلبيات (Cons)",
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: adviceController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "نصيحة للإدارة (Advice)",
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "هل تنصح بالعمل هنا؟",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  Obx(
                    () => Switch(
                      value: controller.wouldRecommend.value == 1,
                      onChanged: (val) =>
                          controller.wouldRecommend.value = val ? 1 : 0,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "إرسال التقييم بشكل مجهول (Anonymous)",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  Obx(
                    () => Checkbox(
                      value: controller.isAnonymous.value == 1,
                      onChanged: (val) =>
                          controller.isAnonymous.value = val! ? 1 : 0,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        "إلغاء",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                                controller.submitReview(
                                  companyId,
                                  title: titleController.text.trim(),
                                  pros: prosController.text.trim(),
                                  cons: consController.text.trim(),
                                  advice: adviceController.text.trim(),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "إرسال",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
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
}
