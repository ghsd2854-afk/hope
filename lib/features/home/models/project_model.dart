class ProjectModel {
  String? title;
  String? summary;
  String? description;
  String? stage;
  List<String>? supportTypes;
  String? category;
  dynamic fundingGoal;
  String? location;
  String? websiteUrl;

  ProjectModel({
    this.title,
    this.summary,
    this.description,
    this.stage,
    this.supportTypes,
    this.category,
    this.fundingGoal,
    this.location,
    this.websiteUrl,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['summary'] = this.summary;
    data['description'] = this.description;
    data['stage'] = this.stage;
    if (this.supportTypes != null) {
      // إرسال المصفوفة بالشكل الذي يتوقعه الباك إند (Laravel form-data array format)
      for (int i = 0; i < this.supportTypes!.length; i++) {
        data['support_types[$i]'] = this.supportTypes![i];
      }
    }
    data['category'] = this.category;
    data['funding_goal'] = this.fundingGoal;
    data['location'] = this.location;
    data['website_url'] = this.websiteUrl;
    return data;
  }
}
