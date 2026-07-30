// lib/features/profiles/mpdel/cvfile_model.dart

class CvFileModel {
  final int id;
  final String originalName;
  final int size;
  final String mimeType;
  final bool isConfirmed;
  final String createdAt;
  final bool hasFile;
  final String fileUrl;

  CvFileModel({
    required this.id,
    required this.originalName,
    required this.size,
    required this.mimeType,
    required this.isConfirmed,
    required this.createdAt,
    required this.hasFile,
    required this.fileUrl,
  });

  factory CvFileModel.fromJson(Map<String, dynamic> json) {
    return CvFileModel(
      id: json['id'],
      originalName: json['original_name'] ?? "",
      size: json['size'] ?? 0,
      mimeType: json['mime_type'] ?? "",
      isConfirmed: json['is_confirmed'] ?? false,
      createdAt: json['created_at'] ?? "",
      hasFile: json['has_file'] ?? false,
      fileUrl: json['file_url'] ?? "",
    );
  }

  bool get isPdf => mimeType == "application/pdf";

  String get sizeReadable {
    if (size == 0) return "";
    if (size < 1024) return "$size B";
    if (size < 1024 * 1024) return "${(size / 1024).toStringAsFixed(1)} KB";
    return "${(size / (1024 * 1024)).toStringAsFixed(2)} MB";
  }
}