// lib/features/profiles/mpdel/cvfile_detail_model.dart

import 'package:hobe/features/profiles/mpdel/extractforfile_model.dart';


class CvFileDetailModel {
  final int id;
  final String originalName;
  final int size;
  final String mimeType;
  final bool isConfirmed;
  final String createdAt;
  final bool hasFile;
  final String fileUrl;
  final CvExtractModel? extractedCv;
  final Map<String, dynamic>? improvedCv;

  CvFileDetailModel({
    required this.id,
    required this.originalName,
    required this.size,
    required this.mimeType,
    required this.isConfirmed,
    required this.createdAt,
    required this.hasFile,
    required this.fileUrl,
    this.extractedCv,
    this.improvedCv,
  });

  factory CvFileDetailModel.fromJson(Map<String, dynamic> json) {
    return CvFileDetailModel(
      id: json['id'],
      originalName: json['original_name'] ?? "",
      size: json['size'] ?? 0,
      mimeType: json['mime_type'] ?? "",
      isConfirmed: json['is_confirmed'] ?? false,
      createdAt: json['created_at'] ?? "",
      hasFile: json['has_file'] ?? false,
      fileUrl: json['file_url'] ?? "",
      extractedCv: json['extracted_cv'] != null
          ? CvExtractModel.fromJson(json['extracted_cv'])
          : null,
      improvedCv: json['improved_cv'] != null
          ? Map<String, dynamic>.from(json['improved_cv'])
          : null,
    );
  }

  bool get isPdf => mimeType == "application/pdf";
  bool get hasImprovedVersion => improvedCv != null;
}