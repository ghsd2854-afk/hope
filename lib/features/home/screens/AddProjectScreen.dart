import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/home/controllers/AddProjectController.dart';

class AddProjectScreen extends StatelessWidget {
  final AddProjectController controller = Get.put(AddProjectController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إضافة فكرة مشروع")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: controller.titleController,
              decoration: InputDecoration(
                labelText: "عنوان المشروع",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: "ملخص قصير",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              maxLines: 3,
              controller: controller.descController,
              decoration: InputDecoration(
                labelText: "الوصف الكامل",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField(
              items: [
                'تكنولوجيا',
                'بيئة',
                'خدمات',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) =>
                  controller.selectedCategory.value = val.toString(),
              decoration: InputDecoration(
                labelText: "التصنيف",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // حقل المرحلة الجديد
            DropdownButtonFormField(
              items: [
                'فكرة',
                'تطوير',
                'إطلاق',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) =>
                  controller.selectedStage.value = val.toString(),
              decoration: InputDecoration(
                labelText: "المرحلة",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // حقل هدف التمويل الجديد
            TextFormField(
              controller: controller.fundingGoalController,
              decoration: InputDecoration(
                labelText: "هدف التمويل",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // عنوان النوع المطلوب
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "النوع المطلوب",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                Obx(
                  () => Checkbox(
                    value: controller.isFunding.value,
                    onChanged: (v) => controller.isFunding.value = v!,
                  ),
                ),
                Text("تمويل"),
                Obx(
                  () => Checkbox(
                    value: controller.isMentorship.value,
                    onChanged: (v) => controller.isMentorship.value = v!,
                  ),
                ),
                Text("إرشاد"),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: Text("إلغاء"),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.submitProject,
                    child: Text("نشر الفكرة"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
