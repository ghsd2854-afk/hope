class AnalyzeModel {
  final double atsScore;
  final double matchScore;
  final double finalScore;

  final List<dynamic> strengths;
  final List<dynamic> weaknesses;
  final List<dynamic> improvements;

  final List<dynamic> recommendedSkills;
  final List<dynamic> careerPaths;

  AnalyzeModel({
    required this.atsScore,
    required this.matchScore,
    required this.finalScore,
    required this.strengths,
    required this.weaknesses,
    required this.improvements,
    required this.recommendedSkills,
    required this.careerPaths,
  });

  factory AnalyzeModel.fromJson(
      Map<String, dynamic> json) {

    final analysis = json["analysis"];

    return AnalyzeModel(
      atsScore:
          (analysis["ats_score"] ?? 0).toDouble(),

      matchScore:
          (analysis["match_score"] ?? 0).toDouble(),

      finalScore:
          (analysis["final_score"] ?? 0).toDouble(),

      strengths:
          List<dynamic>.from(
        analysis["strengths"] ?? [],
      ),

      weaknesses:
          List<dynamic>.from(
        analysis["weaknesses"] ?? [],
      ),

      improvements:
          List<dynamic>.from(
        analysis["improvements"] ?? [],
      ),

      recommendedSkills:
          List<dynamic>.from(
        analysis["skills"]
                ?["recommended_skills"] ??
            [],
      ),

      careerPaths:
          List<dynamic>.from(
        analysis["job_roles"] ?? [],
      ),
    );
  }
}