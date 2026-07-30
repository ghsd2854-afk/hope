class InterestModel {
  final int? id;
  final String? name;
  final String? category;
  final String? level;
  final String? description;

  InterestModel({
    this.id,
    this.name,
    this.category,
    this.level,
    this.description,
  });

  factory InterestModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return InterestModel(
      id: json["id"],
      name: json["name"],
      category: json["category"],
      level: json["level"]?.toString(),
      description: json["description"],
    );
  }
}