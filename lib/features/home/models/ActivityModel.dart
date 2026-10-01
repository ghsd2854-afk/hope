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
    int postId = json['job_post_id'] ?? 0;

    String contentTitle = '';
    String contentDesc = '';
    String type = json['type'] ?? '';

    if (type == 'reaction') {
      contentTitle = "تفاعل";
      var meta = json['meta'];
      if (meta is Map && meta.containsKey('type')) {
        contentDesc = meta['type'].toString();
      } else {
        contentDesc = 'love';
      }
    } else if (type == 'comment') {
      contentTitle = "تعليق";
      var meta = json['meta'];
      if (meta is Map && meta.containsKey('content')) {
        contentDesc = meta['content'].toString();
      } else {
        contentDesc = json['comment']?.toString() ?? '';
      }
    } else {
      contentTitle = json['job_post']?['title']?.toString() ?? 'نشاط جديد';
      contentDesc = json['description']?.toString() ?? '';
    }

    return ActivityModel(
      jobPostId: postId,
      title: contentTitle,
      desc: contentDesc,
      date: json['created_at']?.toString() ?? '',
    );
  }
}
