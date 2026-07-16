class ReactionModel {
  final int id;
  final int userId;
  final int jobPostId;
  final String type;
  final String name;
  ReactionModel({
    required this.id,
    required this.userId,
    required this.jobPostId,
    required this.type,
    required this.name,
  });

  factory ReactionModel.fromJson(Map<String, dynamic> json) {
    return ReactionModel(
      id: (json['id'] ?? 0) as int,
      userId: (json['user_id'] ?? 0) as int,
      jobPostId: (json['job_post_id'] ?? 0) as int,
      type: json['type']?.toString().toLowerCase() ?? '',
      name: json['name']?.toString() ?? 'Unknown',
    );
  }
}

class ViewAllResponse {
  final int total;
  final Map<String, dynamic> counts;
  final List<ReactionModel> users;

  ViewAllResponse({
    required this.total,
    required this.counts,
    required this.users,
  });

  factory ViewAllResponse.fromJson(Map<String, dynamic> json) {
    return ViewAllResponse(
      total: (json['total'] ?? 0) as int,

      counts: (json['counts'] as Map<String, dynamic>?) ?? {},

      users:
          (json['users'] as List?)
              ?.map((i) => ReactionModel.fromJson(i))
              .toList() ??
          [],
    );
  }
}

class StatsResponse {
  final int total;
  final Map<String, ReactionGroup> reactions;

  StatsResponse({required this.total, required this.reactions});

  factory StatsResponse.fromJson(Map<String, dynamic> json) {
    int total = (json['total'] ?? 0) as int;

    var reactionsMap = json['reactions'] as Map<String, dynamic>? ?? {};

    Map<String, ReactionGroup> parsedReactions = {};

    reactionsMap.forEach((key, value) {
      if (value != null) {
        parsedReactions[key] = ReactionGroup.fromJson(value);
      }
    });

    return StatsResponse(total: total, reactions: parsedReactions);
  }
}

class ReactionGroup {
  final int count;
  final List<ReactionModel> users;

  ReactionGroup({required this.count, required this.users});

  factory ReactionGroup.fromJson(Map<String, dynamic> json) {
    return ReactionGroup(
      count: (json['count'] ?? 0) as int,

      users:
          (json['users'] as List?)
              ?.map((i) => ReactionModel.fromJson(i))
              .toList() ??
          [],
    );
  }
}
