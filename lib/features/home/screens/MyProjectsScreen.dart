import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/app_routes.dart';
import 'package:hobe/core/theme/colors.dart';
import 'package:hobe/features/home/controllers/MyProjectsController.dart';

class MyProjectsScreen extends StatelessWidget {
  final MyProjectsController controller = Get.put(MyProjectsController());

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      floatingActionButtonLocation: _CustomFloatingActionButtonLocation(
        FloatingActionButtonLocation.endFloat,
        0, // x offset
        -70, // y offset
      ),
      body: Stack(
        children: [
          // خلفية مموجة ومتموهة احترافية تتناسب مع الثيم
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryStart.withOpacity(isDark ? 0.15 : 0.4),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryEnd.withOpacity(isDark ? 0.1 : 0.3),
              ),
            ),
          ),

          // المحتوى الأساسي
          SafeArea(
            child: Column(
              children: [
                // AppBar مخصص وعصري
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "My Projects",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textDarkPrimary
                              : AppColors.textLightPrimary,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkCard
                              : AppColors.lightCard,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.refresh,
                            color: AppColors.primaryEnd,
                          ),
                          onPressed: () => controller.fetchMyProjects(),
                        ),
                      ),
                    ],
                  ),
                ),

                // محتوى القائمة
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryEnd,
                          ),
                        ),
                      );
                    }

                    if (controller.projectsList.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.folder_open_rounded,
                              size: 70,
                              color: AppColors.textSecondary.withOpacity(0.5),
                            ),
                            SizedBox(height: 12),
                            Text(
                              "لا توجد مشاريع مضافة حالياً",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: controller.projectsList.length,
                      // تمت زيادة الـ bottom padding لترتفع العناصر ولا تختفي خلف الشريط السفلي
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 10,
                        bottom: 300,
                      ),
                      itemBuilder: (context, index) {
                        final project = controller.projectsList[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkCard
                                : AppColors.lightCard,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                  isDark ? 0.3 : 0.04,
                                ),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withOpacity(0.05)
                                  : AppColors.border.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () async {
                                // الانتقال لواجهة التفاصيل مع تمرير الـ id الخاص بالمشروع
                                await Get.toNamed(
                                  AppRoutes.projectDetails,
                                  arguments: project['id'],
                                );
                                // تحديث القائمة عند العودة (في حال تم التعديل أو الحذف)
                                controller.fetchMyProjects();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.primaryStart,
                                            AppColors.primaryEnd,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.code_rounded,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            project['title'] ?? 'بدون عنوان',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: isDark
                                                  ? AppColors.textDarkPrimary
                                                  : AppColors.textLightPrimary,
                                            ),
                                          ),
                                          SizedBox(height: 6),
                                          Text(
                                            project['summary'] ?? '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: AppColors.textSecondary,
                                              height: 1.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryEnd.withOpacity(
                                          0.1,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 14,
                                        color: AppColors.primaryEnd,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),

      // زر الإضافة بتصميم متناسق وعائم
      floatingActionButton: Container(
        // احتفظ بالـ Container لتزيين الظل
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.Selection.withOpacity(0.4),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          elevation: 0,
          onPressed: () async {
            await Get.toNamed(AppRoutes.addProject);
            controller.fetchMyProjects();
          },
          child: Icon(Icons.add_rounded, size: 28, color: Colors.white),
          backgroundColor: AppColors.Selection,
        ),
      ),
      /* floatingActionButton: Transform.translate(
        offset: const Offset(
          0,
          -100,
        ), // رفع الزر قليلاً للأعلى ليناسب الشريط السفلي
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.Selection.withOpacity(0.4),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: FloatingActionButton(
            elevation: 0,
            onPressed: () async {
              await Get.toNamed(AppRoutes.addProject);
              controller.fetchMyProjects();
            },
            child: Icon(Icons.add_rounded, size: 28, color: Colors.white),
            backgroundColor: AppColors.Selection,
          ),
        ),
      ),*/
    );
  }
}

class _CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  final FloatingActionButtonLocation location;
  final double offsetX;
  final double offsetY;

  _CustomFloatingActionButtonLocation(
    this.location,
    this.offsetX,
    this.offsetY,
  );

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}
