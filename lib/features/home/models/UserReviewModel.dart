class UserReviewsModel {
  final bool success;
  final String message;
  final UserReviewsData data;

  UserReviewsModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserReviewsModel.fromJson(Map<String, dynamic> json) {
    bool isSuccess = json['success'] == true || json['status'] == 'success';

    // التحقق مما إذا كانت data عبارة عن Map، وإلا يتم التعامل معها كـ Map فارغة لمنع الـ Crash
    var rawData = json['data'];
    Map<String, dynamic> dataMap = {};
    if (rawData is Map<String, dynamic>) {
      dataMap = rawData;
    }

    return UserReviewsModel(
      success: isSuccess,
      message: json['message'] ?? '',
      data: UserReviewsData.fromJson(dataMap),
    );
  }
}

class UserReviewsData {
  final ReviewsPagination reviews;
  final ReviewStats? stats;

  UserReviewsData({required this.reviews, this.stats});

  factory UserReviewsData.fromJson(Map<String, dynamic> json) {
    var statsJson = json['rating_stats'] ?? json['stats'];
    ReviewStats? parsedStats;

    if (statsJson is Map<String, dynamic>) {
      parsedStats = ReviewStats.fromJson(statsJson);
    }

    // التحقق من أن reviews هي Map أيضاً لمنع أي خطأ مشابه
    var reviewsJson = json['reviews'];
    Map<String, dynamic> reviewsMap = {};
    if (reviewsJson is Map<String, dynamic>) {
      reviewsMap = reviewsJson;
    } else if (reviewsJson is List) {
      // لو كان السيرفر يرسل الـ reviews كقائمة مباشرة
      reviewsMap = {'data': reviewsJson};
    }

    return UserReviewsData(
      reviews: ReviewsPagination.fromJson(reviewsMap),
      stats: parsedStats,
    );
  }
}

class ReviewsPagination {
  final List<ReviewItem> data;

  ReviewsPagination({required this.data});

  factory ReviewsPagination.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List? ?? [];
    List<ReviewItem> reviewsList = list
        .map((i) => ReviewItem.fromJson(i))
        .toList();
    return ReviewsPagination(data: reviewsList);
  }
}

class ReviewItem {
  final int id;
  final int overallRating;
  final String pros;
  final Reviewer reviewer;

  ReviewItem({
    required this.id,
    required this.overallRating,
    required this.pros,
    required this.reviewer,
  });

  factory ReviewItem.fromJson(Map<String, dynamic> json) {
    return ReviewItem(
      id: json['id'] ?? 0,
      overallRating: json['overall_rating'] ?? 0,
      pros: json['pros'] ?? '',
      reviewer: Reviewer.fromJson(json['reviewer'] ?? {}),
    );
  }
}

class Reviewer {
  final int id;
  final String name;
  final String? photo;

  Reviewer({required this.id, required this.name, this.photo});

  factory Reviewer.fromJson(Map<String, dynamic> json) {
    return Reviewer(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      photo: json['photo'],
    );
  }
}

class ReviewStats {
  final double average;
  final int total;
  final Map<String, dynamic> distribution;
  final Map<String, dynamic> categories;

  ReviewStats({
    required this.average,
    required this.total,
    required this.distribution,
    required this.categories,
  });

  factory ReviewStats.fromJson(Map<String, dynamic> json) {
    return ReviewStats(
      average: double.tryParse(json['average']?.toString() ?? '0') ?? 0.0,
      total: json['total'] ?? 0,
      distribution: json['distribution'] is Map<String, dynamic>
          ? json['distribution']
          : {},
      categories: json['categories'] is Map<String, dynamic>
          ? json['categories']
          : {},
    );
  }
}
