/// عنصر بقائمة المحادثات (نتيجة GET /conversations)
class ConversationModel {
  final int id;
  final int jobApplicationId;
  final int applicantId;
  final int companyUserId;
  final String status;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int applicantUnreadCount;
  final int companyUnreadCount;
  final String? companyUserName;
  final String? applicantName;
  final String? jobTitle;

  ConversationModel({
    required this.id,
    required this.jobApplicationId,
    required this.applicantId,
    required this.companyUserId,
    required this.status,
    this.lastMessage,
    this.lastMessageAt,
    required this.applicantUnreadCount,
    required this.companyUnreadCount,
    this.companyUserName,
    this.applicantName,
    this.jobTitle,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    final jobApplication = json['job_application'];
    final jobPost = jobApplication != null ? jobApplication['job_post'] : null;
    final companyUser = json['company_user'];
    final applicant = json['applicant'];

    return ConversationModel(
      id: json['id'],
      jobApplicationId: json['job_application_id'],
      applicantId: json['applicant_id'],
      companyUserId: json['company_user_id'],
      status: json['status'] ?? '',
      lastMessage: json['last_message'],
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'])
          : null,
      applicantUnreadCount: json['applicant_unread_count'] ?? 0,
      companyUnreadCount: json['company_unread_count'] ?? 0,
      companyUserName: companyUser != null ? companyUser['name'] : null,
      applicantName: applicant != null ? applicant['name'] : null,
      jobTitle: jobPost != null ? jobPost['title'] : null,
    );
  }
}