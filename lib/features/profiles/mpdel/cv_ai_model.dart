// lib/features/profiles/mpdel/cv_full_model.dart

class CvFullModel {
  final CvHeaderInfo header;
  final String summary;
  final CvSkillsInfo skills;
  final List<CvExperienceInfo> experience;
  final List<CvEducationInfo> education;
  final List<CvProjectInfo> projects;
  final List<CvCertificationInfo> certifications;
  final List<CvTrainingInfo> trainings;
  final List<CvInterestInfo> interests;

  CvFullModel({
    required this.header,
    required this.summary,
    required this.skills,
    required this.experience,
    required this.education,
    required this.projects,
    required this.certifications,
    required this.trainings,
    required this.interests,
  });

  factory CvFullModel.fromJson(Map<String, dynamic> json) {
    return CvFullModel(
      header: CvHeaderInfo.fromJson(json['header'] ?? {}),
      summary: json['summary'] ?? "",
      skills: CvSkillsInfo.fromJson(json['skills'] ?? {}),
      experience: (json['experience'] as List<dynamic>? ?? [])
          .map((e) => CvExperienceInfo.fromJson(e))
          .toList(),
      education: (json['education'] as List<dynamic>? ?? [])
          .map((e) => CvEducationInfo.fromJson(e))
          .toList(),
      projects: (json['projects'] as List<dynamic>? ?? [])
          .map((e) => CvProjectInfo.fromJson(e))
          .toList(),
      certifications: (json['certifications'] as List<dynamic>? ?? [])
          .map((e) => CvCertificationInfo.fromJson(e))
          .toList(),
      trainings: (json['trainings'] as List<dynamic>? ?? [])
          .map((e) => CvTrainingInfo.fromJson(e))
          .toList(),
      interests: (json['interests'] as List<dynamic>? ?? [])
          .map((e) => CvInterestInfo.fromJson(e))
          .toList(),
    );
  }
}

class CvHeaderInfo {
  final String name;
  final String title;
  final String email;
  final String phone;
  final String location;
  final String linkedin;
  final String github;
  final String portfolio;

  CvHeaderInfo({
    required this.name,
    required this.title,
    required this.email,
    required this.phone,
    required this.location,
    required this.linkedin,
    required this.github,
    required this.portfolio,
  });

  factory CvHeaderInfo.fromJson(Map<String, dynamic> json) {
    final contact = json['contact'] ?? {};
    return CvHeaderInfo(
      name: json['name'] ?? "",
      title: json['title'] ?? "",
      email: contact['email'] ?? "",
      phone: contact['phone'] ?? "",
      location: contact['location'] ?? "",
      linkedin: contact['linkedin'] ?? "",
      github: contact['github'] ?? "",
      portfolio: contact['portfolio'] ?? "",
    );
  }
}

class CvSkillsInfo {
  final List<String> all;
  final List<String> technical;
  final List<String> tools;
  final List<String> languages;
  final List<String> softSkills;

  CvSkillsInfo({
    required this.all,
    required this.technical,
    required this.tools,
    required this.languages,
    required this.softSkills,
  });

  factory CvSkillsInfo.fromJson(Map<String, dynamic> json) {
    return CvSkillsInfo(
      all: List<String>.from(json['all'] ?? []),
      technical: List<String>.from(json['technical'] ?? []),
      tools: List<String>.from(json['tools'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      softSkills: List<String>.from(json['soft_skills'] ?? []),
    );
  }
}

class CvExperienceInfo {
  final String title;
  final String company;
  final String startDate;
  final String endDate;
  final bool current;
  final List<String> highlights;
  final List<String> technologies;

  CvExperienceInfo({
    required this.title,
    required this.company,
    required this.startDate,
    required this.endDate,
    required this.current,
    required this.highlights,
    required this.technologies,
  });

  factory CvExperienceInfo.fromJson(Map<String, dynamic> json) {
    // technologies ممكن تجي كـ Map ({"0": "Redis", "1": "PHP"}) أو كـ List
    List<String> techList = [];
    final rawTech = json['technologies'];
    if (rawTech is Map) {
      techList = rawTech.values.map((e) => e.toString()).toList();
    } else if (rawTech is List) {
      techList = rawTech.map((e) => e.toString()).toList();
    }

    return CvExperienceInfo(
      title: json['title'] ?? "",
      company: json['company'] ?? "",
      startDate: json['start_date'] ?? "",
      endDate: json['end_date'] ?? "",
      current: json['current'] ?? false,
      highlights: List<String>.from(json['highlights'] ?? []),
      technologies: techList,
    );
  }
}

class CvEducationInfo {
  final String institution;
  final String degree;
  final String fieldOfStudy;
  final String startDate;
  final String endDate;
  final num? grade;

  CvEducationInfo({
    required this.institution,
    required this.degree,
    required this.fieldOfStudy,
    required this.startDate,
    required this.endDate,
    this.grade,
  });

  factory CvEducationInfo.fromJson(Map<String, dynamic> json) {
    return CvEducationInfo(
      institution: json['institution'] ?? "",
      degree: json['degree'] ?? "",
      fieldOfStudy: json['field_of_study'] ?? "",
      startDate: json['start_date'] ?? "",
      endDate: json['end_date'] ?? "",
      grade: json['grade'],
    );
  }
}

class CvProjectInfo {
  final String title;
  final String description;
  final String link;
  final List<String> technologies;

  CvProjectInfo({
    required this.title,
    required this.description,
    required this.link,
    required this.technologies,
  });

  factory CvProjectInfo.fromJson(Map<String, dynamic> json) {
    return CvProjectInfo(
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      link: json['link'] ?? "",
      technologies: List<String>.from(json['technologies'] ?? []),
    );
  }
}

class CvCertificationInfo {
  final String name;
  final String issuer;
  final String issuedAt;
  final String expiresAt;
  final String credentialId;

  CvCertificationInfo({
    required this.name,
    required this.issuer,
    required this.issuedAt,
    required this.expiresAt,
    required this.credentialId,
  });

  factory CvCertificationInfo.fromJson(Map<String, dynamic> json) {
    return CvCertificationInfo(
      name: json['name'] ?? "",
      issuer: json['issuer'] ?? "",
      issuedAt: json['issued_at'] ?? "",
      expiresAt: json['expires_at'] ?? "",
      credentialId: json['credential_id'] ?? "",
    );
  }
}

class CvTrainingInfo {
  final String title;
  final String provider;
  final String startDate;
  final String endDate;
  final bool isCompleted;
  final String description;
  final List<String> technologies;

  CvTrainingInfo({
    required this.title,
    required this.provider,
    required this.startDate,
    required this.endDate,
    required this.isCompleted,
    required this.description,
    required this.technologies,
  });

  factory CvTrainingInfo.fromJson(Map<String, dynamic> json) {
    return CvTrainingInfo(
      title: json['title'] ?? "",
      provider: json['provider'] ?? "",
      startDate: json['start_date'] ?? "",
      endDate: json['end_date'] ?? "",
      isCompleted: json['is_completed'] ?? false,
      description: json['description'] ?? "",
      technologies: List<String>.from(json['technologies'] ?? []),
    );
  }
}

class CvInterestInfo {
  final String name;
  final String category;
  final int level;
  final String description;

  CvInterestInfo({
    required this.name,
    required this.category,
    required this.level,
    required this.description,
  });

  factory CvInterestInfo.fromJson(Map<String, dynamic> json) {
    return CvInterestInfo(
      name: json['name'] ?? "",
      category: json['category'] ?? "",
      level: json['level'] ?? 0,
      description: json['description'] ?? "",
    );
  }
}