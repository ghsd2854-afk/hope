import 'package:get/get.dart';
import 'package:hobe/Notification/models/NotificationModel.dart';
import 'package:hobe/Notification/servies/NotificationService.dart';

class NotificationController extends GetxController {
  final NotificationService _notificationService = NotificationService();

  var isLoading = false.obs;
  var notificationsList = <NotificationModel>[].obs;
  //var unreadCount = 0.obs;
  RxInt unreadCount = 0.obs;
  @override
  void onInit() {
    fetchNotifications();
    fetchUnreadCount();
    super.onInit();
  }

  // 1. جلب الإشعارات
  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final response = await _notificationService.getNotifications();
      List data = response['data']['data'] ?? [];
      notificationsList.value = data
          .map((e) => NotificationModel.fromJson(e))
          .toList();
    } catch (e) {
      print("خطأ في جلب الإشعارات: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUnreadCount() async {
    try {
      final response = await NotificationService().getUnreadCount();
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        // الوصول إلى count داخل data
        unreadCount.value = response['data']['count'];
      }
    } catch (e) {
      print("خطأ في جلب عدد الإشعارات: $e");
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _notificationService.markAllAsRead();
      for (var item in notificationsList) {}
      fetchNotifications();
      unreadCount.value = 0;
      Get.snackbar("تم", "تم تحديد كل الإشعارات كمقروءة");
    } catch (e) {
      Get.snackbar("خطأ", e.toString());
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await _notificationService.markAsRead(id);
      fetchNotifications();
      fetchUnreadCount();
    } catch (e) {
      print("خطأ في تحديث حالة الإشعار: $e");
    }
  }
}
