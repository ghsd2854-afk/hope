import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hobe/app_routes.dart';
import 'package:hobe/core/theme/theme_controller.dart';
import 'package:hobe/features/auth/views/profile_screen.dart';
import '../../../core/theme/colors.dart';

class HomeDrawer extends StatelessWidget {
  HomeDrawer({super.key});
  final themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(radius: 30),
                SizedBox(height: 10),
                Text("Ghfran Hasan", style: TextStyle(color: Colors.white)),
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
            leading: const Icon(Icons.person),
            title: const Text("profile"),
            onTap: () {
              Get.back();
              Get.to(() => ProfileEditScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text("location"),
            subtitle: const Text("Rotterdam"),
            onTap: () {
              Get.back();
              Get.snackbar("location", "  select location successfuly");
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_outline), // أيقونة المحفوظات
            title: const Text("Saved"),
            onTap: () {
              Get.back(); // لإغلاق الـ Drawer
              Get.toNamed(AppRoutes.savedJobs); // الانتقال للصفحة الجديدة
            },
          ),
          const ListTile(
            leading: const Icon(Icons.settings),
            title: Text("setting"),
          ),
          const ListTile(
            leading: const Icon(Icons.logout),
            title: Text("logout "),
          ),
        ],
      ),
    );
  }
}
