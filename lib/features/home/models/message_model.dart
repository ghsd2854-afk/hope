class MessageModel {
  final int id;
  final int conversationId;
  final int senderId;
  final String senderType; // "applicant" أو "company"
  final String body;
  final String type; // "text" غالباً
  final String? attachmentPath;
  final String? attachmentName;
  final String? attachmentType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? senderName;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderType,
    required this.body,
    required this.type,
    this.attachmentPath,
    this.attachmentName,
    this.attachmentType,
    required this.createdAt,
    required this.updatedAt,
    this.senderName,
  });

  /// true لو أنا المرسل (المستخدم الحالي هو applicant دايماً بهاي الشاشة)
  bool get isMine => senderType == 'applicant';

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      conversationId: json['conversation_id'],
      senderId: json['sender_id'],
      senderType: json['sender_type'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? 'text',
      attachmentPath: json['attachment_path'],
      attachmentName: json['attachment_name'],
      attachmentType: json['attachment_type'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      senderName: json['sender'] != null ? json['sender']['name'] : null,
    );
  }
}