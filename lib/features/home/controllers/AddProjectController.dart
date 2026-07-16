import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AddProjectController extends GetxController {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final fundingGoalController = TextEditingController(); // جديد

  var selectedCategory = 'تكنولوجيا'.obs;
  var selectedStage = 'فكرة'.obs; // جديد
  var isFunding = false.obs;
  var isMentorship = false.obs;

  void submitProject() {
    print("تم نشر المشروع: ${titleController.text}");
  }
}
