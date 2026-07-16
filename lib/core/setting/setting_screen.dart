import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

          // 👤 Profile
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Get.toNamed("/profile");
            },
          ),

          const Divider(),

          // 🌙 Dark Mode
          Obx(() => SwitchListTile(
                title: const Text("Dark Mode"),
                value: themeController.isDark.value,
                onChanged: (value) {
                  themeController.toggleTheme();
                },
              )),

          const Divider(),

          // 🌍 Language
          Obx(() => Column(
                children: [
                
              

              
                ],
              )),
        ],
      ),
    );
  }
}