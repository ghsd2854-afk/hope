class EnhanceCvModel {
  final bool success;
  final String message;
  final int fileRecordId;
  final bool saved;
  final bool targeted;
  final List<String> changes;
  final List<String> suggestedSkills;

  EnhanceCvModel({
    required this.success,
    required this.message,
    required this.fileRecordId,
    required this.saved,
    required this.targeted,
    required this.changes,
    required this.suggestedSkills,
  });

  factory EnhanceCvModel.fromJson(Map<String, dynamic> json) {
    return EnhanceCvModel(
      success: json['success'],
      message: json['message'],
      fileRecordId: json['file_record_id'],
      saved: json['saved'],
      targeted: json['targeted'],
      changes: List<String>.from(json['changes'] ?? []),
      suggestedSkills:
          List<String>.from(json['suggested_skills_to_learn'] ?? []),
    );
  }
}