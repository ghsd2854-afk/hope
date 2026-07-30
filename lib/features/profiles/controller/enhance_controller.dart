import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hobe/features/profiles/mpdel/enhance_model.dart';


import '../services/enhance_service.dart';

class EnhanceController extends GetxController {
  final EnhanceService _service = EnhanceService();

  var isLoading = false.obs;

  var enhancedCv = Rxn<EnhanceModel>();

  Future<void> enhance() async {
    try {
      isLoading.value = true;

      enhancedCv.value =
          await _service.enhanceCv();

      Get.snackbar(
        "Success",
        "Resume Enhanced",
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

Future<void> saveCv() async {
  try {
    isLoading.value = true;
print(enhancedCv.value?.fileRecordId);
print(enhancedCv.value?.enhancedCv);
    await _service.saveEnhancedCv(
  fileRecordId: enhancedCv.value!.fileRecordId!,
  enhancedCv: enhancedCv.value!.enhancedCv!,
);

    Get.snackbar(
      "Success",
      "Enhanced CV Saved Successfully",
    );
  }catch (e) {
  if (e is DioException) {
    print(e.response?.data);
    Get.snackbar(
      "Error",
      e.response?.data.toString() ?? e.toString(),
    );
  } else {
    Get.snackbar("Error", e.toString());
  }
} finally {
    isLoading.value = false;
  }
}
}
