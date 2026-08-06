class JobCriteria {
  final String? location;
  final int? salaryMin;
  final int? salaryMax;
  final bool? remote;
  final List<String>? keywords;
  final List<String>? jobType;
  final List<int>? categories;

  JobCriteria({
    this.location,
    this.salaryMin,
    this.salaryMax,
    this.remote,
    this.keywords,
    this.jobType,
    this.categories,
  });

  Map<String, dynamic> toJson() {
    return {
      if (location != null) 'location': location,
      if (salaryMin != null) 'salary_min': salaryMin,
      if (salaryMax != null) 'salary_max': salaryMax,
      if (remote != null) 'remote': remote,
      if (keywords != null && keywords!.isNotEmpty) 'keywords': keywords,
      if (jobType != null && jobType!.isNotEmpty) 'job_type': jobType,
      if (categories != null && categories!.isNotEmpty)
        'categories': categories,
    };
  }
}

class JobAlertModel {
  final int? id;
  final String name;
  final String frequency; // مثلاً: daily, weekly
  final bool notifyEmail;
  final bool notifyPush;
  final bool notifySms; // <-- أضفناه هنا
  bool isActive; // مسموح بتعديلها محلياً
  final JobCriteria criteria;

  JobAlertModel({
    this.id,
    required this.name,
    required this.frequency,
    required this.notifyEmail,
    required this.notifyPush,
    required this.notifySms, // <-- إضافته في الـ Constructor
    required this.isActive,
    required this.criteria,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'frequency': frequency,
      'notify_email': notifyEmail,
      'notify_push': notifyPush,
      'notify_sms': notifySms, // <-- إضافته في الـ toJson لإرساله للسيرفر
      'is_active': isActive,
      'criteria': criteria.toJson(),
    };
  }

  factory JobAlertModel.fromJson(Map<String, dynamic> json) {
    return JobAlertModel(
      id: json['id'],
      name: json['name'] ?? '',
      frequency: json['frequency'] ?? 'daily',
      notifyEmail: json['notify_email'] ?? true,
      notifyPush: json['notify_push'] ?? true,
      notifySms:
          json['notify_sms'] ??
          false, // <-- قراءته من الـ API (قيمة افتراضية false)
      isActive: json['is_active'] ?? true,
      criteria: JobCriteria(
        location: json['criteria']?['location'],
        salaryMin: json['criteria']?['salary_min'],
        salaryMax: json['criteria']?['salary_max'],
        remote: json['criteria']?['remote'],
        keywords: json['criteria']?['keywords'] != null
            ? List<String>.from(json['criteria']['keywords'])
            : [],
        jobType: json['criteria']?['job_type'] != null
            ? List<String>.from(json['criteria']['job_type'])
            : [],
        categories: json['criteria']?['categories'] != null
            ? List<int>.from(json['criteria']['categories'])
            : [],
      ),
    );
  }
}
