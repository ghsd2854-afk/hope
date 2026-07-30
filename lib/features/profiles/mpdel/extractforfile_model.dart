// lib/model/CvExtractModel.dart

class CvExtractModel {
  final CvHeaderModel header;
  final String summary;
  final CvSkillsModel skills;
  final List<CvExperienceModel> experience;
  final List<CvEducationModel> education;
  final List<CvProjectModel> projects;
  final List<CvCertificationModel> certifications;
  final int? fileRecordId;

  CvExtractModel({
    required this.header,
    required this.summary,
    required this.skills,
    required this.experience,
    required this.education,
    required this.projects,
    required this.certifications,
    this.fileRecordId,
  });

  factory CvExtractModel.fromJson(Map<String, dynamic> json) {
    return CvExtractModel(
      header: CvHeaderModel.fromJson(json['header'] ?? {}),
      summary: json['summary'] ?? "",
      skills: CvSkillsModel.fromJson(json['skills'] ?? {}),
      experience: (json['experience'] as List<dynamic>? ?? [])
          .map((e) => CvExperienceModel.fromJson(e))
          .toList(),
      education: (json['education'] as List<dynamic>? ?? [])
          .map((e) => CvEducationModel.fromJson(e))
          .toList(),
      projects: (json['projects'] as List<dynamic>? ?? [])
          .map((e) => CvProjectModel.fromJson(e))
          .toList(),
      certifications: (json['certifications'] as List<dynamic>? ?? [])
          .map((e) => CvCertificationModel.fromJson(e))
          .toList(),
      fileRecordId: json['_file_record_id'] ?? json['file_record_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "header": header.toJson(),
      "summary": summary,
      "skills": skills.toJson(),
      "experience": experience.map((e) => e.toJson()).toList(),
      "education": education.map((e) => e.toJson()).toList(),
      "projects": projects.map((e) => e.toJson()).toList(),
      "certifications": certifications.map((e) => e.toJson()).toList(),
      "_file_record_id": fileRecordId,
    };
  }
}

class CvHeaderModel {
  final String name;
  final String title;
  final CvContactModel contact;

  CvHeaderModel({
    required this.name,
    required this.title,
    required this.contact,
  });

  factory CvHeaderModel.fromJson(Map<String, dynamic> json) {
    return CvHeaderModel(
      name: json['name'] ?? "",
      title: json['title'] ?? "",
      contact: CvContactModel.fromJson(json['contact'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "title": title,
        "contact": contact.toJson(),
      };
}

class CvContactModel {
  final String email;
  final String phone;
  final String location;
  final String linkedin;
  final String github;

  CvContactModel({
    required this.email,
    required this.phone,
    required this.location,
    required this.linkedin,
    required this.github,
  });

  factory CvContactModel.fromJson(Map<String, dynamic> json) {
    return CvContactModel(
      email: json['email'] ?? "",
      phone: json['phone'] ?? "",
      location: json['location'] ?? "",
      linkedin: json['linkedin'] ?? "",
      github: json['github'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "phone": phone,
        "location": location,
        "linkedin": linkedin,
        "github": github,
      };
}

class CvSkillsModel {
  final List<String> all;
  final List<String> technical;
  final List<String> tools;
  final List<String> languages;
  final List<String> softSkills;

  CvSkillsModel({
    required this.all,
    required this.technical,
    required this.tools,
    required this.languages,
    required this.softSkills,
  });

  factory CvSkillsModel.fromJson(Map<String, dynamic> json) {
    return CvSkillsModel(
      all: List<String>.from(json['all'] ?? []),
      technical: List<String>.from(json['technical'] ?? []),
      tools: List<String>.from(json['tools'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      softSkills: List<String>.from(json['soft_skills'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        "all": all,
        "technical": technical,
        "tools": tools,
        "languages": languages,
        "soft_skills": softSkills,
      };
}

class CvExperienceModel {
  final String title;
  final String company;
  final String startDate;
  final String endDate;
  final List<String> highlights;

  CvExperienceModel({
    required this.title,
    required this.company,
    required this.startDate,
    required this.endDate,
    required this.highlights,
  });

  factory CvExperienceModel.fromJson(Map<String, dynamic> json) {
    return CvExperienceModel(
      title: json['title'] ?? "",
      company: json['company'] ?? "",
      startDate: json['start_date'] ?? "",
      endDate: json['end_date'] ?? "",
      highlights: List<String>.from(json['highlights'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "company": company,
        "start_date": startDate,
        "end_date": endDate,
        "highlights": highlights,
      };
}

class CvEducationModel {
  final String institution;
  final String degree;
  final String fieldOfStudy;
  final String startDate;
  final String endDate;

  CvEducationModel({
    required this.institution,
    required this.degree,
    required this.fieldOfStudy,
    required this.startDate,
    required this.endDate,
  });

  factory CvEducationModel.fromJson(Map<String, dynamic> json) {
    return CvEducationModel(
      institution: json['institution'] ?? "",
      degree: json['degree'] ?? "",
      fieldOfStudy: json['field_of_study'] ?? "",
      startDate: json['start_date'] ?? "",
      endDate: json['end_date'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "institution": institution,
        "degree": degree,
        "field_of_study": fieldOfStudy,
        "start_date": startDate,
        "end_date": endDate,
      };
}

class CvProjectModel {
  final String title;
  final String description;
  final List<String> technologies;

  CvProjectModel({
    required this.title,
    required this.description,
    required this.technologies,
  });

  factory CvProjectModel.fromJson(Map<String, dynamic> json) {
    return CvProjectModel(
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      technologies: List<String>.from(json['technologies'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "technologies": technologies,
      };
}

class CvCertificationModel {
  final String name;
  final String issuer;

  CvCertificationModel({
    required this.name,
    required this.issuer,
  });

  factory CvCertificationModel.fromJson(Map<String, dynamic> json) {
    return CvCertificationModel(
      name: json['name'] ?? "",
      issuer: json['issuer'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "issuer": issuer,
      };
}