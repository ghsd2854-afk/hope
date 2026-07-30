import 'package:get/get.dart';
import 'package:hobe/features/home/models/conversation_model.dart';
import 'package:hobe/features/home/services/conversation_service.dart';


class ConversationsController extends GetxController {
  final ConversationService _service = ConversationService();

  final RxBool isLoading = false.obs;
  final RxList<ConversationModel> conversations = <ConversationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchConversations();
  }

  Future<void> fetchConversations() async {
    try {
      isLoading.value = true;
      final list = await _service.getConversations();
      conversations.assignAll(list);
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}