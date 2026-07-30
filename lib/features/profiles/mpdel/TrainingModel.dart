class TrainingModel {

  final int? id;
  final String? title;
  final String? provider;
  final String? startDate;
  final String? endDate;
  final int? isCompleted;
  final String? description;

  TrainingModel({
    this.id,
    this.title,
    this.provider,
    this.startDate,
    this.endDate,
    this.isCompleted,
    this.description,
  });

 factory TrainingModel.fromJson(
    Map<String, dynamic> json,
) {
  return TrainingModel(
    id: json["id"],
    title: json["title"],
    provider: json["provider"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    isCompleted: int.tryParse(
      json["is_completed"].toString(),
    ),
    description: json["description"],
  );
}
}