class MyReviewModel {
  final int id;
  final int jobApplicationId;
  final int reviewerId;
  final int revieweeId;
  final String type;
  final int overallRating;
  final int? technicalSkillsRating;
  final int? communicationRating;
  final int? professionalismRating;
  final int? reliabilityRating;
  final String? title;

  MyReviewModel({
    required this.id,
    required this.jobApplicationId,
    required this.reviewerId,
    required this.revieweeId,
    required this.type,
    required this.overallRating,
    this.technicalSkillsRating,
    this.communicationRating,
    this.professionalismRating,
    this.reliabilityRating,
    this.title,
  });

  factory MyReviewModel.fromJson(Map<String, dynamic> json) {
    return MyReviewModel(
      id: json['id'],
      jobApplicationId: json['job_application_id'],
      reviewerId: json['reviewer_id'],
      revieweeId: json['reviewee_id'],
      type: json['type'],
      overallRating: json['overall_rating'] ?? 0,
      technicalSkillsRating: json['technical_skills_rating'],
      communicationRating: json['communication_rating'],
      professionalismRating: json['professionalism_rating'],
      reliabilityRating: json['reliability_rating'],
      title: json['title'],
    );
  }
}
