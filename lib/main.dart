import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hobe/Notification/controller/NotificationController.dart';
import 'package:hobe/app_pages.dart';
import 'package:hobe/app_routes.dart';
import 'package:hobe/core/theme/colors.dart';
import 'package:hobe/core/theme/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  await Firebase.initializeApp();

  Get.put(ThemeController());

  // طلب إذن الإشعارات
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  String? token = await messaging.getToken();
  print("FCM Token: $token");

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('------------------------------------');
    print('وصل إشعار فايربيس جديد!');
    print('العنوان: ${message.notification?.title}');
    print('النص: ${message.notification?.body}');
    print('البيانات: ${message.data}');
    print('------------------------------------');

    if (message.notification != null) {
      Get.snackbar(
        message.notification!.title ?? 'إشعار جديد',
        message.notification!.body ?? '',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.primaryEnd,
        colorText: Colors.white,
      );

      if (Get.isRegistered<NotificationController>()) {
        Get.find<NotificationController>().fetchNotifications();
      }
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}
