class ProfileCompletionModel {
  final int percentage;
  final String level;
  final String levelLabel;
  final Map<String, CompletionSection> sections;
  final List<MissingItem> missing;
  final List<RecommendationItem> recommendations;

  ProfileCompletionModel({
    required this.percentage,
    required this.level,
    required this.levelLabel,
    required this.sections,
    required this.missing,
    required this.recommendations,
  });

  factory ProfileCompletionModel.fromJson(Map<String, dynamic> json) {
    final sectionsJson = json["sections"] as Map<String, dynamic>? ?? {};
    final sectionsMap = sectionsJson.map(
      (key, value) => MapEntry(key, CompletionSection.fromJson(value)),
    );

    return ProfileCompletionModel(
      percentage: json["percentage"] ?? 0,
      level: json["level"] ?? "",
      levelLabel: json["level_label"] ?? "",
      sections: sectionsMap,
      missing: (json["missing"] as List<dynamic>? ?? [])
          .map((e) => MissingItem.fromJson(e))
          .toList(),
      recommendations: (json["recommendations"] as List<dynamic>? ?? [])
          .map((e) => RecommendationItem.fromJson(e))
          .toList(),
    );
  }
}

class CompletionSection {
  final bool completed;
  final int weight;
  final String label;
  final String icon;
  final int points;

  CompletionSection({
    required this.completed,
    required this.weight,
    required this.label,
    required this.icon,
    required this.points,
  });

  factory CompletionSection.fromJson(Map<String, dynamic> json) {
    return CompletionSection(
      completed: json["completed"] ?? false,
      weight: json["weight"] ?? 0,
      label: json["label"] ?? "",
      icon: json["icon"] ?? "",
      points: json["points"] ?? 0,
    );
  }
}

class MissingItem {
  final String key;
  final String label;
  final int weight;

  MissingItem({required this.key, required this.label, required this.weight});

  factory MissingItem.fromJson(Map<String, dynamic> json) {
    return MissingItem(
      key: json["key"] ?? "",
      label: json["label"] ?? "",
      weight: json["weight"] ?? 0,
    );
  }
}

class RecommendationItem {
  final String section;
  final String label;
  final int weight;
  final String message;
  final String priority;

  RecommendationItem({
    required this.section,
    required this.label,
    required this.weight,
    required this.message,
    required this.priority,
  });

  factory RecommendationItem.fromJson(Map<String, dynamic> json) {
    return RecommendationItem(
      section: json["section"] ?? "",
      label: json["label"] ?? "",
      weight: json["weight"] ?? 0,
      message: json["message"] ?? "",
      priority: json["priority"] ?? "",
    );
  }
}