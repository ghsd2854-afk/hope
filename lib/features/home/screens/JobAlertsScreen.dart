import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/home/controllers/JobAlertController.dart';
import 'package:hobe/features/home/models/JobAlertModel.dart';

class JobAlertsScreen extends StatelessWidget {
  final JobAlertController controller = Get.isRegistered<JobAlertController>()
      ? Get.find<JobAlertController>()
      : Get.put(JobAlertController());

  JobAlertsScreen({super.key});

  // نافذة الإنشاء أو التعديل (نفس النافذة مع دعم تمرير التنبيه في حال التعديل)
  void _showJobAlertBottomSheet(
    BuildContext context, {
    JobAlertModel? alertToEdit,
  }) {
    final bool isEditing = alertToEdit != null;

    final TextEditingController nameController = TextEditingController(
      text: alertToEdit?.name ?? '',
    );
    final TextEditingController locationController = TextEditingController(
      text: alertToEdit?.criteria.location ?? '',
    );
    final TextEditingController keywordsController = TextEditingController(
      text: alertToEdit?.criteria.keywords?.join(', ') ?? '',
    );
    final TextEditingController salaryMinController = TextEditingController(
      text: alertToEdit?.criteria.salaryMin?.toString() ?? '',
    );
    final TextEditingController salaryMaxController = TextEditingController(
      text: alertToEdit?.criteria.salaryMax?.toString() ?? '',
    );

    String selectedFrequency = alertToEdit?.frequency ?? "daily";
    String selectedJobType = alertToEdit?.criteria.jobType?.isNotEmpty == true
        ? alertToEdit!.criteria.jobType!.first
        : "full_time";
    bool isRemote = alertToEdit?.criteria.remote ?? true;
    bool notifyEmail = alertToEdit?.notifyEmail ?? true;
    bool notifyPush = alertToEdit?.notifyPush ?? true;
    bool notifySms = alertToEdit?.notifySms ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEditing
                              ? "تعديل التنبيه الوظيفي"
                              : "إنشاء تنبيه وظيفي متقدم",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 10),

