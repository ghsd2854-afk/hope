import 'package:get/get.dart';
import 'package:hobe/features/home/models/block_model.dart';
import 'package:hobe/features/home/services/block_service.dart';

class BlockController extends GetxController {
  final BlockService _service = BlockService();

  final RxBool isLoading = false.obs;
  final RxList<BlockModel> blockedList = <BlockModel>[].obs;

  // كاش بسيط: "user_5" أو "company_3" -> true/false، حتى ما نستعلم
  // مرتين عن نفس الكيان أثناء التمرير على البوستات
  final RxMap<String, bool> blockedStatusCache = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBlockedList();
  }

  String _cacheKey(String type, int id) => '${type}_$id';

  Future<void> fetchBlockedList() async {
    try {
      isLoading.value = true;
      final list = await _service.getBlockedList();
      blockedList.assignAll(list);
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> checkIsBlocked({required String type, required int id}) async {
    final key = _cacheKey(type, id);
    if (blockedStatusCache.containsKey(key)) {
      return blockedStatusCache[key]!;
    }
    final result = await _service.isBlocked(
      blockableType: type,
      blockableId: id,
    );
    blockedStatusCache[key] = result;
    return result;
  }

  Future<void> blockEntity({
    required String type, // "user" أو "company"
    required int id,
    String? name,
  }) async {
    try {
      await _service.blockEntity(blockableType: type, blockableId: id);
      blockedStatusCache[_cacheKey(type, id)] = true;
      Get.snackbar(
        'تم الحظر',
        name != null ? 'تم حظر $name بنجاح' : 'تم الحظر بنجاح',
      );
      fetchBlockedList();
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    }
  }

  Future<void> unblock(BlockModel block) async {
    try {
      await _service.unblock(block.id);
      blockedList.removeWhere((b) => b.id == block.id);
      blockedStatusCache[_cacheKey(block.blockableType, block.blockableId)] =
          false;
      Get.snackbar('تم', 'تم إلغاء الحظر بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    }
  }
}
