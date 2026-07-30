class EnhanceModel {
  final int? fileRecordId;
  final Map<String, dynamic>? enhancedCv;
  final bool saved; // ⬅️ الحقل الجديد

  EnhanceModel({
    this.fileRecordId,
    this.enhancedCv,
    this.saved = false, // ⬅️ الجديد
  });

  factory EnhanceModel.fromJson(Map<String, dynamic> json) {
    return EnhanceModel(
      fileRecordId: json["file_record_id"],
      enhancedCv: json["enhanced_cv"],
      saved: json["saved"] ?? false, // ⬅️ الجديد
    );
  }
}