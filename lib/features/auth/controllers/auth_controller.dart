import 'package:get/get.dart';
import 'package:hobe/features/auth/views/login_screen.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  void logout() {
    Get.snackbar("Logout", "You have been logged out");

    /// رجوع للوغ إن
    Get.offAll(() => LoginScreen());
  }
}
