class PostModel {
  int id;
  String title;
  String desc;

  bool isLiked;
  bool isSaved;

  PostModel({
    required this.id,
    required this.title,
    required this.desc,
    this.isLiked = false,
    this.isSaved = false,
  });
}
