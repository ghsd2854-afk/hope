import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/home/screens/AddProjectScreen.dart';
import 'package:hobe/features/home/screens/MyActivities.dart';
import 'package:hobe/features/Icons_home/controller/JobController.dart';
import 'package:hobe/features/home/widget/JobCard.dart';
import 'package:hobe/features/home/widget/home_chip.dart';
import '../controllers/home_controller.dart';
import '../widget/home_drawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController homeController = Get.find<HomeController>();
  //final homeController = Get.find<HomeController>();
  // final jobController = Get.find<JobController>();
  //final reactionController = Get.find<ReactionController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    return Obx(
      () => Scaffold(
        backgroundColor: Color.fromARGB(255, 218, 203, 248),

        extendBody: true,

        drawer: HomeDrawer(),

        appBar: AppBar(
          title: const Text("Hobe"),

          actions: [
            IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          ],
        ),

        body: IndexedStack(
          index: homeController.currentIndex.value,
          children: [
            const MyActivities(),
            MainHomeContent(),
            AddProjectScreen(),
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          index: homeController.currentIndex.value,

          height: 60.0,

          items: const <Widget>[
            Icon(Icons.list_alt, size: 30, color: Colors.white),

            Icon(Icons.home, size: 35, color: Colors.white),

            Icon(Icons.shopping_bag, size: 30, color: Colors.white),
          ],

          color: Color.fromARGB(255, 148, 114, 217),

          buttonBackgroundColor: Color.fromARGB(255, 148, 114, 217),

          backgroundColor: Colors.transparent,

          animationCurve: Curves.easeInOutCubic,

          animationDuration: const Duration(milliseconds: 600),

          onTap: (index) {
            homeController.currentIndex.value = index;
          },
        ),
      ),
    );
  }
}

class MainHomeContent extends StatelessWidget {
  MainHomeContent({super.key});
  final homeController = Get.find<HomeController>();
  final jobController = Get.find<JobController>();
  // final reactionController = Get.find<ReactionController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final jobController = Get.find<JobController>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),

          child: TextField(
            onChanged: (value) {
              // دالة للبحث اللحظي عند الكتابة (يمكن إضافة Debounce لاحقاً لتحسين الأداء)

              jobController.searchJobs(value);
            },

            cursorColor: const Color(0xFF4A148C),

            decoration: InputDecoration(
              hintText: "Search for jobs...",

              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),

              //prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30), // حواف دائرية أكثر

                borderSide: const BorderSide(
                  color: Color(0xFF4A148C),

                  width: 1.5,
                ), // لون نهدي غامق
              ),

              // الحواف عند الضغط (Focus)
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),

                borderSide: const BorderSide(
                  color: Color(0xFF4A148C),

                  width: 2.5,
                ), // سماكة أكبر عند التحديد
              ),

              filled: true,

              fillColor: theme.cardColor,

              prefixIcon: const Icon(Icons.search, color: Color(0xFF4A148C)),

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
        SizedBox(
          height: 50, // ضروري جداً
          child: Obx(() {
            if (homeController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: homeController.categories.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const HomeChip(text: "All", index: 0);
                }
                final category = homeController.categories[index - 1];
                return HomeChip(text: category.name, index: category.id);
              },
            );
          }),
        ),
        Expanded(
          child: Obx(() {
            if (jobController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (jobController.filteredJobs.isEmpty) {
              return const Center(child: Text("لا توجد وظائف متاحة"));
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: jobController.filteredJobs.length,
              itemBuilder: (_, i) => JobCard(
                job: jobController.filteredJobs[i],
                controller: jobController,
              ),
            );
          }),
        ),

        /*  Expanded(
          child: Obx(() {
            if (jobController.jobPosts.isEmpty)
              return const Center(child: CircularProgressIndicator());

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 4),

              itemCount: jobController.jobPosts.length,

              itemBuilder: (_, i) => JobCard(
                job: jobController.jobPosts[i],

                controller: jobController,
              ),
            );
          }),
        ),*/
      ],
    );
  }
}
