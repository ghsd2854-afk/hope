import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get.dart';

class CompanyModel {
  final int id;
  final String companyName;
  final String localAddress;

  CompanyModel({
    required this.id,
    required this.companyName,
    required this.localAddress,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] ?? 0,
      companyName: json['company_name'] ?? '',
      localAddress: json['local_address'] ?? '',
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
  final List<String> skills;
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

  JobPostModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.location,
    required this.isRemote,
    required this.salaryRange,
    required this.skills,
    required this.categoryId,
    required int reactionsCount,
    required int count,
    this.company,
    required List<String> reactionIcons,
    required bool isFollowingCompany,
    required bool isReacted,
    String? reactionType,
    required bool isSaved,
    required bool isApplied,
  }) : this.isFollowingCompany = isFollowingCompany.obs,
       this.isReacted = isReacted.obs,
       this.reactionType = RxnString(reactionType),
       isSaved = RxBool(isSaved),
       this.isApplied = isApplied.obs,
       this.reactionsCount = reactionsCount.obs,
       this.reactionIcons = reactionIcons.obs,
       commentsCount = count.obs;

  factory JobPostModel.fromJson(Map<String, dynamic> json) {
    print(
      "Job ID: ${json['id']}, IsSaved from Server: ${json['is_saved']},ISApplyed : ${json['is_applied']}",
    );
    print(
      "DEBUG: ID ${json['id']} | Count: ${json['reactions_count']} | Icons: ${json['reaction_icons']}",
    );
    return JobPostModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? 'full_time',
      location: json['location'] ?? '',
      isRemote: json['is_remote'] == 1 || json['is_remote'] == true,
      salaryRange: json['salary_range'] ?? '',
      skills: json['skills'] != null ? List<String>.from(json['skills']) : [],
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
    );
  }
}
