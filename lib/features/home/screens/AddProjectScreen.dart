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
              controller: controller.summaryController,
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
            DropdownButtonFormField<String>(
              value: controller.selectedCategory.value.isNotEmpty
                  ? controller.selectedCategory.value
                  : null,
              items: ['tech', 'environment', 'services']
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e == 'tech'
                            ? 'تكنولوجيا'
                            : e == 'environment'
                            ? 'بيئة'
                            : 'خدمات',
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (val) =>
                  controller.selectedCategory.value = val.toString(),
              decoration: InputDecoration(
                labelText: "التصنيف",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // حقل المرحلة الجديد
            DropdownButtonFormField<String>(
              value: controller.selectedStage.value.isNotEmpty
                  ? controller.selectedStage.value
                  : null,
              items: ['idea', 'development', 'launch']
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e == 'idea'
                            ? 'فكرة'
                            : e == 'development'
                            ? 'تطوير'
                            : 'إطلاق',
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (val) =>
                  controller.selectedStage.value = val.toString(),
              decoration: InputDecoration(
                labelText: "المرحلة",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // حقل هدف التمويل الجديد (يُفضّل أن يكون رقمياً)
            TextFormField(
              controller: controller.fundingGoalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "هدف التمويل (أرقام فقط)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // حقل الموقع
            TextFormField(
              controller: controller.locationController,
              decoration: InputDecoration(
                labelText: "الموقع",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // حقل الرابط (يُفضّل أن يكون رابطاً صحيحاً مثل https://...)
            TextFormField(
              controller: controller.websiteUrlController,
              decoration: InputDecoration(
                labelText: "رابط الموقع الإلكتروني",
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
