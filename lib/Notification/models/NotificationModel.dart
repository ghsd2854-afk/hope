class NotificationModel {
  final int id;
  final String title;
  final String body;
  final bool isRead;
  final String createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      isRead: json['read_at'] != null,
      createdAt: json['created_at'] ?? '',
    );
  }
}
