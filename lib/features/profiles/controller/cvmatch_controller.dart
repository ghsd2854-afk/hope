import 'package:get/get.dart';
import 'package:hobe/features/profiles/mpdel/match_model.dart';

import '../services/match_service.dart';

class MatchController extends GetxController {
  final MatchService _service = MatchService();

  var isLoading = false.obs;

  var matchResult = Rxn<MatchModel>();

  Future<void> match({
    required String jobDescription,
  }) async {
    try {
      isLoading.value = true;

      matchResult.value = await _service.matchCv(
        jobDescription: jobDescription,
      );

      Get.snackbar(
        "Success",
        "CV matched successfully",
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
}