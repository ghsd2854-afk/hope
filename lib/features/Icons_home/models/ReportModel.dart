class ReportModel {
  final String reportableType;
  final int reportableId;
  final String reason;
  final String details;

  ReportModel({
    required this.reportableType,
    required this.reportableId,
    required this.reason,
    required this.details,
  });

  Map<String, dynamic> toJson() {
    return {
      "reportable_type": reportableType,
      "reportable_id": reportableId,
      "reason": reason,
      "details": details,
    };
  }
}
