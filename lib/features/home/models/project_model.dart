class ProjectModel {
  int? id;
  int? userId;
  String? title;
  String? summary;
  String? description;
  String? stage;
  List<String>? supportTypes;
  String? category;
  dynamic fundingGoal;
  String? location;
  String? websiteUrl;
  String? status;
  int? views;
  int? offersCount;
  Map<String, dynamic>? user;
  List<dynamic>? invitations;
  List<dynamic>? interests;

  ProjectModel({
    this.id,
    this.userId,
    this.title,
    this.summary,
    this.description,
    this.stage,
    this.supportTypes,
    this.category,
    this.fundingGoal,
    this.location,
    this.websiteUrl,
    this.status,
    this.views,
    this.offersCount,
    this.user,
    this.invitations,
    this.interests,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      summary: json['summary'],
      description: json['description'],
      stage: json['stage'],
      supportTypes: json['support_types'] != null
          ? List<String>.from(json['support_types'])
          : [],
      category: json['category'],
      fundingGoal: json['funding_goal'],
      location: json['location'],
      websiteUrl: json['website_url'],
      status: json['status'],
      views: json['views'],
      offersCount: json['offers_count'],
      user: json['user'] is Map<String, dynamic> ? json['user'] : null,
      invitations: json['invitations'] != null
          ? List<dynamic>.from(json['invitations'])
          : [],
      interests: json['interests'] != null
          ? List<dynamic>.from(json['interests'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.id != null) data['id'] = this.id;
    data['title'] = this.title;
    data['summary'] = this.summary;
    data['description'] = this.description;
    data['stage'] = this.stage;
    if (this.supportTypes != null) {
      for (int i = 0; i < this.supportTypes!.length; i++) {
        data['support_types[$i]'] = this.supportTypes![i];
      }
    }
    data['category'] = this.category;
    data['funding_goal'] = this.fundingGoal;
    data['location'] = this.location;
    data['website_url'] = this.websiteUrl;
    data['offers_count'] = this.offersCount;
    return data;
  }
}
