import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/Notification/controller/NotificationController.dart';
import 'package:hobe/app_routes.dart';
import 'package:hobe/core/theme/colors.dart';
import 'package:hobe/features/Icons_home/controller/JobController.dart';
import 'package:hobe/features/home/screens/MyApplicationsScreen.dart';
import 'package:hobe/features/home/screens/MyProjectsScreen.dart';
import 'package:hobe/features/home/widget/JobCard.dart';
import 'package:hobe/features/home/widget/home_chip.dart';
import '../controllers/home_controller.dart';
import '../widget/home_drawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final currentIndex = homeController.currentIndex.value;

      return Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : const Color.fromARGB(255, 218, 203, 248),
        extendBody: true,

        body: IndexedStack(
          index: currentIndex,
          children: [
            const MyApplicationsScreen(),
            MainHomeContent(),
            MyProjectsScreen(),
          ],
        ),

        bottomNavigationBar: CurvedNavigationBar(
          index: currentIndex,
          height: 60.0,
          items: const <Widget>[
            Icon(Icons.assignment_outlined, size: 30, color: Colors.white),
            Icon(Icons.home, size: 35, color: Colors.white),
            Icon(Icons.shopping_bag, size: 30, color: Colors.white),
          ],
          color: AppColors.primaryEnd,
          buttonBackgroundColor: AppColors.primaryEnd,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeInOutCubic,
          animationDuration: const Duration(milliseconds: 600),
          onTap: (index) {
            homeController.currentIndex.value = index;
          },
        ),
      );
    });
  }
}

class MainHomeContent extends StatelessWidget {
  MainHomeContent({super.key});

  final homeController = Get.find<HomeController>();
  final jobController = Get.find<JobController>();
  final ScrollController scrollController = ScrollController();
  final NotificationController notificationController = Get.put(
    NotificationController(),
  );
  final RxInt selectedCategoryId = 0.obs;
  final RxString selectedCategoryName = "All".obs;

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        jobController.loadMoreJobs();
      }
    });

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      drawer: HomeDrawer(),
      body: Stack(
        children: [
          Positioned(
            top: 50,
            right: -50,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryStart.withOpacity(isDark ? 0.15 : 0.4),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryEnd.withOpacity(isDark ? 0.1 : 0.3),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder: (context) => IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: isDark
                                ? AppColors.textDarkPrimary
                                : AppColors.textLightPrimary,
                          ),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                      Text(
                        "Hobe",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textDarkPrimary
                              : AppColors.textLightPrimary,
                        ),
                      ),
                      // داخل Row في الشاشة الرئيسية
                      Obx(
                        () => Stack(
                          children: [
                            IconButton(
                              icon: Icon(Icons.notifications),
                              onPressed: () =>
                                  Get.toNamed(AppRoutes.notifications),
                            ),
                            if (notificationController.unreadCount.value > 0)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Colors.red,
                                  child: Text(
                                    "${notificationController.unreadCount.value}",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: TextField(
                    onChanged: (value) {
                      jobController.searchJobs(value);
                    },
                    cursorColor: AppColors.Selection,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textDarkPrimary
                          : AppColors.textLightPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: "Search for jobs...",
                      hintStyle: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.primaryStart.withOpacity(0.5)
                              : AppColors.Selection,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: AppColors.Selection,
                          width: 2.5,
                        ),
                      ),
                      filled: true,
                      fillColor: isDark
                          ? AppColors.darkCard
                          : AppColors.lightCard,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.Selection,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Obx(
                        () => HomeChip(
                          text: selectedCategoryName.value,
                          index: selectedCategoryId.value,
                          isSelected: true,
                          onTap: () {
                            _showCategoriesBottomSheet(context, isDark);
                          },
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          _showCategoriesBottomSheet(context, isDark);
                        },
                        icon: Icon(
                          Icons.more_horiz_rounded,
                          color: isDark
                              ? AppColors.textDarkPrimary
                              : AppColors.textLightPrimary,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Obx(() {
                    if (jobController.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryEnd,
                          ),
                        ),
                      );
                    }
                    if (jobController.filteredJobs.isEmpty) {
                      return Center(
                        child: Text(
                          "لا توجد وظائف متاحة",
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        top: 8,
                        bottom: 100,
                      ),
                      controller: scrollController,
                      itemCount: jobController.filteredJobs.length,
                      itemBuilder: (_, i) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 6,
                        ),
                        child: JobCard(
                          job: jobController.filteredJobs[i],
                          controller: jobController,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCategoriesBottomSheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "اختر الفئة",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Obx(() {
                  if (homeController.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryEnd,
                        ),
                      ),
                    );
                  }
                  return ListView(
                    children: [
                      ListTile(
                        title: Text(
                          "All",
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textDarkPrimary
                                : AppColors.textLightPrimary,
                          ),
                        ),
                        leading: Icon(
                          Icons.grid_view,
                          color: AppColors.primaryEnd,
                        ),
                        onTap: () {
                          selectedCategoryId.value = 0;
                          selectedCategoryName.value = "All";
                          jobController.currentCategoryId = 0;
                          jobController.fetchJobs();
                          Navigator.pop(context);
                        },
                      ),
                      ...homeController.categories.map((category) {
                        return ListTile(
                          title: Text(
                            category.name,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textDarkPrimary
                                  : AppColors.textLightPrimary,
                            ),
                          ),
                          leading: Icon(
                            Icons.work_outline,
                            color: AppColors.primaryEnd,
                          ),
                          onTap: () {
                            selectedCategoryId.value = category.id;
                            selectedCategoryName.value = category.name;
                            jobController.currentCategoryId = category.id;
                            jobController.fetchJobsByCategory(category.id);
                            Navigator.pop(context);
                          },
                        );
                      }),
                    ],
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
