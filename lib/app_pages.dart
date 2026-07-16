import 'package:get/get.dart';
import 'package:hobe/features/Icons_home/controller/JobController.dart';
import 'package:hobe/features/Icons_home/controller/ReactionController.dart';
import 'package:hobe/features/Icons_home/controller/comment_controller.dart';
import 'package:hobe/features/Icons_home/screen/saved_screen.dart';
import 'package:hobe/features/auth/controllers/reset_password_controller.dart';
import 'package:hobe/features/auth/views/forgot_password_screen.dart';
import 'package:hobe/features/auth/views/login_screen.dart';
import 'package:hobe/features/auth/views/otp_screen.dart';
import 'package:hobe/features/auth/views/profile_screen.dart';
import 'package:hobe/features/auth/views/reset_new_password_screen.dart';
import 'package:hobe/features/auth/views/signup_screen.dart';
import 'package:hobe/features/home/controllers/home_controller.dart';
import 'package:hobe/features/home/screens/home_screen.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.login, page: () => LoginScreen()),

    GetPage(name: AppRoutes.signUp, page: () => SignUpScreen()),

    GetPage(name: AppRoutes.otp, page: () => OtpView()),

    GetPage(
      name: AppRoutes.home,

      page: () => HomeScreen(),

      binding: BindingsBuilder(() {
        Get.put(HomeController());

        Get.put(JobController());

        Get.put(ReactionController());

        Get.put(CommentController()); // <--- أضف هذا السطر هنا
      }),
    ),

    GetPage(name: AppRoutes.forgotPassword, page: () => ForgotPasswordScreen()),

    GetPage(
      name: AppRoutes.resetPassword,

      page: () => ResetNewPasswordScreen(),

      binding: BindingsBuilder(() {
        Get.lazyPut<ResetPasswordController>(() => ResetPasswordController());
      }),
    ),

    GetPage(name: AppRoutes.profile, page: () => ProfileEditScreen()),
    GetPage(
      name: AppRoutes.savedJobs,
      page: () => SavedJobsScreen(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<JobController>()) {
          Get.put(JobController());
        }
      }),
    ),
  ];
}
