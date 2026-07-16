import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/Icons_home/controller/notification_controller.dart';


class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(NotificationsController());

    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: Obx(() => ListView.builder(
            itemCount: c.notifications.length,
            itemBuilder: (_, i) => ListTile(
              leading: const Icon(Icons.notifications),
              title: Text(c.notifications[i]),
            ),
          )),
    );
  }
}