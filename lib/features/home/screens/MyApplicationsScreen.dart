import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/home/controllers/MyApplicationsController.dart';
import 'package:hobe/features/home/models/MyApplicationsPaginatedModel.dart';
import 'package:hobe/features/home/screens/ApplicationDetailsScreen.dart';

class MyApplicationsScreen extends StatelessWidget {
  final MyApplicationsController controller = Get.put(
    MyApplicationsController(),
  );

  MyApplicationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'طلباتي المقدمة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          // زر سجل الانسحابات في الـ AppBar
          IconButton(
            icon: const Icon(Icons.history_rounded, color: Colors.blueAccent),
            tooltip: 'سجل الانسحابات',
            onPressed: () => _showWithdrawalsBottomSheet(context),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.applicationsList.isEmpty) {
          return const Center(child: Text('لا توجد طلبات مقدمة حالياً'));
        }

        return RefreshIndicator(
          onRefresh: controller.fetchMyApplications,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.applicationsList.length,
            itemBuilder: (context, index) {
              final app = controller.applicationsList[index];
              return ApplicationCard(
                application: app,
                onTap: () =>
                    Get.to(() => ApplicationDetailsScreen(application: app)),
                onWithdraw: () => _showWithdrawDialog(context, app.id),
              );
            },
          ),
        );
      }),
    );
  }

  // نافذة عريضة من الأسفل لتنسيق سجل الانسحابات بشكل أنيق
  // نافذة عريضة من الأسفل لتنسيق سجل الانسحابات مع البيانات الجديدة
  void _showWithdrawalsBottomSheet(BuildContext context) {
    controller.fetchMyWithdrawals();

    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.65,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Text(
              'سجل الطلبات المسحوبة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                if (controller.isLoadingWithdrawals.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.withdrawalsList.isEmpty) {
                  return const Center(
                    child: Text('لا يوجد سجل انسحابات حالياً'),
                  );
                }

                return ListView.separated(
                  itemCount: controller.withdrawalsList.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = controller.withdrawalsList[index];
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFFFEBEE),
                            child: Icon(
                              Icons.undo_rounded,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            item.jobTitle ??
                                'طلب رقم #${item.jobApplicationId}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                'السبب: ${controller.withdrawReasons[item.reasonCategory] ?? item.reasonCategory}',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 13,
                                ),
                              ),
                              // عرض المكان ونوع الوظيفة من الموديل المعدل
                              if (item.location != null ||
                                  item.jobType != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  '${item.location ?? ''} • ${item.jobType ?? ''}',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          trailing: Text(
                            item.createdAt != null
                                ? item.createdAt!.split('T').first
                                : '',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 11,
                            ),
                          ),
                        ),

                        // زر إعادة التقديم يستغل الخاصية الجديدة canReapply
                        //  if (item.canReapply)
                        /* Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () {
                                Get.back(); // إغلاق نافذة السجل السفلية أولاً

                                if (item.jobPostId != null) {
                                  // 2. الانتقال لصفحة تفاصيل الوظيفة
                                  Get.to(
                                    () => JobDetailsScreen(
                                      jobId: item.jobPostId!,
                                    ),
                                  )?.then((_) {
                                    // 3. إعادة جلب البيانات عند فتح الشاشة
                                    if (Get.isRegistered<
                                      JobDetailsController
                                    >()) {
                                      Get.find<JobDetailsController>()
                                          .fetchJobDetails(
                                            item.jobPostId!,
                                            forceRefresh: true,
                                          );
                                    }
                                  });
                                } else {
                                  Get.snackbar(
                                    'تنبيه',
                                    'تعذر الوصول لمعرف الوظيفة',
                                  );
                                }
                              },
                              icon: const Icon(Icons.refresh, size: 16),
                              label: const Text('إعادة التقديم'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.blueAccent,
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ),*/
                      ],
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showWithdrawDialog(BuildContext context, int appId) async {
    String? selectedReasonKey;

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    await controller.fetchWithdrawReasons();
    Get.back();

    if (controller.withdrawReasons.isEmpty) {
      Get.snackbar('خطأ', 'تعذر جلب الأسباب، حاول مجدداً');
      return;
    }

    Get.defaultDialog(
      title: 'سحب الطلب',
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: [
              const Text('يرجى اختيار سبب انسحابك من الطلب:'),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedReasonKey,
                hint: const Text('اختر السبب'),
                isExpanded: true,
                items: controller.withdrawReasons.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedReasonKey = val;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      textConfirm: 'تأكيد السحب',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () {
        if (selectedReasonKey == null || selectedReasonKey!.isEmpty) {
          Get.snackbar(
            'تنبيه',
            'يجب اختيار سبب الانسحاب أولاً',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          return;
        }
        Get.back();
        controller.withdrawApplication(appId, selectedReasonKey!);
      },
    );
  }
}

class ApplicationCard extends StatelessWidget {
  final MyApplicationItemModel application;
  final VoidCallback onTap;
  final VoidCallback onWithdraw;

  const ApplicationCard({
    Key? key,
    required this.application,
    required this.onTap,
    required this.onWithdraw,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final job = application.jobPost;

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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // رأس الكرت (اسم الوظيفة + حالة الطلب)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        job?.title ?? 'طلب وظيفة',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildStatusChip(application.status),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  job?.company?.companyName ?? '',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                const Divider(height: 24),
                // التفاصيل السريعة
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      job?.location ?? 'غير محدد',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.work_outline, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      job?.type ?? '',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // زر سحب الطلب
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: application.status == 'pending'
                        ? onWithdraw
                        : null,
                    icon: const Icon(
                      Icons.undo_rounded,
                      size: 18,
                      color: Colors.redAccent,
                    ),
                    label: const Text(
                      'سحب الطلب',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = Colors.orange;
    String label = 'قيد المراجعة';

    if (status == 'accepted') {
      color = Colors.green;
      label = 'مقبول';
    } else if (status == 'rejected' || status == 'withdrawn') {
      color = Colors.red;
      label = status == 'withdrawn' ? 'مسحوب' : 'مرفوض';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
