class EducationModel {
  final int? id;
  final String? institution;
  final String? degree;
  final String? fieldOfStudy;
  final String? startDate;
  final String? endDate;
  final String? grade;

  EducationModel({
    this.id,
    this.institution,
    this.degree,
    this.fieldOfStudy,
    this.startDate,
    this.endDate,
    this.grade,
  });

  factory EducationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return EducationModel(
      id: json["id"],
      institution: json["institution"],
      degree: json["degree"],
      fieldOfStudy: json["field_of_study"],
      startDate: json["start_date"],
      endDate: json["end_date"],
      grade: json["grade"]?.toString(),
    );
  }
}