// lib/features/profiles/mpdel/cvenhance_model.dart

class CvEnhanceResultModel {
  final int? fileRecordId;
  final bool saved;
  final bool targeted;
  final List<String> changes;
  final List<String> suggestedSkillsToLearn;
  final Map<String, dynamic> originalCv;
  final Map<String, dynamic> enhancedCv;

  CvEnhanceResultModel({
    this.fileRecordId,
    required this.saved,
    required this.targeted,
    required this.changes,
    required this.suggestedSkillsToLearn,
    required this.originalCv,
    required this.enhancedCv,
  });

  factory CvEnhanceResultModel.fromJson(Map<String, dynamic> json) {
    return CvEnhanceResultModel(
      fileRecordId: json['file_record_id'],
      saved: json['saved'] ?? false,
      targeted: json['targeted'] ?? false,
      changes: List<String>.from(json['changes'] ?? []),
      suggestedSkillsToLearn:
          List<String>.from(json['suggested_skills_to_learn'] ?? []),
      originalCv: Map<String, dynamic>.from(json['original_cv'] ?? {}),
      enhancedCv: Map<String, dynamic>.from(json['enhanced_cv'] ?? {}),
    );
  }
}