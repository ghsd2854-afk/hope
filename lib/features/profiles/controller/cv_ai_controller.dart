import 'package:get/get.dart';
import 'package:hobe/features/profiles/services/cv_ai_services.dart';

class CvController extends GetxController {
  final CvService _service = CvService();

  var isLoading = false.obs;

  final Rxn<Map<String, dynamic>> cvData = Rxn<Map<String, dynamic>>();

  Future<void> generateCv() async {
    try {
      isLoading.value = true;

      final result = await _service.generateCv();

      // result هو محتوى الـ cv نفسه مباشرة (مش لازم ['cv'])
      cvData.value = Map<String, dynamic>.from(result);

      Get.snackbar(
        "تم",
        "تم توليد السيرة الذاتية بنجاح",
      );
    } catch (e) {
      Get.snackbar(
        "خطأ",
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}