import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/Icons_home/controller/follow_controller.dart';


class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(FavoritesController());

    return Scaffold(
      appBar: AppBar(title: const Text("Following")),
      body: Obx(() => ListView.builder(
            itemCount: c.users.length,
            itemBuilder: (_, i) => ListTile(
              leading: const CircleAvatar(),
              title: Text(c.users[i]),
            ),
          )),
    );
  }
}