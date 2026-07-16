import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hobe/features/Icons_home/controller/JobController.dart';
import 'package:hobe/features/home/widget/JobCard.dart';

class SavedJobsScreen extends StatelessWidget {
  final JobController controller = Get.find<JobController>();

  @override
  Widget build(BuildContext context) {
    controller.fetchSavedJobs();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("محفوظاتي", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(() {
        if (controller.isSavedLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF9472D9)),
          );
        }

        if (controller.savedJobPosts.isEmpty) {
          return const Center(child: Text("لا توجد وظائف محفوظة حالياً"));
        }

        return ListView.builder(
          itemCount: controller.savedJobPosts.length,
          itemBuilder: (context, index) {
            final job = controller.savedJobPosts[index];
            return JobCard(job: job, controller: controller);
          },
        );
      }),
    );
  }
}
