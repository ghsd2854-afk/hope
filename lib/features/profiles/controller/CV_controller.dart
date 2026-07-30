import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hobe/features/profiles/mpdel/cv_analysis_model.dart';
import 'package:hobe/features/profiles/services/cv_service.dart';


class AnalyzeController extends GetxController {

  final AnalyzeService _service =
      AnalyzeService();

  var isLoading = false.obs;

var analysis = Rxn<AnalyzeModel>();

  Future<void> analyze() async {

    try {

      isLoading.value = true;

   analysis.value =
    await _service.analyzeCv();

      Get.snackbar(
        "Success",
        "Analysis Completed",
      );

    } on DioException catch (e) {
  print(e.response?.data);
  print(e.response?.statusCode);

  Get.snackbar(
    "Error",
    e.response?.data.toString() ?? e.toString(),
  );
} finally {

      isLoading.value = false;

    }
  }
}