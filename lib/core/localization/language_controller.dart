import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final box = GetStorage();

  var locale = const Locale('en', 'US').obs;

  @override
  void onInit() {
    String? lang = box.read("lang");

    if (lang == "ar") {
      locale.value = const Locale('ar', 'SA');
    } else {
      locale.value = const Locale('en', 'US');
    }

    super.onInit();
  }

  void changeLanguage(String code) {
    if (code == "ar") {
      locale.value = const Locale('ar', 'SA');
    } else {
      locale.value = const Locale('en', 'US');
    }

    box.write("lang", code);
    Get.updateLocale(locale.value);
  }
}