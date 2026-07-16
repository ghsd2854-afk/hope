/*/import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/home/controllers/project_controller.dart';
import 'package:hobe/features/home/screens/AddProjectScreen.dart';

class ProjectScreen extends StatelessWidget {
  final ProjectController controller = Get.put(ProjectController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        //  title: Text("مشاريع Hobe"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "بحث عن المشاريع...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.projects.length,
                itemBuilder: (context, index) {
                  // p هنا أصبح من نوع Project مباشرة
                  final p = controller.projects[index];

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          // الدائرة والنسبة المئوية (بدون تحويلات معقدة الآن)
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: CircularProgressIndicator(
                                  value: p.progress,
                                  strokeWidth: 6,
                                ),
                              ),
                              Text("${(p.progress * 100).toInt()}%"),
                            ],
                          ),
                          SizedBox(width: 15),
                          // معلومات المشروع
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text("القطاع: ${p.sector}"),
                                Text("المرحلة: ${p.stage}"),
                                ElevatedButton(
                                  onPressed: () {
                                    // الانتقال لصفحة التفاصيل
                                    print("الانتقال لتفاصيل: ${p.title}");
                                  },
                                  child: Text("عرض التفاصيل"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: FloatingActionButton(
          onPressed: () => Get.to(() => AddProjectScreen()),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
*/
