import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/core/theme/colors.dart';
import 'package:hobe/features/home/controllers/ProfileUserController.dart';
import 'package:hobe/features/home/models/ProfileUserModel.dart';

class ProfileUserScreen extends GetView<ProfileUserController> {
  const ProfileUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      // 1. إذا كان الـ API لسه عم يحمل
      if (controller.isLoading.value) {
        return Scaffold(
          body: const Center(
            child: CircularProgressIndicator(color: AppColors.primaryEnd),
          ),
        );
      }

      // 2. إذا حدث خطأ
      if (controller.errorMessage.isNotEmpty) {
        return Scaffold(
          body: Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        );
      }

      // 3. إذا لم يتم جلب البيانات بعد
      final profileData = controller.profileData.value;
      if (profileData == null) {
        return Scaffold(
          body: Center(
            child: Text(
              "لا توجد بيانات متاحة",
              style: TextStyle(
                color: isDarkMode
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary,
              ),
            ),
          ),
        );
      }

      // 4. البيانات وصلت وجاهزة للعرض
      final user = profileData.user;
      final cardColor = Theme.of(context).cardColor;
      final textColor = isDarkMode
          ? AppColors.textDarkPrimary
          : AppColors.textLightPrimary;

      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // 1. Header Section (Profile Card)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 50,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode
                          ? Colors.black.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: AppColors.primaryEnd.withOpacity(0.15),
                      backgroundImage: user.photo != null
                          ? NetworkImage(user.photo!)
                          : null,
                      child: user.photo == null
                          ? Text(
                              (user.name != null && user.name!.isNotEmpty)
                                  ? user.name![0].toUpperCase()
                                  : "U",
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryEnd,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.name ?? "Anonymous User",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.headline,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.primaryEnd,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${user.city}, ${user.country}",
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.summary,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 2. Stats Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildStatCard(
                      context,
                      "Total Views",
                      "${profileData.stats.totalViews}",
                      Icons.visibility,
                    ),
                    _buildStatCard(
                      context,
                      "This Week",
                      "${profileData.stats.viewsThisWeek}",
                      Icons.trending_up,
                    ),
                    _buildStatCard(
                      context,
                      "This Month",
                      "${profileData.stats.viewsThisMonth}",
                      Icons.calendar_month,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 3. Experiences Section
              if (profileData.experiences.isNotEmpty)
                _buildSection(
                  context: context,
                  title: "Experience",
                  icon: Icons.work,
                  children: profileData.experiences
                      .map((exp) => _buildExperienceItem(context, exp))
                      .toList(),
                ),

              // 4. Educations Section
              if (profileData.educations.isNotEmpty)
                _buildSection(
                  context: context,
                  title: "Education",
                  icon: Icons.school,
                  children: profileData.educations
                      .map((edu) => _buildEducationItem(context, edu))
                      .toList(),
                ),

              // 5. Skills Section
              if (profileData.skills.isNotEmpty)
                _buildSection(
                  context: context,
                  title: "Skills",
                  icon: Icons.psychology,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: profileData.skills
                          .map(
                            (skill) => Chip(
                              label: Text("${skill.name} (${skill.level})"),
                              backgroundColor: AppColors.primaryEnd.withOpacity(
                                0.12,
                              ),
                              labelStyle: const TextStyle(
                                color: AppColors.primaryEnd,
                                fontWeight: FontWeight.w500,
                              ),
                              side: BorderSide.none,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),

              // 6. Projects Section
              if (profileData.projects.isNotEmpty)
                _buildSection(
                  context: context,
                  title: "Projects",
                  icon: Icons.code,
                  children: profileData.projects
                      .map((project) => _buildProjectItem(context, project))
                      .toList(),
                ),

              // 7. Reviews Section
              if (profileData.reviews.isNotEmpty)
                _buildSection(
                  context: context,
                  title: "Reviews",
                  icon: Icons.star,
                  children: profileData.reviews
                      .map((review) => _buildReviewItem(context, review))
                      .toList(),
                ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      );
    });
  }

  // Widget لتصميم قسم رئيسي متوافق مع الثيم
  // Widget لتصميم قسم رئيسي متوافق مع الثيم
  Widget _buildSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final textColor = isDarkMode
        ? AppColors.textDarkPrimary
        : AppColors.textLightPrimary;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.04),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryEnd), // تم إزالة const هنا
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          Divider(
            height: 20,
            color: isDarkMode ? Colors.grey[800] : AppColors.border,
          ),
          ...children,
        ],
      ),
    );
  }

  // Widget لإحصائيات المشاهدات
  // Widget لإحصائيات المشاهدات
  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.04),
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryEnd, size: 20), // تم إزالة const
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryEnd,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // عنصر الخبرة المهنية
  Widget _buildExperienceItem(BuildContext context, Experience exp) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode
        ? AppColors.textDarkPrimary
        : AppColors.textLightPrimary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                exp.position,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: textColor,
                ),
              ),
              if (exp.isCurrent)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryEnd.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    "Current",
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.primaryEnd,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          Text(
            exp.company,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            exp.description,
            style: TextStyle(
              fontSize: 13,
              color: isDarkMode ? Colors.grey[300] : Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 4,
            children: exp.technologiesUsed
                .map(
                  (tech) => Chip(
                    visualDensity: VisualDensity.compact,
                    backgroundColor: isDarkMode
                        ? Colors.grey[850]
                        : Colors.grey[200],
                    label: Text(
                      tech,
                      style: TextStyle(
                        fontSize: 10,
                        color: isDarkMode ? Colors.grey[300] : Colors.black87,
                      ),
                    ),
                    side: BorderSide.none,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  // عنصر التعليم
  Widget _buildEducationItem(BuildContext context, Education edu) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode
        ? AppColors.textDarkPrimary
        : AppColors.textLightPrimary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            edu.institution,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: textColor,
            ),
          ),
          Text(
            "${edu.degree} - ${edu.fieldOfStudy}",
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          Text(
            "From ${edu.startDate.substring(0, 4)} to ${edu.endDate.substring(0, 4)}",
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // عنصر المشروع
  Widget _buildProjectItem(BuildContext context, Project project) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode
        ? AppColors.textDarkPrimary
        : AppColors.textLightPrimary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            project.description,
            style: TextStyle(
              fontSize: 13,
              color: isDarkMode ? Colors.grey[300] : Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 4,
            children: project.technologies
                .map(
                  (tech) => Chip(
                    visualDensity: VisualDensity.compact,
                    backgroundColor: isDarkMode
                        ? Colors.grey[850]
                        : Colors.grey[200],
                    label: Text(
                      tech,
                      style: TextStyle(
                        fontSize: 10,
                        color: isDarkMode ? Colors.grey[300] : Colors.black87,
                      ),
                    ),
                    side: BorderSide.none,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  // عنصر التقييم
  Widget _buildReviewItem(BuildContext context, Review review) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode
        ? AppColors.textDarkPrimary
        : AppColors.textLightPrimary;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review.reviewer.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: textColor,
                ),
              ),
              Row(
                children: List.generate(
                  review.overallRating,
                  (index) =>
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            review.pros,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.grey[300] : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
