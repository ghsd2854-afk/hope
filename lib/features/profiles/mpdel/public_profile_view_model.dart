class PublicProfileViewModel {
  final PublicUser user;
  final String publicUrl;
  final String themeColor;
  final String slug;
  final PublicStats stats;
  final List<PublicExperience> experiences;
  final List<PublicEducation> educations;
  final List<PublicSkill> skills;
  final List<PublicProject> projects;
  final List<PublicCertification> certifications;

  PublicProfileViewModel({
    required this.user,
    required this.publicUrl,
    required this.themeColor,
    required this.slug,
    required this.stats,
    required this.experiences,
    required this.educations,
    required this.skills,
    required this.projects,
    required this.certifications,
  });

  factory PublicProfileViewModel.fromJson(Map<String, dynamic> json) {
    return PublicProfileViewModel(
      user: PublicUser.fromJson(json["user"] ?? {}),
      publicUrl: json["public_url"] ?? "",
      themeColor: json["theme_color"] ?? "#3B82F6",
      slug: json["slug"] ?? "",
      stats: PublicStats.fromJson(json["stats"] ?? {}),
      experiences: (json["experiences"] as List<dynamic>? ?? [])
          .map((e) => PublicExperience.fromJson(e))
          .toList(),
      educations: (json["educations"] as List<dynamic>? ?? [])
          .map((e) => PublicEducation.fromJson(e))
          .toList(),
      skills: (json["skills"] as List<dynamic>? ?? [])
          .map((e) => PublicSkill.fromJson(e))
          .toList(),
      projects: (json["projects"] as List<dynamic>? ?? [])
          .map((e) => PublicProject.fromJson(e))
          .toList(),
      certifications: (json["certifications"] as List<dynamic>? ?? [])
          .map((e) => PublicCertification.fromJson(e))
          .toList(),
    );
  }
}

class PublicUser {
  final int? id;
  final String? name;
  final String? headline;
  final String? summary;
  final String? country;
  final String? city;
  final String? photo;
  final String? linkedin;
  final String? github;
  final String? portfolio;

  PublicUser({
    this.id,
    this.name,
    this.headline,
    this.summary,
    this.country,
    this.city,
    this.photo,
    this.linkedin,
    this.github,
    this.portfolio,
  });

  factory PublicUser.fromJson(Map<String, dynamic> json) {
    return PublicUser(
      id: json["id"],
      name: json["name"],
      headline: json["headline"],
      summary: json["summary"],
      country: json["country"],
      city: json["city"],
      photo: json["photo"],
      linkedin: json["linkedin"],
      github: json["github"],
      portfolio: json["portfolio"],
    );
  }
}

class PublicStats {
  final int totalViews;
  final int viewsThisWeek;
  final int viewsThisMonth;
  final String? lastViewedAt;

  PublicStats({
    required this.totalViews,
    required this.viewsThisWeek,
    required this.viewsThisMonth,
    this.lastViewedAt,
  });

  factory PublicStats.fromJson(Map<String, dynamic> json) {
    return PublicStats(
      totalViews: json["total_views"] ?? 0,
      viewsThisWeek: json["views_this_week"] ?? 0,
      viewsThisMonth: json["views_this_month"] ?? 0,
      lastViewedAt: json["last_viewed_at"]?.toString(),
    );
  }
}

class PublicExperience {
  final String company;
  final String position;
  final String? startDate;
  final String? endDate;
  final bool isCurrent;
  final String? description;

  PublicExperience({
    required this.company,
    required this.position,
    this.startDate,
    this.endDate,
    required this.isCurrent,
    this.description,
  });

  factory PublicExperience.fromJson(Map<String, dynamic> json) {
    return PublicExperience(
      company: json["company"] ?? "",
      position: json["position"] ?? "",
      startDate: json["start_date"],
      endDate: json["end_date"],
      isCurrent: json["is_current"] ?? false,
      description: json["description"],
    );
  }
}

class PublicEducation {
  final String institution;
  final String? degree;
  final String? fieldOfStudy;
  final String? startDate;
  final String? endDate;

  PublicEducation({
    required this.institution,
    this.degree,
    this.fieldOfStudy,
    this.startDate,
    this.endDate,
  });

  factory PublicEducation.fromJson(Map<String, dynamic> json) {
    return PublicEducation(
      institution: json["institution"] ?? "",
      degree: json["degree"],
      fieldOfStudy: json["field_of_study"],
      startDate: json["start_date"],
      endDate: json["end_date"],
    );
  }
}

class PublicSkill {
  final String name;
  final String type;
  final String level;

  PublicSkill({required this.name, required this.type, required this.level});

  factory PublicSkill.fromJson(Map<String, dynamic> json) {
    return PublicSkill(
      name: json["name"] ?? "",
      type: json["type"] ?? "",
      level: json["level"] ?? "",
    );
  }
}

class PublicProject {
  final String title;
  final String? description;
  final String? link;
  final List<String> technologies;

  PublicProject({
    required this.title,
    this.description,
    this.link,
    required this.technologies,
  });

  factory PublicProject.fromJson(Map<String, dynamic> json) {
    return PublicProject(
      title: json["title"] ?? "",
      description: json["description"],
      link: json["link"],
      technologies: (json["technologies"] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}

class PublicCertification {
  final String name;
  final String? issuer;
  final String? issuedAt;
  final String? expiresAt;

  PublicCertification({
    required this.name,
    this.issuer,
    this.issuedAt,
    this.expiresAt,
  });

  factory PublicCertification.fromJson(Map<String, dynamic> json) {
    return PublicCertification(
      name: json["name"] ?? "",
      issuer: json["issuer"],
      issuedAt: json["issued_at"],
      expiresAt: json["expires_at"],
    );
  }
}