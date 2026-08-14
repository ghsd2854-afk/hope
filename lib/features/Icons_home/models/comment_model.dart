import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hobe/features/Icons_home/models/ReactionModel.dart';

class CommentModel {
  int id;

  String content;

  int userId;

  String? userName;

  int jobPostId;

  RxInt reactionsCount;

  RxInt repliesCount;

  int? parentId;

  List<CommentModel> replies = [];

  RxBool isExpanded = false.obs;
  RxnString userReactionType;

  RxBool isReacted;

  RxList<ReactionModel> reactions = <ReactionModel>[].obs;

  CommentModel({
    required this.id,

    required this.content,

    required this.userId,

    this.userName,

    required this.jobPostId,

    required int reactionsCount,

    required int repliesCount,

    this.parentId,

    this.replies = const [],

    String? userReactionType,

    required bool isReacted,
  }) : this.reactionsCount = reactionsCount.obs,

       this.repliesCount = repliesCount.obs,

       this.userReactionType = RxnString(userReactionType),

       this.isReacted = isReacted.obs,
       this.isExpanded = false.obs;

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> reactionsList = json['reactions'] ?? [];

    final box = GetStorage();
    // التصحيح هنا ليكون متوافقاً مع ما نخزنه من البروفايل العام
    int currentUserId = box.read("current_user_id") ?? 0;

    var myReaction = reactionsList.firstWhere(
      (r) => r['user_id'] == currentUserId,
      orElse: () => null,
    );

    return CommentModel(
      id: json['id'],
      content: json['content'] ?? "",
      userId: json['user_id'] ?? 0,
      userName: json['user'] != null ? json['user']['name'] : "مستخدم",
      jobPostId: json['job_post_id'],
      reactionsCount: json['reactions_count'] ?? 0,
      repliesCount: json['replies_count'] ?? 0,
      parentId: json['parent_id'],
      replies: json['replies'] != null
          ? (json['replies'] as List)
                .map((i) => CommentModel.fromJson(i))
                .toList()
          : [],
      userReactionType: myReaction != null
          ? myReaction['type'].toString()
          : null,
      isReacted: myReaction != null,
    );
  }
  /*factory CommentModel.fromJson(Map<String, dynamic> json) {
    // 1. تعريف مصفوفة التفاعلات
    List<dynamic> reactionsList = json['reactions'] ?? [];

    // 2. حساب تفاعل المستخدم الحالي (استبدل 6 بالـ ID الخاص بك)
    // int currentUserId = 6;
    final box = GetStorage();
    int currentUserId = box.read("user_id") ?? 0;
    var myReaction = reactionsList.firstWhere(
      (r) => r['user_id'] == currentUserId,
      orElse: () => null,
    );

    // 3. الآن استخدم المتغير myReaction في الـ return
    return CommentModel(
      id: json['id'],
      content: json['content'] ?? "",
      userId: json['user_id'] ?? 0,
      userName: json['user'] != null ? json['user']['name'] : "مستخدم",
      jobPostId: json['job_post_id'],
      reactionsCount: json['reactions_count'] ?? 0,
      repliesCount: json['replies_count'] ?? 0,
      parentId: json['parent_id'],
      replies: json['replies'] != null
          ? (json['replies'] as List)
                .map((i) => CommentModel.fromJson(i))
                .toList()
          : [],
      // نستخدم المتغير الذي عرفناه قبل الـ return
      userReactionType: myReaction != null
          ? myReaction['type'].toString()
          : null,
      isReacted: myReaction != null,
    );
  }*/
}
