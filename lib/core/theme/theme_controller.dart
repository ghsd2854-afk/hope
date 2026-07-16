import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../theme/app_themes.dart';

class ThemeController extends GetxController {
  final box = GetStorage();

  var isDark = false.obs;

  @override
  void onInit() {
    super.onInit();

    isDark.value = box.read('isDark') ?? false;

    Get.changeTheme(isDark.value ? AppThemes.dark : AppThemes.light);
  }

  void toggleTheme() {
    isDark.value = !isDark.value;

    box.write('isDark', isDark.value);

    Get.changeTheme(isDark.value ? AppThemes.dark : AppThemes.light);
  }
}
