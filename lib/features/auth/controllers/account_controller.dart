// lib/controllers/account_controller.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hobe/app_routes.dart';
import 'package:hobe/features/auth/services/account_service.dart';


class AccountController extends GetxController {
  final AccountService _service = AccountService();
  final _storage = GetStorage();

  var isLoading = false.obs;
  var otpSent = false.obs;

  String get userEmail => _storage.read('email') ?? '';

  Future<void> requestDelete() async {
    isLoading.value = true;
    final result = await _service.deleteAccountRequest();
    isLoading.value = false;

    if (result['success']) {
      otpSent.value = true;
      Get.snackbar('تم', result['message']);
    } else {
      Get.snackbar('خطأ', result['message']);
    }
  }

  Future<void> confirmDelete(String otp) async {
    isLoading.value = true;
    final result = await _service.deleteAccountConfirm(
      email: userEmail,
      otp: otp,
    );
    isLoading.value = false;

    if (result['success']) {
      await _storage.erase(); // مسح التوكن وكل شي مخزّن
      Get.offAllNamed(AppRoutes.login);
      Get.snackbar('تم', result['message']);
    } else {
      Get.snackbar('خطأ', result['message']);
    }
  }
}