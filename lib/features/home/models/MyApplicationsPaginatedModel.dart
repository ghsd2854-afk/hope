import 'package:hobe/features/Icons_home/models/JobPostModel.dart';

class MyApplicationsPaginatedModel {
  final int? currentPage;
  final int? lastPage;
  final int? total;
  final List<MyApplicationItemModel> applications; // التعديل هنا

  MyApplicationsPaginatedModel({
    this.currentPage,
    this.lastPage,
    this.total,
    required this.applications,
  });

  factory MyApplicationsPaginatedModel.fromJson(Map<String, dynamic> json) {
    var rawList = json['data'] as List? ?? [];
    List<MyApplicationItemModel> parsedApps = rawList
        .map(
          (item) =>
              MyApplicationItemModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();

    return MyApplicationsPaginatedModel(
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      total: json['total'],
      applications: parsedApps,
    );
  }
}

// تغيير الاسم لعدم التعارض مع مودل التقديم
class MyApplicationItemModel {
  final int id;
  final int jobPostId;
  final String status;
  final String? coverLetter;
  final String? cvFile;
  final bool canReapply;
  final String createdAt;
  final JobPostModel? jobPost;

  MyApplicationItemModel({
    required this.id,
    required this.jobPostId,
    required this.status,
    this.coverLetter,
    this.cvFile,
    required this.canReapply,
    required this.createdAt,
    this.jobPost,
  });

  factory MyApplicationItemModel.fromJson(Map<String, dynamic> json) {
    return MyApplicationItemModel(
      id: json['id'],
      jobPostId: json['job_post_id'],
      status: json['status'] ?? 'pending',
      coverLetter: json['cover_letter'],
      cvFile: json['cv_file'],
      canReapply: json['can_reapply'] ?? true,
      createdAt: json['created_at'] ?? '',
      jobPost: json['job_post'] != null
          ? JobPostModel.fromJson(json['job_post'])
          : null,
    );
  }
}
