import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/Icons_home/controller/JobController.dart';
import '../../../core/theme/colors.dart';
import '../controllers/home_controller.dart';

class HomeChip extends StatelessWidget {
  final String text;
  final int index;

  const HomeChip({super.key, required this.text, required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      final selected = controller.selectedFilter.value == index;

      return GestureDetector(
        onTap: () {
          controller.selectedFilter.value = index; // تحديث الحالة
          Get.find<JobController>().filterJobsByCategory(index);
        },
        child: AnimatedContainer(
          // استخدام AnimatedContainer لنعومة الانتقال
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: selected ? AppColors.primaryStart : Colors.white,
            border: Border.all(
              color: selected
                  ? AppColors.primaryStart
                  : AppColors.primaryStart.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.primaryStart.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.primaryStart,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      );
    });
  }
}
