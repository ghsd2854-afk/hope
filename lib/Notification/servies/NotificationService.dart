import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';

class NotificationService {
  // 1. جلب كل الإشعارات
  Future<dynamic> getNotifications() async {
    final response = await DioService().dio.get(ApiConstants.notifications);
    return response.data;
  }

  // 2. جلب عدد الإشعارات غير المقروءة
  Future<dynamic> getUnreadCount() async {
    final response = await DioService().dio.get(
      ApiConstants.notificationsUnreadCount,
    );
    return response.data;
  }

  // 3. تحديد الكل كمقروء
  Future<dynamic> markAllAsRead() async {
    final response = await DioService().dio.post(
      ApiConstants.notificationsReadAll,
    );
    return response.data;
  }

  // 4. تحديد إشعار محدد كمقروء
  Future<dynamic> markAsRead(int id) async {
    final response = await DioService().dio.post(
      ApiConstants.notificationRead(id),
    );
    return response.data;
  }

  Future<void> sendFCMTokenToBackend() async {
    try {
      print("🚀 [FCM_DEBUG] بدأت دالة إرسال التوكن..."); // 🌟 ضعي هذه
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        print("🔑 [FCM_DEBUG] التوكن الجاهز للإرسال: $fcmToken"); // 🌟 وهذه

        final response = await DioService().dio.post(
          ApiConstants.saveFCMToken,
          data: {'fcm_token': fcmToken},
        );

        print("✅ [FCM_DEBUG] تم حفظ التوكن بنجاح! الاستجابة: ${response.data}");
      } else {
        print("⚠️ [FCM_DEBUG] لم يتم جلب الـ Token من الجهاز.");
      }
    } catch (e) {
      print("❌ [FCM_DEBUG] خطأ في إرسال التوكن: $e");
    }
  }
}
