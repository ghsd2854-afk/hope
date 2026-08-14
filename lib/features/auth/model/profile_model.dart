class ProfileModel {
  final int? id;
  final String? fullName;
  final String? headline;
  final String? summary;
  final String? gender;
  final String? phone;
  final String? address;
  final String? birthDate;
  final String? country;
  final String? city;
  final String? linkedin;
  final String? github;
  final String? portfolio;
  final String? profileImage;
  final String? cvFile;

  ProfileModel({
    this.id,
    this.fullName,
    this.headline,
    this.summary,
    this.gender,
    this.phone,
    this.address,
    this.birthDate,
    this.country,
    this.city,
    this.linkedin,
    this.github,
    this.portfolio,
    this.profileImage,
    this.cvFile,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json["id"],
      fullName: json["full_name"],
      headline: json["headline"],
      summary: json["summary"],
      gender: json["gender"],
      phone: json["phone"],
      address: json["address"],
      birthDate: json["birth_date"],
      country: json["country"],
      city: json["city"],
      linkedin: json["linkedin"],
      github: json["github"],
      portfolio: json["portfolio"],
      profileImage: json["profile_image"],
      cvFile: json["cv_file"],
    );
  }
}
