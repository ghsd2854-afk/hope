class ProjectModel {
  final int? id;
  final String? title;
  final String? description;
  final String? link;
  final List<String>? technologies;

  ProjectModel({
    this.id,
    this.title,
    this.description,
    this.link,
    this.technologies,
  });

  factory ProjectModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProjectModel(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      link: json["link"],
      technologies:
          json["technologies"] == null
              ? []
              : List<String>.from(
                  json["technologies"],
                ),
    );
  }
}