import 'package:get/get.dart';
import 'package:hobe/core/setting/setting_screen.dart';
import 'package:hobe/features/Icons_home/controller/JobController.dart';
import 'package:hobe/features/Icons_home/controller/ReactionController.dart';
import 'package:hobe/features/Icons_home/controller/comment_controller.dart';
import 'package:hobe/features/Icons_home/screen/saved_screen.dart';
import 'package:hobe/features/auth/controllers/reset_password_controller.dart';
import 'package:hobe/features/auth/views/forgot_password_screen.dart';
import 'package:hobe/features/auth/views/login_screen.dart';
import 'package:hobe/features/auth/views/my_account_screen.dart';
import 'package:hobe/features/auth/views/otp_screen.dart';
import 'package:hobe/features/home/controllers/AddProjectController.dart';
import 'package:hobe/features/home/controllers/MyApplicationsController.dart';
import 'package:hobe/features/home/controllers/MyProjectsController.dart'; // <--- Controller الخاص بمشاريعك
import 'package:hobe/features/home/controllers/ProfileUserController.dart';
import 'package:hobe/features/home/screens/MyActivities.dart';
import 'package:hobe/features/home/screens/MyApplicationsScreen.dart';
import 'package:hobe/features/home/screens/MyProjectsScreen.dart'; // <--- شاشتك الخاصة بمشاريعي
import 'package:hobe/features/home/controllers/block_controller.dart';
import 'package:hobe/features/home/controllers/conversations_controller.dart';
import 'package:hobe/features/home/controllers/data_export_controller.dart';
import 'package:hobe/features/home/controllers/home_controller.dart';
import 'package:hobe/features/home/screens/AddProjectScreen.dart';
import 'package:hobe/features/home/screens/ProfileUserScreen.dart';
import 'package:hobe/features/home/screens/ProjectDetailsScreen.dart';
import 'package:hobe/features/home/screens/blocked_list_screen.dart';
import 'package:hobe/features/home/screens/conversations_list_screen.dart';
import 'package:hobe/features/home/screens/data_export_screen.dart';
import 'package:hobe/features/onboarding/onboarding_screen.dart';
import 'package:hobe/features/profiles/view/CV_ANALYSE.dart';
import 'package:hobe/features/profiles/view/CertificationScreen.dart';
import 'package:hobe/features/profiles/view/EnhanceScreen.dart';
import 'package:hobe/features/profiles/view/InterestScreen.dart';
import 'package:hobe/features/profiles/view/PdfScreen.dart';
import 'package:hobe/features/profiles/view/SkillsScreen.dart';
import 'package:hobe/features/profiles/view/TrainingScreen.dart';
import 'package:hobe/features/profiles/view/cv_ai_screen.dart';
import 'package:hobe/features/profiles/view/cv_hub_screen.dart';
import 'package:hobe/features/profiles/view/cvanalyzefile_screen.dart';
import 'package:hobe/features/profiles/view/cvenhancefile_screen.dart';
import 'package:hobe/features/profiles/view/cvfile_detail_screen.dart';
import 'package:hobe/features/profiles/view/cvfiles_screen.dart';
import 'package:hobe/features/profiles/view/education_screen.dart';
import 'package:hobe/features/profiles/view/experiences_screen.dart';
import 'package:hobe/features/profiles/view/extractforfile_screen.dart';
import 'package:hobe/features/profiles/view/match_screen.dart';
import 'package:hobe/features/profiles/view/profile_completion_screen.dart';
import 'package:hobe/features/profiles/view/profile_screen.dart';
import 'package:hobe/features/auth/views/reset_new_password_screen.dart';
import 'package:hobe/features/auth/views/signup_screen.dart';
import 'package:hobe/features/home/screens/home_screen.dart';
import 'package:hobe/features/profiles/view/public_profile_settings_screen.dart';
import 'package:hobe/features/profiles/view/public_profile_view_screen.dart';
import 'package:hobe/features/profiles/view/skill_suggestions-view.dart';
import 'package:hobe/features/splash/splash_screen.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.login, page: () => LoginScreen()),
    GetPage(name: AppRoutes.signUp, page: () => SignUpScreen()),
    GetPage(name: AppRoutes.otp, page: () => OtpView()),
    GetPage(name: AppRoutes.forgotPassword, page: () => ForgotPasswordScreen()),
    GetPage(
      name: AppRoutes.DATA_EXPORT,
      page: () => const DataExportScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<DataExportController>(() => DataExportController());
      }),
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => ResetNewPasswordScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ResetPasswordController>(() => ResetPasswordController());
      }),
    ),
    GetPage(name: AppRoutes.Settings, page: () => SettingsScreen()),
    GetPage(name: AppRoutes.profile, page: () => ProfileEditScreen()),
    GetPage(name: AppRoutes.skills, page: () => SkillsScreen()),
    GetPage(name: AppRoutes.training, page: () => TrainingScreen()),
    GetPage(name: AppRoutes.education, page: () => EducationScreen()),
    GetPage(name: AppRoutes.experiences, page: () => ExperienceScreen()),

    // --- ربط صفحة مشاريعي بـ MyProjectsScreen الخاصة بك ---
    GetPage(
      name: AppRoutes.projects,
      page: () => MyProjectsScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<MyProjectsController>(() => MyProjectsController());
      }),
    ),

    GetPage(name: AppRoutes.certification, page: () => CertificationScreen()),
    GetPage(name: AppRoutes.interests, page: () => InterestScreen()),
    GetPage(name: "/skillSuggestions", page: () => SkillSuggestionScreen()),
    GetPage(name: "/cvGenerate", page: () => CvScreen()),
    GetPage(name: "/analyze", page: () => AnalyzeScreen()),
    GetPage(name: "/enhance", page: () => EnhanceScreen()),
    GetPage(name: AppRoutes.MATCH, page: () => MatchScreen()),
    GetPage(name: "/pdf", page: () => PdfScreen()),

    GetPage(name: "/cv-upload", page: () => CvUploadScreen()),
    GetPage(name: "/cv-files", page: () => CvFilesScreen()),
    GetPage(name: "/cv-hub", page: () => CvHubScreen()),
    GetPage(name: "/cv-file-details", page: () => CvFileDetailScreen()),
    GetPage(name: "/cv-analyze-file", page: () => CvAnalyzeFileScreen()),
    GetPage(name: "/cv-enhance-file", page: () => CvEnhanceFileScreen()),
    GetPage(name: "/profile-completion", page: () => ProfileCompletionScreen()),
    GetPage(
      name: "/public-profile-settings",
      page: () => PublicProfileSettingsScreen(),
    ),
    GetPage(
      name: "/public-profile-preview",
      page: () => PublicProfileViewScreen(),
    ),
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.myAccount, page: () => MyAccountScreen()),
    GetPage(name: AppRoutes.onboarding, page: () => OnboardingView()),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
      binding: BindingsBuilder(() {
        Get.put(HomeController());
        Get.put(JobController());
        Get.put(ReactionController());
        Get.put(CommentController());
      }),
    ),
    GetPage(
      name: AppRoutes.savedJobs,
      page: () => SavedJobsScreen(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<JobController>()) {
          Get.put(JobController());
        }
      }),
    ),
    GetPage(
      name: AppRoutes.BLOCKED_LIST,
      page: () => const BlockedListScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<BlockController>(() => BlockController());
      }),
    ),
    GetPage(
      name: AppRoutes.CONVERSATIONS_LIST,
      page: () => const ConversationsListScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ConversationsController>(() => ConversationsController());
      }),
    ),
    GetPage(
      name: AppRoutes.addProject,
      page: () => AddProjectScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AddProjectController>(() => AddProjectController());
      }),
    ),
    GetPage(name: AppRoutes.projectDetails, page: () => ProjectDetailsScreen()),
    GetPage(
      name: AppRoutes.myPublishedProjects,
      page: () => MyProjectsScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<MyProjectsController>(() => MyProjectsController());
      }),
    ),
    GetPage(name: AppRoutes.myActivities, page: () => const MyActivities()),
    GetPage(
      name: AppRoutes.myApplications,
      page: () => const MyApplicationsScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<MyApplicationsController>(() => MyApplicationsController());
      }),
    ),
    GetPage(
      name: AppRoutes.userProfile,
      page: () => const ProfileUserScreen(),
      binding: BindingsBuilder(() {
        // إضافة fenix: true لضمان إعادة إنشاء الكنترولر وتحديث البيانات عند تغير المستخدم
        Get.lazyPut<ProfileUserController>(
          () => ProfileUserController(),
          fenix: true,
        );
      }),
    ),
  ];
}
