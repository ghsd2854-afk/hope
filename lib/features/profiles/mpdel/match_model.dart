class MatchModel {
  final int matchScore;

  final int skills;
  final int experience;
  final int education;
  final int tools;

  MatchModel({
    required this.matchScore,
    required this.skills,
    required this.experience,
    required this.education,
    required this.tools,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      matchScore: json["match_score"] ?? 0,
      skills: json["breakdown"]["skills"] ?? 0,
      experience: json["breakdown"]["experience"] ?? 0,
      education: json["breakdown"]["education"] ?? 0,
      tools: json["breakdown"]["tools"] ?? 0,
    );
  }
}