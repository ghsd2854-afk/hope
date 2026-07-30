import 'package:dio/dio.dart';
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';
import 'package:hobe/features/home/models/conversation_model.dart';
import 'package:hobe/features/home/models/message_model.dart';


class ConversationService {
  final _dio = DioService().dio;

  /// جلب كل محادثات المستخدم الحالي
  Future<List<ConversationModel>> getConversations() async {
    final response = await _dio.get(ApiConstants.conversations);
    // ⚠️ ضيف: static const String conversations = "/conversations";

    if (response.statusCode == 200) {
      final List data = response.data['data']['data'];
      return data.map((e) => ConversationModel.fromJson(e)).toList();
    }
    throw Exception('فشل تحميل المحادثات');
  }

  /// جلب محادثة واحدة + كل رسائلها
  Future<List<MessageModel>> getMessages(int conversationId) async {
    final response = await _dio.get(
      '${ApiConstants.conversations}/$conversationId',
    );

    if (response.statusCode == 200) {
      final List data = response.data['data']['messages']['data'];
      return data.map((e) => MessageModel.fromJson(e)).toList();
    }
    throw Exception('فشل تحميل الرسائل');
  }

  /// إرسال رسالة (نص فقط أو مع مرفق)
  Future<MessageModel> sendMessage({
    required int conversationId,
    required String body,
    String? attachmentPath,
  }) async {
    final formData = FormData.fromMap({
      'body': body,
      if (attachmentPath != null)
        'attachment': await MultipartFile.fromFile(attachmentPath),
    });

    final response = await _dio.post(
      '${ApiConstants.conversations}/$conversationId/messages',
      data: formData,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return MessageModel.fromJson(response.data['data']);
    }
    throw Exception('فشل إرسال الرسالة');
  }

  /// تعليم رسائل المحادثة كمقروءة
  Future<void> markAsRead(int conversationId) async {
    await _dio.post('${ApiConstants.conversations}/$conversationId/read');
  }

  /// عدد المحادثات غير المقروءة (يُستخدم لبادج بالدراور مثلاً)
  Future<int> getUnreadCount() async {
    final response = await _dio.get('${ApiConstants.conversations}/unread-count');
    if (response.statusCode == 200) {
      return response.data['data']['unread_conversations'] ?? 0;
    }
    return 0;
  }
}