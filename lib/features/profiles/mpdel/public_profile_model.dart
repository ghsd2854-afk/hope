class PublicProfileModel {
  final int? id;
  final int? userId;
  final String slug;
  final bool isPublic;
  final VisibleSections visibleSections;
  final int totalViews;
  final String? lastViewedAt;
  final String? metaTitle;
  final String? metaDescription;
  final String themeColor;
  final String? createdAt;
  final String? updatedAt;

  PublicProfileModel({
    this.id,
    this.userId,
    required this.slug,
    required this.isPublic,
    required this.visibleSections,
    required this.totalViews,
    this.lastViewedAt,
    this.metaTitle,
    this.metaDescription,
    required this.themeColor,
    this.createdAt,
    this.updatedAt,
  });

  factory PublicProfileModel.fromJson(Map<String, dynamic> json) {
    return PublicProfileModel(
      id: json["id"],
      userId: json["user_id"],
      slug: json["slug"] ?? "",
      isPublic: json["is_public"] ?? true,
      visibleSections:
          VisibleSections.fromJson(json["visible_sections"] ?? {}),
      totalViews: json["total_views"] ?? 0,
      lastViewedAt: json["last_viewed_at"],
      metaTitle: json["meta_title"],
      metaDescription: json["meta_description"],
      themeColor: json["theme_color"] ?? "#3B82F6",
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      "is_public": isPublic,
      "visible_sections": visibleSections.toJson(),
      "meta_title": metaTitle,
      "meta_description": metaDescription,
      "theme_color": themeColor,
    };
  }

  PublicProfileModel copyWith({
    bool? isPublic,
    VisibleSections? visibleSections,
    String? metaTitle,
    String? metaDescription,
    String? themeColor,
  }) {
    return PublicProfileModel(
      id: id,
      userId: userId,
      slug: slug,
      isPublic: isPublic ?? this.isPublic,
      visibleSections: visibleSections ?? this.visibleSections,
      totalViews: totalViews,
      lastViewedAt: lastViewedAt,
      metaTitle: metaTitle ?? this.metaTitle,
      metaDescription: metaDescription ?? this.metaDescription,
      themeColor: themeColor ?? this.themeColor,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class VisibleSections {
  final bool contactInfo;
  final bool experience;
  final bool education;
  final bool skills;
  final bool projects;
  final bool certifications;
  final bool reviews;

  VisibleSections({
    required this.contactInfo,
    required this.experience,
    required this.education,
    required this.skills,
    required this.projects,
    required this.certifications,
    required this.reviews,
  });

  factory VisibleSections.fromJson(Map<String, dynamic> json) {
    return VisibleSections(
      contactInfo: json["contact_info"] ?? false,
      experience: json["experience"] ?? true,
      education: json["education"] ?? true,
      skills: json["skills"] ?? true,
      projects: json["projects"] ?? true,
      certifications: json["certifications"] ?? true,
      reviews: json["reviews"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "contact_info": contactInfo,
      "experience": experience,
      "education": education,
      "skills": skills,
      "projects": projects,
      "certifications": certifications,
      "reviews": reviews,
    };
  }

  VisibleSections copyWith({
    bool? contactInfo,
    bool? experience,
    bool? education,
    bool? skills,
    bool? projects,
    bool? certifications,
    bool? reviews,
  }) {
    return VisibleSections(
      contactInfo: contactInfo ?? this.contactInfo,
      experience: experience ?? this.experience,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      projects: projects ?? this.projects,
      certifications: certifications ?? this.certifications,
      reviews: reviews ?? this.reviews,
    );
  }
}