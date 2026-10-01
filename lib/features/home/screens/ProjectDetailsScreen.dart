import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/app_routes.dart';
import 'package:hobe/core/theme/colors.dart';
import 'package:hobe/features/Icons_home/models/JobPostModel.dart';
import 'package:hobe/features/home/controllers/ProjectDetailsController.dart';
import 'package:hobe/features/home/screens/CompanyProfileScreen.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final ProjectDetailsController controller = Get.put(
    ProjectDetailsController(),
  );

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "تفاصيل المشروع",
          style: TextStyle(
            color: isDarkMode ? AppColors.textDarkPrimary : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkMode ? AppColors.textDarkPrimary : Colors.white,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.edit, color: Colors.blueAccent),
              onPressed: () async {
                // الانتظار حتى العودة وتحديث بيانات المشروع في حال تم التعديل
                var result = await Get.toNamed(
                  AppRoutes.addProject,
                  arguments: controller.project.value,
                );
                if (result != null) {
                  controller.fetchProjectDetails();
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () {
                Get.defaultDialog(
                  title: "تأكيد الحذف",
                  titleStyle: const TextStyle(fontWeight: FontWeight.bold),
                  middleText: "هل أنت متأكد من رغبتك في حذف هذا المشروع؟",
                  textConfirm: "نعم، حذف",
                  textCancel: "إلغاء",
                  confirmTextColor: Colors.white,
                  buttonColor: Colors.red,
                  onConfirm: () {
                    Get.back();
                    controller.deleteProject();
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 280,
            child: CustomPaint(
              painter: WavyHeaderPainter(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDarkMode
                      ? [AppColors.darkCard, AppColors.Selection]
                      : [AppColors.primaryStart, AppColors.primaryEnd],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.primaryEnd),
                );
              }

              final proj = controller.project.value;

              if (proj.title == null) {
                return Center(
                  child: Text(
                    "لا توجد بيانات متاحة",
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode
                          ? AppColors.textDarkPrimary
                          : AppColors.textLightPrimary,
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppColors.darkCard
                            : AppColors.lightCard,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  proj.title ?? '',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? AppColors.textDarkPrimary
                                        : AppColors.textLightPrimary,
                                  ),
                                ),
                              ),
                              Chip(
                                label: Text(
                                  proj.status ?? 'مفعل',
                                  style: TextStyle(
                                    color: Colors.orange[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                backgroundColor: Colors.orange.withOpacity(
                                  0.15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Chip(
                            label: Text(
                              proj.category ?? 'عام',
                              style: TextStyle(
                                color: Colors.teal[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: Colors.teal.withOpacity(0.15),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "الملخص:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.primaryEnd,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            proj.summary ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode
                                  ? Colors.grey[300]
                                  : AppColors.textLightPrimary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppColors.darkCard
                            : AppColors.lightCard,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "الوصف الكامل:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.primaryEnd,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            proj.description ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode
                                  ? Colors.grey[300]
                                  : AppColors.textLightPrimary,
                              height: 1.5,
                            ),
                          ),
                          const Divider(height: 30, thickness: 1),
                          _buildDetailRow(
                            Icons.trending_up,
                            "المرحلة",
                            proj.stage ?? '',
                            isDarkMode,
                          ),
                          _buildDetailRow(
                            Icons.monetization_on,
                            "هدف التمويل",
                            "${proj.fundingGoal ?? 'غير محدد'}",
                            isDarkMode,
                          ),
                          _buildDetailRow(
                            Icons.location_on,
                            "الموقع",
                            proj.location ?? 'غير محدد',
                            isDarkMode,
                          ),
                          _buildDetailRow(
                            Icons.link,
                            "رابط الموقع",
                            proj.websiteUrl ?? 'لا يوجد',
                            isDarkMode,
                          ),
                          _buildDetailRow(
                            Icons.visibility,
                            "عدد المشاهدات",
                            "${proj.views ?? 0}",
                            isDarkMode,
                          ),
                          _buildDetailRow(
                            Icons.local_offer,
                            "عدد العروض",
                            "${proj.offersCount ?? 0}",
                            isDarkMode,
                          ),
                        ],
                      ),
                    ),
                    // استبدل الـ Wrap القديم بهذا الكود:
                    if (proj.interests != null &&
                        proj.interests!.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text(
                        "الاهتمامات:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: isDarkMode
                              ? Colors.white
                              : AppColors.textLightPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10.0,
                        runSpacing: 10.0,
                        children: proj.interests!.map((interest) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? AppColors.darkCard.withOpacity(0.5)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: AppColors.primaryStart.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    //Get.to(
                                    // () => CompanyProfileScreen(),
                                    //   //          arguments: job.company!.id,
                                    //   );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                      4.0,
                                    ), // إضافة مساحة صغيرة للضغط
                                    child: Text(
                                      interest['company'] != null
                                          ? interest['company']['company_name']
                                          : 'شركة غير معروفة',
                                      style: TextStyle(
                                        // لون أزرق ليدل على أنه رابط
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                        // وضع خط تحت النص ليعرف المستخدم أنه رابط
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                // زر القبول
                                GestureDetector(
                                  onTap: () =>
                                      controller.acceptInterest(interest),
                                  child: const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                // زر الرفض
                                GestureDetector(
                                  onTap: () =>
                                      controller.rejectInterest(interest),
                                  child: const Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                    size: 22,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    if (proj.invitations != null &&
                        proj.invitations!.isNotEmpty) ...[
                      const SizedBox(height: 25),
                      Text(
                        "الشركات المدعوة:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: isDarkMode
                              ? Colors.white
                              : AppColors.textLightPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...proj.invitations!.map((inv) {
                        var companyName =
                            inv['company']?['company_name'] ?? 'شركة';
                        var invStatus = inv['status'] ?? 'pending';
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? AppColors.darkCard
                                : AppColors.lightCard,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primaryStart
                                  .withOpacity(0.5),
                              child: const Icon(
                                Icons.business,
                                color: AppColors.Selection,
                              ),
                            ),
                            title: Text(
                              companyName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDarkMode
                                    ? Colors.white
                                    : AppColors.textLightPrimary,
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: invStatus == 'pending'
                                    ? Colors.orange.withOpacity(0.15)
                                    : Colors.green.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "الحالة: $invStatus",
                                style: TextStyle(
                                  color: invStatus == 'pending'
                                      ? Colors.orange[800]
                                      : Colors.green[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                    const SizedBox(height: 30),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String title,
    String value,
    bool isDarkMode,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryEnd),
          const SizedBox(width: 12),
          Text(
            "$title: ",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : AppColors.textLightPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class WavyHeaderPainter extends CustomPainter {
  final Gradient gradient;

  WavyHeaderPainter({required this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.lineTo(0, size.height - 40);

    firstCurve(path, size);

    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  void firstCurve(Path path, Size size) {
    var controlPoint = Offset(size.width * 0.25, size.height);
    var endPoint = Offset(size.width * 0.5, size.height - 30);
    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    var controlPoint2 = Offset(size.width * 0.75, size.height - 60);
    var endPoint2 = Offset(size.width, size.height - 20);
    path.quadraticBezierTo(
      controlPoint2.dx,
      controlPoint2.dy,
      endPoint2.dx,
      endPoint2.dy,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