                    // اسم التنبيه
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "اسم التنبيه (مثال: Laravel Jobs)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // الموقع
                    TextField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        labelText: "الموقع (مثال: Damascus)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // الكلمات المفتاحية
                    TextField(
                      controller: keywordsController,
                      decoration: const InputDecoration(
                        labelText:
                            "الكلمات المفتاحية مفصولة بفاصلة (laravel, PHP)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // حقول الرواتب
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: salaryMinController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "الراتب الأدنى",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: salaryMaxController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "الراتب الأقصى",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // نوع الوظيفة والتكرار
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedJobType,
                            decoration: const InputDecoration(
                              labelText: "نوع الوظيفة",
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: "full_time",
                                child: Text("دوام كامل"),
                              ),
                              DropdownMenuItem(
                                value: "part_time",
                                child: Text("دوام جزئي"),
                              ),
                              DropdownMenuItem(
                                value: "internship",
                                child: Text("تدريب"),
                              ),
                            ],
                            onChanged: (val) {
                              setStateModal(() => selectedJobType = val!);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedFrequency,
                            decoration: const InputDecoration(
                              labelText: "التكرار",
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: "daily",
                                child: Text("يومي"),
                              ),
                              DropdownMenuItem(
                                value: "weekly",
                                child: Text("أسبوعي"),
                              ),
                            ],
                            onChanged: (val) {
                              setStateModal(() => selectedFrequency = val!);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // خيارات التبديل
                    SwitchListTile(
                      title: const Text("عمل عن بعد (Remote)"),
                      value: isRemote,
                      onChanged: (val) => setStateModal(() => isRemote = val),
                    ),
                    SwitchListTile(
                      title: const Text("إشعار عبر البريد (Email)"),
                      value: notifyEmail,
                      onChanged: (val) =>
                          setStateModal(() => notifyEmail = val),
                    ),
                    SwitchListTile(
                      title: const Text("إشعار فوري (Push)"),
                      value: notifyPush,
                      onChanged: (val) => setStateModal(() => notifyPush = val),
                    ),
                    SwitchListTile(
                      title: const Text("إشعار رسائل (SMS)"),
                      value: notifySms,
                      onChanged: (val) => setStateModal(() => notifySms = val),
                    ),

                    const SizedBox(height: 15),

                    // زر الحفظ / التعديل
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          List<String> keywordsList = keywordsController.text
                              .split(',')
                              .map((e) => e.trim())
                              .where((e) => e.isNotEmpty)
                              .toList();

                          if (nameController.text.isEmpty) {
                            Get.snackbar(
                              "تنبيه",
                              "الرجاء إدخال اسم التنبيه على الأقل",
                            );
                            return;
                          }

                          int? minSalary =
                              salaryMinController.text.trim().isEmpty
                              ? null
                              : int.tryParse(salaryMinController.text.trim());
                          int? maxSalary =
                              salaryMaxController.text.trim().isEmpty
                              ? null
                              : int.tryParse(salaryMaxController.text.trim());

                          JobAlertModel alertModel = JobAlertModel(
                            id: isEditing ? alertToEdit.id : null,
                            name: nameController.text.trim(),
                            frequency: selectedFrequency,
                            notifyEmail: notifyEmail,
                            notifyPush: notifyPush,
                            notifySms: notifySms,
                            isActive: isEditing ? alertToEdit.isActive : true,
                            criteria: JobCriteria(
                              location: locationController.text.trim().isEmpty
                                  ? null
                                  : locationController.text.trim(),
                              remote: isRemote,
                              salaryMin: minSalary,
                              salaryMax: maxSalary,
                              keywords: keywordsList,
                              jobType: [selectedJobType],
                              categories: [1],
                            ),
                          );

                          if (isEditing) {
                            // استدعاء تابع التعديل في الكونترولر
                            controller.updateJobAlert(
                              alertToEdit.id!,
                              alertModel,
                            );
                          } else {
                            // استدعاء تابع الإنشاء في الكونترولر
                            controller.createJobAlert(alertModel);
                          }

                          Navigator.pop(context);
                        },
                        child: Text(
                          isEditing ? "تحديث التنبيه" : "حفظ التنبيه",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "تنبيهاتي الوظيفية",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.jobAlertsList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.jobAlertsList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off_outlined,
                  size: 70,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 10),
                const Text(
                  "لا توجد تنبيهات مضافة حالياً",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.jobAlertsList.length,
          itemBuilder: (context, index) {
            final alert = controller.jobAlertsList[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            alert.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        // 1. ربط زر التفعيل والتعطيل (Switch) بالتابع toggleAlertStatus
                        Switch(
                          value: alert.isActive,
                          onChanged: (val) {
                            if (alert.id != null) {
                              controller.toggleAlertStatus(alert.id!);
                            }
                          },
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          alert.criteria.location ?? "الكل",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Icon(
                          Icons.work_outline,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          alert.frequency,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      children: (alert.criteria.keywords ?? []).map((keyword) {
                        return Chip(
                          label: Text(
                            keyword,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.blue,
                            ),
                          ),
                          backgroundColor: Colors.blue.withOpacity(0.08),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // 2. ربط زر التعديل بفتح النافذة مع تمرير بيانات التنبيه الحالي
                        TextButton.icon(
                          onPressed: () {
                            _showJobAlertBottomSheet(
                              context,
                              alertToEdit: alert,
                            );
                          },
                          icon: const Icon(
                            Icons.edit,
                            size: 16,
                            color: Colors.orange,
                          ),
                          label: const Text(
                            "تعديل",
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 3. ربط زر الحذف بالتابع deleteJobAlert
                        TextButton.icon(
                          onPressed: () {
                            if (alert.id != null) {
                              controller.deleteJobAlert(alert.id!);
                            }
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 16,
                            color: Colors.red,
                          ),
                          label: const Text(
                            "حذف",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showJobAlertBottomSheet(context);
        },
        label: const Text("إضافة تنبيه"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
