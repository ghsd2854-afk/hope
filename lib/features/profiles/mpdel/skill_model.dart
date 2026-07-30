


class SkillModel {
  final int? id;
  final String? name;
  final String? type;
  final String? level;
  final String? yearsExperience;

  SkillModel({
    this.id,
    this.name,
    this.type,
    this.level,
    this.yearsExperience,
  });

  factory SkillModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SkillModel(
      id: json["id"],
      name: json["name"],
      type: json["type"],
      level: json["level"],
      yearsExperience:
          json["years_experience"]?.toString(),
    );
  }
}
