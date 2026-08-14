/*class CompanyReviewModel {
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
    int parsedWouldRecommend = 0;
    var rawRecommend = json['would_recommend'];
    if (rawRecommend is bool) {
      parsedWouldRecommend = rawRecommend ? 1 : 0;
    } else if (rawRecommend is int) {
      parsedWouldRecommend = rawRecommend;
    }

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
}

class ReviewUser {
  final int? id;
  final String? name;
  final String? email;
  final String? photo; // أضفنا حقل الصورة ليتطابق مع التصميم

  ReviewUser({this.id, this.name, this.email, this.photo});

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photo: json['photo'],
    );
  }
}

// كلاس جديد خاص بالإحصائيات الظاهرة في الـ Response
class CompanyReviewStats {
  final double average;
  final int total;
  final int wouldRecommendPercentage;
  final Map<String, dynamic> categories;

  CompanyReviewStats({
    required this.average,
    required this.total,
    required this.wouldRecommendPercentage,
    required this.categories,
  });

  factory CompanyReviewStats.fromJson(Map<String, dynamic> json) {
    return CompanyReviewStats(
      average: (json['average'] ?? 0).toDouble(),
      total: json['total'] ?? 0,
      wouldRecommendPercentage: json['would_recommend'] ?? 0,
      categories: json['categories'] ?? {},
    );
  }
}
*/
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
  final ReviewUser?
  user; // سنبقي اسم المتغير user لتجنب تعديل واجهات العرض، أو يمكنك جعله reviewer

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
    int parsedWouldRecommend = 0;
    var rawRecommend = json['would_recommend'];
    if (rawRecommend is bool) {
      parsedWouldRecommend = rawRecommend ? 1 : 0;
    } else if (rawRecommend is int) {
      parsedWouldRecommend = rawRecommend;
    }

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
      // التعديل هنا: قراءة المفتاح الصحيح 'reviewer' من الـ JSON بدلاً من 'user'
      user: json['reviewer'] != null
          ? ReviewUser.fromJson(json['reviewer'])
          : null,
    );
  }
}

class ReviewUser {
  final int? id;
  final String? name;
  final String? email;
  final String? photo;

  ReviewUser({this.id, this.name, this.email, this.photo});

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photo: json['photo'],
    );
  }
}

class CompanyReviewStats {
  final double average;
  final int total;
  final int wouldRecommendPercentage;
  final Map<String, dynamic> categories;

  CompanyReviewStats({
    required this.average,
    required this.total,
    required this.wouldRecommendPercentage,
    required this.categories,
  });

  factory CompanyReviewStats.fromJson(Map<String, dynamic> json) {
    return CompanyReviewStats(
      average: (json['average'] ?? 0).toDouble(),
      total: json['total'] ?? 0,
      wouldRecommendPercentage: json['would_recommend'] ?? 0,
      categories: json['categories'] ?? {},
    );
  }
}
