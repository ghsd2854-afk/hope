class ComplaintModel {
  final int targetId;
  final String complaintText;
  final String targetType;

  ComplaintModel({
    required this.targetId,
    required this.complaintText,
    required this.targetType,
  });

  Map<String, dynamic> toJson() {
    return {
      'target_id': targetId,
      'message':
          complaintText, // تم تغييرها من complaint إلى message لتتوافق مع السيرفر
      'target_type': targetType,
    };
  }
}
