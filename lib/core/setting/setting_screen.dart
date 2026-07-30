import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/app_routes.dart';
import 'package:hobe/core/localization/language_controller.dart';
import 'package:hobe/core/theme/theme_controller.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
   

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),

      body: ListView(
        children: [

          const SizedBox(height: 10),
ListTile(
  leading: const Icon(Icons.block),
  title: const Text('المستخدمون والشركات المحظورة'),
  onTap: () {
    Get.toNamed(AppRoutes.BLOCKED_LIST);
    // أو مباشرة:
    // Get.to(() => const BlockedListScreen());
  },
),
     
          const Divider(),
ListTile(
  leading: const Icon(Icons.account_balance),
  title: const Text('my account'),
  onTap: () {
    Get.toNamed(AppRoutes.myAccount);
    // أو مباشرة:
    // Get.to(() => const BlockedListScreen());
  },
),
     
          const Divider(),
          ListTile(
  leading: const Icon(Icons.download_for_offline_outlined),
  title: const Text('تصدير بياناتي'),
  onTap: () => Get.toNamed(AppRoutes.DATA_EXPORT),
),

          // 🌍 Language
       
        ],
      ),
    );
  }
}