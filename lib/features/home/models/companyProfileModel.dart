/*class CompanyProfileModel {
  final CompanyModel? company;
  final UserModel? user;
  final List<JobModel> jobs;
  final List<dynamic> projects;
  final StatsModel? stats;

  CompanyProfileModel({
    this.company,
    this.user,
    required this.jobs,
    required this.projects,
    this.stats,
  });

  factory CompanyProfileModel.fromJson(Map<String, dynamic> json) {
    return CompanyProfileModel(
      company: json['company'] != null
          ? CompanyModel.fromJson(json['company'])
          : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      jobs: json['jobs'] != null
          ? (json['jobs'] as List).map((v) => JobModel.fromJson(v)).toList()
          : [],
      projects: json['projects'] ?? [],
      stats: json['stats'] != null ? StatsModel.fromJson(json['stats']) : null,
    );
  }
}*/
class CompanyProfileModel {
  final CompanyModel? company;
  final UserModel? user;
  final List<JobModel> jobs;
  final List<dynamic> projects;
  final StatsModel? stats;

  CompanyProfileModel({
    this.company,
    this.user,
    required this.jobs,
    required this.projects,
    this.stats,
  });

  factory CompanyProfileModel.fromJson(Map<String, dynamic> json) {
    // 🌟 التعديل هنا: سحب البيانات من مفتاح 'data' الموجود في الـ Response
    final data = json['data'] ?? json;

    return CompanyProfileModel(
      company: data['company'] != null
          ? CompanyModel.fromJson(data['company'])
          : null,
      user: data['user'] != null ? UserModel.fromJson(data['user']) : null,
      jobs: data['jobs'] != null
          ? (data['jobs'] as List).map((v) => JobModel.fromJson(v)).toList()
          : [],
      projects: data['projects'] ?? [],
      stats: data['stats'] != null ? StatsModel.fromJson(data['stats']) : null,
    );
  }
}

class CompanyModel {
  final int id;
  final int userId;
  final String companyName;
  final String? description;
  final String? websiteUrl;
  final String? localAddress;
  final String? phone;
  final List<String> supportOffers;
  final String? category;
  final String? logo;
  final String? coverImage;
  final int isVerified;
  final String? verifiedAt;
  final String? status;

  CompanyModel({
    required this.id,
    required this.userId,
    required this.companyName,
    this.description,
    this.websiteUrl,
    this.localAddress,
    this.phone,
    required this.supportOffers,
    this.category,
    this.logo,
    this.coverImage,
    required this.isVerified,
    this.verifiedAt,
    this.status,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      companyName: json['company_name'] ?? '',
      description: json['description'],
      websiteUrl: json['website_url'],
      localAddress: json['local_address'],
      phone: json['phone'],
      supportOffers: json['support_offers'] != null
          ? List<String>.from(json['support_offers'])
          : [],
      category: json['category'],
      logo: json['logo'],
      coverImage: json['cover_image'],
      isVerified: json['is_verified'] ?? 0,
      verifiedAt: json['verified_at'],
      status: json['status'],
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String email;

  UserModel({required this.id, required this.name, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class JobModel {
  final int id;
  final String title;
  final String location;
  final String type;
  final bool isRemote;
  final String createdAt;

  JobModel({
    required this.id,
    required this.title,
    required this.location,
    required this.type,
    required this.isRemote,
    required this.createdAt,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      type: json['type'] ?? '',
      isRemote: json['is_remote'] ?? false,
      createdAt: json['created_at'] ?? '',
    );
  }
}

class StatsModel {
  final int totalJobs;
  final int totalProjects;
  final int followers;

  StatsModel({
    required this.totalJobs,
    required this.totalProjects,
    required this.followers,
  });

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      totalJobs: json['total_jobs'] ?? 0,
      totalProjects: json['total_projects'] ?? 0,
      followers: json['followers'] ?? 0,
    );
  }
}
