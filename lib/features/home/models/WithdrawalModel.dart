class WithdrawalModel {
  final int id;
  final int jobApplicationId;
  final int? jobPostId;
  final String reasonCategory;
  final String? reasonDetails;
  final String? previousStatus;
  final String? createdAt;
  final String? jobTitle;
  final String? location;
  final String? jobType;
  final bool canReapply;

  WithdrawalModel({
    required this.id,
    required this.jobApplicationId,
    this.jobPostId,
    required this.reasonCategory,
    this.reasonDetails,
    this.previousStatus,
    this.createdAt,
    this.jobTitle,
    this.location,
    this.jobType,
    this.canReapply = false,
  });

  factory WithdrawalModel.fromJson(Map<String, dynamic> json) {
    final jobApp = json['job_application'] ?? {};
    final jobPost = jobApp['job_post'] ?? {};

    return WithdrawalModel(
      id: json['id'] ?? 0,
      jobApplicationId: json['job_application_id'] ?? 0,
      jobPostId: jobPost['id'],
      reasonCategory: json['reason_category'] ?? '',
      reasonDetails: json['reason_details'],
      previousStatus: json['previous_status'],
      createdAt: json['created_at'],
      jobTitle: jobPost['title'],
      location: jobPost['location'],
      jobType: jobPost['type'],
      canReapply: jobApp['can_reapply'] ?? false,
    );
  }
}
