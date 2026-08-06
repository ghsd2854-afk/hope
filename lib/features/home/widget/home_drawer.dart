import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hobe/app_routes.dart';
import 'package:hobe/core/theme/theme_controller.dart';
import 'package:hobe/features/auth/services/auth_services.dart';
import 'package:hobe/features/profiles/controller/profile_controller.dart';
import 'package:hobe/features/profiles/view/profile_screen.dart';
// استيراد شاشة التنبيهات
import 'package:hobe/features/home/screens/JobAlertsScreen.dart';

import '../../../core/theme/colors.dart';

class HomeDrawer extends StatelessWidget {
  HomeDrawer({super.key});

  final themeController = Get.find<ThemeController>();
  final box = GetStorage();

  final AuthService _authService = AuthService();

  void _logout() {
    Get.defaultDialog(
      title: "تسجيل الخروج",
      middleText: "هل أنت متأكد من تسجيل الخروج؟",
      textConfirm: "خروج",
      textCancel: "إلغاء",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        try {
          await _authService.logout();
        } catch (e) {
          print(e);
        }

        await box.erase();

        if (Get.isRegistered<ProfileController>()) {
          Get.delete<ProfileController>(force: true);
        }

        Get.offAllNamed(AppRoutes.login);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName = box.read("name") ?? "المستخدم";
    final userEmail = box.read("email") ?? "";

    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryStart, AppColors.primaryEnd],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person, size: 30),
                ),
                const SizedBox(height: 10),
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (userEmail.toString().isNotEmpty)
                  Text(
                    userEmail,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
              ],
            ),
          ),

          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text("Dark Mode"),
            trailing: Obx(
              () => Switch(
                value: themeController.isDark.value,
                onChanged: (val) {
                  themeController.toggleTheme();
                },
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text("chat"),
            onTap: () => Get.toNamed(AppRoutes.CONVERSATIONS_LIST),
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("profile"),
            onTap: () {
              Get.back();
              Get.to(() => ProfileEditScreen());
            },
          ),

          ListTile(
            leading: const Icon(Icons.bookmark_outline),
            title: const Text("Saved"),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.savedJobs);
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment_outlined),
            title: const Text("My Activites"),
            onTap: () {
              Get.back(); // لإغلاق الـ Drawer أولاً
              Get.toNamed(AppRoutes.myActivities);
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_active_outlined),
            title: const Text("تنبيهاتي"),
            onTap: () {
              Get.back();
              Get.to(() => JobAlertsScreen());
            },
          ),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("الإعدادات"),
            onTap: () => Get.toNamed(AppRoutes.Settings),
          ),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "تسجيل الخروج",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Get.back();
              _logout();
            },
          ),
        ],
      ),
    );
  }
}
