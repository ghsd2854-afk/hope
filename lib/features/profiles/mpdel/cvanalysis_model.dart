// lib/features/profiles/mpdel/cvanalysis_model.dart

class CvAnalysisResultModel {
  final Map<String, dynamic> optimizedCv;
  final CvAnalysisDetails analysis;

  CvAnalysisResultModel({
    required this.optimizedCv,
    required this.analysis,
  });

  factory CvAnalysisResultModel.fromJson(Map<String, dynamic> json) {
    return CvAnalysisResultModel(
      optimizedCv: Map<String, dynamic>.from(json['optimized_cv'] ?? {}),
      analysis: CvAnalysisDetails.fromJson(json['analysis'] ?? {}),
    );
  }
}

class CvAnalysisDetails {
  final int atsScore;
  final int matchScore;
  final double semanticScore;
  final double finalScore;
  final int jobReadinessScore;
  final double totalExperienceYears;
  final String marketFit;
  final String seniorityLevel;
  final List<String> careerPaths;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> improvements;
  final List<Map<String, dynamic>> jobRoles;
  final Map<String, dynamic> marketIntelligence;
  final Map<String, dynamic> skills;
  final Map<String, dynamic> matchBreakdown;

  CvAnalysisDetails({
    required this.atsScore,
    required this.matchScore,
    required this.semanticScore,
    required this.finalScore,
    required this.jobReadinessScore,
    required this.totalExperienceYears,
    required this.marketFit,
    required this.seniorityLevel,
    required this.careerPaths,
    required this.strengths,
    required this.weaknesses,
    required this.improvements,
    required this.jobRoles,
    required this.marketIntelligence,
    required this.skills,
    required this.matchBreakdown,
  });

  factory CvAnalysisDetails.fromJson(Map<String, dynamic> json) {
    return CvAnalysisDetails(
      atsScore: json['ats_score'] ?? 0,
      matchScore: json['match_score'] ?? 0,
      semanticScore: (json['semantic_score'] ?? 0).toDouble(),
      finalScore: (json['final_score'] ?? 0).toDouble(),
      jobReadinessScore: json['job_readiness_score'] ?? 0,
      totalExperienceYears: (json['total_experience_years'] ?? 0).toDouble(),
      marketFit: json['market_fit'] ?? "",
      seniorityLevel: json['seniority_level'] ?? "",
      careerPaths: (json['career_paths'] as List<dynamic>? ?? [])
    .map((e) => e is String ? e : (e['title'] ?? e.toString()))
    .toList()
    .cast<String>(),
      strengths: List<String>.from(json['strengths'] ?? []),
      weaknesses: List<String>.from(json['weaknesses'] ?? []),
      improvements: List<String>.from(json['improvements'] ?? []),
      jobRoles: List<Map<String, dynamic>>.from(
        (json['job_roles'] as List<dynamic>? ?? [])
            .map((e) => Map<String, dynamic>.from(e)),
      ),
      marketIntelligence:
          Map<String, dynamic>.from(json['market_intelligence'] ?? {}),
      skills: Map<String, dynamic>.from(json['skills'] ?? {}),
      matchBreakdown: Map<String, dynamic>.from(json['match_breakdown'] ?? {}),
    );
  }
}