class ActivityModel {
  final int jobPostId;
  final String title;
  final String desc;
  final String date;

  ActivityModel({
    required this.jobPostId,
    required this.title,
    required this.desc,
    required this.date,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    int postId = json['job_post_id'] ?? json['id'] ?? 0;
    String contentTitle = '';
    String contentDesc = '';

    if (json.containsKey('comment')) {
      contentTitle = "تعليق";
      contentDesc = json['comment']?.toString() ?? '';
    } else if (json.containsKey('reaction')) {
      // هنا نجعل الوصف يحمل نوع التفاعل حصراً بدون ذكر الـ ID
      contentTitle = "تفاعل";
      contentDesc = json['reaction']?.toString() ?? 'إعجاب';
    } else {
      contentTitle =
          json['title']?.toString() ?? json['name']?.toString() ?? 'نشاط جديد';
      contentDesc =
          json['description']?.toString() ?? json['body']?.toString() ?? '';
    }

    return ActivityModel(
      jobPostId: postId,
      title: contentTitle,
      desc: contentDesc,
      date: json['created_at']?.toString() ?? '',
    );
  }
}
