import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/Notification/controller/NotificationController.dart';
import 'package:hobe/Notification/screen/NotificationDetailsScreen.dart';
import 'package:hobe/core/theme/colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "الإشعارات",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () => controller.markAllAsRead(),
            tooltip: "تحديد الكل كمقروء",
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryEnd),
          );
        }

        if (controller.notificationsList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off_outlined,
                  size: 64,
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
                const SizedBox(height: 12),
                const Text(
                  "لا توجد إشعارات حالياً",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: controller.notificationsList.length,
          itemBuilder: (context, index) {
            final notification = controller.notificationsList[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: notification.isRead
                    ? Theme.of(context).cardColor
                    : (isDarkMode
                          ? AppColors.darkCard
                          : AppColors.primaryStart.withOpacity(0.15)),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: notification.isRead
                      ? AppColors.border.withOpacity(0.5)
                      : AppColors.primaryEnd.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                leading: Icon(
                  Icons.notifications,
                  color: notification.isRead
                      ? AppColors.textSecondary
                      : AppColors.primaryEnd,
                ),
                title: Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight: notification.isRead
                        ? FontWeight.normal
                        : FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    notification.body,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
                trailing: Text(
                  notification.createdAt,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
                onTap: () {
                  // عند الضغط عليه نجعله مقروءاً ونحدث البيانات
                  controller.markAsRead(notification.id);
                  // 2. الانتقال إلى صفحة تفاصيل الإشعار مع تمرير بيانات الإشعار
                  Get.to(
                    () => NotificationDetailsScreen(notification: notification),
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }
}
