class ApplicationResponse {
  final int? status;
  final ApplicationData? data;

  ApplicationResponse({this.status, this.data});

  factory ApplicationResponse.fromJson(Map<String, dynamic> json) {
    return ApplicationResponse(
      status: json['status'],
      data: json['data'] != null
          ? ApplicationData.fromJson(json['data'])
          : null,
    );
  }
}

class ApplicationData {
  final int? currentPage;
  final List<JobApplicationModel>? applications;

  ApplicationData({this.currentPage, this.applications});

  factory ApplicationData.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List? ?? [];
    List<JobApplicationModel> parsedApps = list
        .map((i) => JobApplicationModel.fromJson(i))
        .toList();

    return ApplicationData(
      currentPage: json['current_page'],
      applications: parsedApps,
    );
  }
}

class JobApplicationModel {
  final int? id;
  // أضيفي بقية الحقول هنا حسب استجابة الباك إند لديكِ

  JobApplicationModel({this.id});

  factory JobApplicationModel.fromJson(Map<String, dynamic> json) {
    return JobApplicationModel(id: json['id']);
  }
}
