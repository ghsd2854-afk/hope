class ExportStatusModel {
  final int id;
  final int userId;
  final String status; // "processing" أو "ready" مثلاً
  final String? filePath;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  ExportStatusModel({
    required this.id,
    required this.userId,
    required this.status,
    this.filePath,
    this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isReady => status == 'ready';

  factory ExportStatusModel.fromJson(Map<String, dynamic> json) {
    return ExportStatusModel(
      id: json['id'],
      userId: json['user_id'],
      status: json['status'] ?? '',
      filePath: json['file_path'],
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
