import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';

class MyActivities extends StatelessWidget {
  const MyActivities({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: Obx(() {
        final items = controller.MyActivitiesPosts;

        if (items.isEmpty) {
          return const Center(child: Text("No liked posts"));
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) {
            final p = items[i];
            return ListTile(title: Text(p.title), subtitle: Text(p.desc));
          },
        );
      }),
    );
  }
}
