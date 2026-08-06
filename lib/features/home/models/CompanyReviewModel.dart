class CompanyReviewModel {
  final int? id;
  final String type;
  final int overallRating;
  final int workEnvironmentRating;
  final int salaryBenefitsRating;
  final int workLifeBalanceRating;
  final int interviewExperienceRating;
  final String title;
  final String pros;
  final String cons;
  final String advice;
  final int wouldRecommend;
  final int isAnonymous;
  final String? createdAt;
  final ReviewUser? user;

  CompanyReviewModel({
    this.id,
    required this.type,
    required this.overallRating,
    required this.workEnvironmentRating,
    required this.salaryBenefitsRating,
    required this.workLifeBalanceRating,
    required this.interviewExperienceRating,
    required this.title,
    required this.pros,
    required this.cons,
    required this.advice,
    required this.wouldRecommend,
    required this.isAnonymous,
    this.createdAt,
    this.user,
  });

  factory CompanyReviewModel.fromJson(Map<String, dynamic> json) {
    // معالجة حقل would_recommend في حال كان bool أو int تفادياً لأخطاء الـ Type mismatch
    int parsedWouldRecommend = 0;
    var rawRecommend = json['would_recommend'];
    if (rawRecommend is bool) {
      parsedWouldRecommend = rawRecommend ? 1 : 0;
    } else if (rawRecommend is int) {
      parsedWouldRecommend = rawRecommend;
    }

    // معالجة حقل is_anonymous بنفس الطريقة للأمان
    int parsedIsAnonymous = 0;
    var rawAnonymous = json['is_anonymous'];
    if (rawAnonymous is bool) {
      parsedIsAnonymous = rawAnonymous ? 1 : 0;
    } else if (rawAnonymous is int) {
      parsedIsAnonymous = rawAnonymous;
    }

    return CompanyReviewModel(
      id: json['id'],
      type: json['type'] ?? '',
      overallRating: json['overall_rating'] ?? 0,
      workEnvironmentRating: json['work_environment_rating'] ?? 0,
      salaryBenefitsRating: json['salary_benefits_rating'] ?? 0,
      workLifeBalanceRating: json['work_life_balance_rating'] ?? 0,
      interviewExperienceRating: json['interview_experience_rating'] ?? 0,
      title: json['title'] ?? '',
      pros: json['pros'] ?? '',
      cons: json['cons'] ?? '',
      advice: json['advice'] ?? '',
      wouldRecommend: parsedWouldRecommend,
      isAnonymous: parsedIsAnonymous,
      createdAt: json['created_at'],
      user: json['user'] != null ? ReviewUser.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'type': type,
      'overall_rating': overallRating,
      'work_environment_rating': workEnvironmentRating,
      'salary_benefits_rating': salaryBenefitsRating,
      'work_life_balance_rating': workLifeBalanceRating,
      'interview_experience_rating': interviewExperienceRating,
      'title': title,
      'pros': pros,
      'cons': cons,
      'advice': advice,
      'would_recommend': wouldRecommend,
      'is_anonymous': isAnonymous,
    };
  }
}

class ReviewUser {
  final int? id;
  final String? name;
  final String? email;

  ReviewUser({this.id, this.name, this.email});

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(id: json['id'], name: json['name'], email: json['email']);
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
    };
  }
}
