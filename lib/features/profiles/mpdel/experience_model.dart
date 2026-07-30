class ExperienceModel {
  final int? id;
  final String? company;
  final String? position;
  final String? startDate;
  final String? endDate;
  final bool? isCurrent;
  final String? description;
  final List<String>? technologiesUsed;

  ExperienceModel({
    this.id,
    this.company,
    this.position,
    this.startDate,
    this.endDate,
    this.isCurrent,
    this.description,
    this.technologiesUsed,
  });

factory ExperienceModel.fromJson(
  Map<String, dynamic> json,
) {

  List<String> techs = [];

  if (json["technologies_used"] != null) {

    if (json["technologies_used"] is Map) {

      techs = (json["technologies_used"] as Map)
          .values
          .map((e) => e.toString())
          .toList();

    } else if (json["technologies_used"] is List) {

      techs = (json["technologies_used"] as List)
          .map((e) => e.toString())
          .toList();
    }
  }

  return ExperienceModel(
    id: json["id"],
    company: json["company"],
    position: json["position"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    isCurrent: json["is_current"],
    description: json["description"],
    technologiesUsed: techs,
  );
}
}