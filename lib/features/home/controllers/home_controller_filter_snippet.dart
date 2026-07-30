/// أضف هذا المنطق داخل HomeController الموجود عندك، حتى تختفي
/// بوستات أي شركة/مستخدم محظور من الفيد مباشرة بدون ما تحتاج تعيد
/// طلب البوستات من السيرفر.

/*
import 'package:get/get.dart';
import 'package:hobe/features/block/controllers/block_controller.dart';

class HomeController extends GetxController {
  final RxList<PostModel> allPosts = <PostModel>[].obs; // كل البوستات من الـ API
  final RxList<PostModel> visiblePosts = <PostModel>[].obs; // اللي تُعرض فعلياً

  @override
  void onInit() {
    super.onInit();
    // راقب أي تغيير بقائمة المحظورين وأعد فلترة الفيد تلقائياً
    final blockController = Get.isRegistered<BlockController>()
        ? Get.find<BlockController>()
        : Get.put(BlockController());

    ever(blockController.blockedList, (_) => _applyBlockFilter());
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    // ... نفس منطقك الحالي بجلب البوستات وتعبئة allPosts
    _applyBlockFilter();
  }

  void _applyBlockFilter() {
    final blockController = Get.find<BlockController>();
    final blockedIds = blockController.blockedList
        .where((b) => b.isCompany) // أو احذف الشرط لو بدك تخفي المستخدمين كمان
        .map((b) => b.blockableId)
        .toSet();

    visiblePosts.assignAll(
      allPosts.where((p) => !blockedIds.contains(p.companyId)).toList(),
      // ⚠️ عدّل p.companyId ليطابق اسم الحقل الفعلي بـ PostModel
    );
  }
}
*/
