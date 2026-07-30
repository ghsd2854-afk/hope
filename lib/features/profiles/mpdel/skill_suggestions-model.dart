class SkillSuggestionModel {
  final int? id;
  final int? userId;
  final String? name;
  final String? type;
  final String? source;
  final String? reason;
  final String? jobTitle;
  final int? confidence;
  final int? priority;
  final String? status;

  SkillSuggestionModel({
    this.id,
    this.userId,
    this.name,
    this.type,
    this.source,
    this.reason,
    this.jobTitle,
    this.confidence,
    this.priority,
    this.status,
  });

  factory SkillSuggestionModel.fromJson(
      Map<String, dynamic> json) {
    return SkillSuggestionModel(
      id: json["id"],
      userId: json["user_id"],
      name: json["name"],
      type: json["type"],
      source: json["source"],
      reason: json["reason"],
      jobTitle: json["job_title"],
      confidence: json["confidence"],
      priority: json["priority"],
      status: json["status"],
    );
  }
}