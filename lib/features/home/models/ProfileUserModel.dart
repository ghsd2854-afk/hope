class PublicProfileResponse {
  final String status;
  final PublicProfileData data;

  PublicProfileResponse({required this.status, required this.data});

  factory PublicProfileResponse.fromJson(Map<String, dynamic> json) {
    return PublicProfileResponse(
      status: json['status'] ?? '',
      data: PublicProfileData.fromJson(json['data'] ?? {}),
    );
  }
}

class PublicProfileData {
  final User user;
  final String publicUrl;
  final String themeColor;
  final String slug;
  final Stats stats;
  final List<Experience> experiences;
  final List<Education> educations;
  final List<Skill> skills;
  final List<Project> projects;
  final List<Review> reviews;

  PublicProfileData({
    required this.user,
    required this.publicUrl,
    required this.themeColor,
    required this.slug,
    required this.stats,
    required this.experiences,
    required this.educations,
    required this.skills,
    required this.projects,
    required this.reviews,
  });

  factory PublicProfileData.fromJson(Map<String, dynamic> json) {
    return PublicProfileData(
      user: User.fromJson(json['user'] ?? {}),
      publicUrl: json['public_url'] ?? '',
      themeColor: json['theme_color'] ?? '#10B981',
      slug: json['slug'] ?? '',
      stats: Stats.fromJson(json['stats'] ?? {}),
      experiences:
          (json['experiences'] as List<dynamic>?)
              ?.map((e) => Experience.fromJson(e))
              .toList() ??
          [],
      educations:
          (json['educations'] as List<dynamic>?)
              ?.map((e) => Education.fromJson(e))
              .toList() ??
          [],
      skills:
          (json['skills'] as List<dynamic>?)
              ?.map((e) => Skill.fromJson(e))
              .toList() ??
          [],
      projects:
          (json['projects'] as List<dynamic>?)
              ?.map((e) => Project.fromJson(e))
              .toList() ??
          [],
      reviews:
          (json['reviews'] as List<dynamic>?)
              ?.map((e) => Review.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class User {
  final int id;
  final String? name;
  final String headline;
  final String summary;
  final String country;
  final String city;
  final String? photo;
  final String linkedin;
  final String github;
  final String portfolio;

  User({
    required this.id,
    this.name,
    required this.headline,
    required this.summary,
    required this.country,
    required this.city,
    this.photo,
    required this.linkedin,
    required this.github,
    required this.portfolio,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['full_name'] ?? json['name'] ?? json['username'] ?? 'مستخدم',
      headline: json['headline'] ?? '',
      summary: json['summary'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      photo: json['photo'],
      linkedin: json['linkedin'] ?? '',
      github: json['github'] ?? '',
      portfolio: json['portfolio'] ?? '',
    );
  }
}

class Stats {
  final int totalViews;
  final int viewsThisWeek;
  final int viewsThisMonth;
  final String lastViewedAt;

  Stats({
    required this.totalViews,
    required this.viewsThisWeek,
    required this.viewsThisMonth,
    required this.lastViewedAt,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      totalViews: json['total_views'] ?? 0,
      viewsThisWeek: json['views_this_week'] ?? 0,
      viewsThisMonth: json['views_this_month'] ?? 0,
      lastViewedAt: json['last_viewed_at'] ?? '',
    );
  }
}

class Experience {
  final int id;
  final String company;
  final String position;
  final String startDate;
  final String? endDate;
  final bool isCurrent;
  final String description;
  final List<String> technologiesUsed;

  Experience({
    required this.id,
    required this.company,
    required this.position,
    required this.startDate,
    this.endDate,
    required this.isCurrent,
    required this.description,
    required this.technologiesUsed,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'] ?? 0,
      company: json['company'] ?? '',
      position: json['position'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'],
      isCurrent: json['is_current'] ?? false,
      description: json['description'] ?? '',
      technologiesUsed: List<String>.from(json['technologies_used'] ?? []),
    );
  }
}

class Education {
  final int id;
  final String institution;
  final String degree;
  final String fieldOfStudy;
  final String startDate;
  final String endDate;
  final dynamic grade;

  Education({
    required this.id,
    required this.institution,
    required this.degree,
    required this.fieldOfStudy,
    required this.startDate,
    required this.endDate,
    this.grade,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'] ?? 0,
      institution: json['institution'] ?? '',
      degree: json['degree'] ?? '',
      fieldOfStudy: json['field_of_study'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      grade: json['grade'],
    );
  }
}

class Skill {
  final int id;
  final String name;
  final String type;
  final String level;
  final int? yearsExperience;

  Skill({
    required this.id,
    required this.name,
    required this.type,
    required this.level,
    this.yearsExperience,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      level: json['level'] ?? '',
      yearsExperience: json['years_experience'],
    );
  }
}

class Project {
  final int id;
  final String title;
  final String description;
  final String? link;
  final List<String> technologies;

  Project({
    required this.id,
    required this.title,
    required this.description,
    this.link,
    required this.technologies,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      link: json['link'],
      technologies: List<String>.from(json['technologies'] ?? []),
    );
  }
}

class Review {
  final int id;
  final int overallRating;
  final int technicalSkillsRating;
  final int communicationRating;
  final int professionalismRating;
  final int reliabilityRating;
  final String pros;
  final Reviewer reviewer;

  Review({
    required this.id,
    required this.overallRating,
    required this.technicalSkillsRating,
    required this.communicationRating,
    required this.professionalismRating,
    required this.reliabilityRating,
    required this.pros,
    required this.reviewer,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? 0,
      overallRating: json['overall_rating'] ?? 0,
      technicalSkillsRating: json['technical_skills_rating'] ?? 0,
      communicationRating: json['communication_rating'] ?? 0,
      professionalismRating: json['professionalism_rating'] ?? 0,
      reliabilityRating: json['reliability_rating'] ?? 0,
      pros: json['pros'] ?? '',
      reviewer: Reviewer.fromJson(json['reviewer'] ?? {}),
    );
  }
}

class Reviewer {
  final int id;
  final String name;
  final String role;

  Reviewer({required this.id, required this.name, required this.role});

  factory Reviewer.fromJson(Map<String, dynamic> json) {
    return Reviewer(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      role: json['role'] ?? '',
    );
  }
}
