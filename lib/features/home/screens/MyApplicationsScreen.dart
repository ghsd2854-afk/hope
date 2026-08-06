import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/core/theme/colors.dart';
import 'package:hobe/features/home/controllers/MyApplicationsController.dart';

class MyApplicationsScreen extends GetView<MyApplicationsController> {
  const MyApplicationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyApplicationsController());
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryStart.withOpacity(isDark ? 0.15 : 0.4),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryEnd.withOpacity(isDark ? 0.1 : 0.3),
              ),
            ),
          ),

          // المحتوى الأساسي مع مسافة الأمان
          SafeArea(
            child: Column(
              children: [
                // AppBar مخصص وعصري متوافق مع الثيم
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ' MyApplications',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textDarkPrimary
                              : AppColors.textLightPrimary,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkCard
                              : AppColors.lightCard,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.refresh_rounded,
                            color: AppColors.primaryEnd,
                          ),
                          onPressed: () => controller.fetchMyApplications(),
                        ),
                      ),
                    ],
                  ),
                ),

                // محتوى القائمة
                Expanded(
                  child: Obx(() {
                    // 1. حالة التحميل
                    if (controller.isLoading.value &&
                        controller.applicationsList.isEmpty) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryEnd,
                          ),
                        ),
                      );
                    }

                    // 2. حالة القائمة الفارغة
                    if (controller.applicationsList.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.primaryEnd.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.assignment_outlined,
                                size: 56,
                                color: AppColors.primaryEnd,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'لا توجد طلبات مقدمة حالياً',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.textDarkPrimary
                                    : AppColors.textLightPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'اسحب لأسفل للتحديث أو قم بتقديم طلب جديد',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // 3. عرض البيانات بنجاح مع إضافة bottom padding لمنع تداخل الشريط السفلي
                    return RefreshIndicator(
                      color: AppColors.primaryEnd,
                      onRefresh: () async => controller.fetchMyApplications(),
                      child: ListView.builder(
                        itemCount: controller.applicationsList.length,
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 8,
                          bottom:
                              100, // مسافة أمان لتجنب تغطية شريط التنقل السفلي
                        ),
                        itemBuilder: (context, index) {
                          final item = controller.applicationsList[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkCard
                                  : AppColors.lightCard,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                    isDark ? 0.3 : 0.04,
                                  ),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withOpacity(0.05)
                                    : AppColors.border.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                leading: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryStart.withOpacity(
                                      0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.work_rounded,
                                    color: AppColors.primaryEnd,
                                  ),
                                ),
                                title: Text(
                                  'طلب رقم #${item.id ?? 'غير متوفر'}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: isDark
                                        ? AppColors.textDarkPrimary
                                        : AppColors.textLightPrimary,
                                  ),
                                ),
                                subtitle: const Padding(
                                  padding: EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    'تم إرسال الطلب بنجاح وهو قيد المراجعة',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
