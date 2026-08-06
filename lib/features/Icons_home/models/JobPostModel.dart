import 'package:get/get.dart';

class CompanyModel {
  final int id;
  final String companyName;
  final String localAddress;
  final String? websiteUrl;
  final String? category;
  final String? status;

  CompanyModel({
    required this.id,
    required this.companyName,
    required this.localAddress,
    this.websiteUrl,
    this.category,
    this.status,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] ?? 0,
      companyName: json['company_name'] ?? '',
      localAddress: json['local_address'] ?? '',
      websiteUrl: json['website_url'],
      category: json['category'],
      status: json['status'],
    );
  }
}

class JobPostModel {
  final int id;
  final String title;
  final String description;
  final String type;
  final String location;
  final bool isRemote;
  final String salaryRange;
  final int? salaryMin;
  final int? salaryMax;
  final String? currency;
  final List<String> skills;
  final List<String> tags;
  final RxInt views;
  final int applicationsCount;
  final RxInt reactionsCount;
  final int categoryId;
  RxInt commentsCount;
  final CompanyModel? company;
  final RxList<String> reactionIcons;
  RxBool isFollowingCompany;
  RxBool isReacted;
  RxnString reactionType;
  RxBool isSaved;
  RxBool isApplied;
  final bool canApply;
  final bool isOwner;
  final String? publishedSince;
  final String? expiresosIn;
  RxBool isExpanded = false.obs;

  JobPostModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.location,
    required this.isRemote,
    required this.salaryRange,
    this.salaryMin,
    this.salaryMax,
    this.currency,
    required this.skills,
    required this.tags,
    required int views,
    required this.applicationsCount,
    required int reactionsCount,
    required this.categoryId,
    required int count,
    this.company,
    required List<String> reactionIcons,
    required bool isFollowingCompany,
    required bool isReacted,
    String? reactionType,
    required bool isSaved,
    required bool isApplied,
    required this.canApply,
    required this.isOwner,
    this.publishedSince,
    this.expiresosIn,
  }) : this.views = views.obs,
       this.isFollowingCompany = isFollowingCompany.obs,
       this.isReacted = isReacted.obs,
       this.reactionType = RxnString(reactionType),
       this.isSaved = RxBool(isSaved),
       this.isApplied = isApplied.obs,
       this.reactionsCount = reactionsCount.obs,
       this.reactionIcons = reactionIcons.obs,
       commentsCount = count.obs;

  factory JobPostModel.fromJson(Map<String, dynamic> json) {
    // دمج الحد الأدنى والحد الأقصى للراتب كنص جاهز إذا لم يرسله السيرفر جاهزاً
    String calculatedSalary = json['salary_range'] ?? '';
    if (calculatedSalary.isEmpty &&
        json['salary_min'] != null &&
        json['salary_max'] != null) {
      calculatedSalary =
          "${json['salary_min']} - ${json['salary_max']} ${json['currency'] ?? 'USD'}";
    }

    return JobPostModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? 'full_time',
      location: json['location'] ?? '',
      isRemote: json['is_remote'] == 1 || json['is_remote'] == true,
      salaryRange: calculatedSalary,
      salaryMin: json['salary_min'],
      salaryMax: json['salary_max'],
      currency: json['currency'],
      skills: json['skills'] != null ? List<String>.from(json['skills']) : [],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      views: json['views'] ?? 0,
      applicationsCount: json['applications_count'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      reactionsCount: json['reactions_count'] ?? 0,
      count: json['comments_count'] ?? 0,
      company: json['company'] != null
          ? CompanyModel.fromJson(json['company'])
          : null,
      reactionIcons: List<String>.from(json['reaction_icons'] ?? []),
      isFollowingCompany: json['is_following_company'] ?? false,
      isReacted: json['is_reacted'] ?? false,
      reactionType: json['reaction_type'],
      isSaved: json['is_saved'] ?? false,
      isApplied: json['has_applied'] ?? false,
      canApply: json['can_apply'] ?? false,
      isOwner: json['is_owner'] ?? false,
      publishedSince: json['published_since'],
      expiresosIn: json['expires_in'],
    );
  }
}
