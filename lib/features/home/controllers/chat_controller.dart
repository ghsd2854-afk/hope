import 'dart:async';

import 'package:get/get.dart';
import 'package:hobe/features/home/models/message_model.dart';
import 'package:hobe/features/home/services/conversation_service.dart';


class ChatController extends GetxController {
  final ConversationService _service = ConversationService();

  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;

  int? _conversationId;
  Timer? _pollTimer;

  /// نادي هذه الدالة لما تفتحي شاشة شات محادثة معينة
  Future<void> openConversation(int conversationId) async {
    _conversationId = conversationId;
    await _fetchMessages(showLoading: true);
    await _service.markAsRead(conversationId);

    // Polling: نسأل السيرفر كل 3 ثواني عن رسائل جديدة بدون ما المستخدم
    // يعمل refresh يدوي - هاد أبسط حل مجاني وما بيحتاج تعديل بالباك اند.
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _fetchMessages(showLoading: false);
    });
  }

Future<void> _fetchMessages({required bool showLoading}) async {
  if (_conversationId == null) return;
  try {
    if (showLoading) isLoading.value = true;
    final list = await _service.getMessages(_conversationId!);

    // ⚠️ الـ API بيرجّع الرسائل بترتيب معيّن (غالباً الأحدث أولاً)،
    // فبنرتبهن هون يدوياً تصاعدياً حتى تطلع أول رسالة فوق والأحدث تحت.
    list.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    if (list.length != messages.length) {
      messages.assignAll(list);
      await _service.markAsRead(_conversationId!);
    }
  } catch (_) {
    // بالـ polling ما منعرض خطأ بكل مرة حتى ما نزعج المستخدم
  } finally {
    if (showLoading) isLoading.value = false;
  }
}

  Future<void> sendMessage(String text, {String? attachmentPath}) async {
    if (_conversationId == null) return;
    if (text.trim().isEmpty && attachmentPath == null) return;

    try {
      isSending.value = true;
      final newMessage = await _service.sendMessage(
        conversationId: _conversationId!,
        body: text.trim(),
        attachmentPath: attachmentPath,
      );
      messages.add(newMessage);
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      isSending.value = false;
    }
  }

  @override
  void onClose() {
    _pollTimer?.cancel();
    super.onClose();
  }
}