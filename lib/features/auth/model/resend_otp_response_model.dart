class ResendOtpResponseModel {
  final int status;
  final String message;
  final String expiresIn;

  ResendOtpResponseModel({
    required this.status,
    required this.message,
    required this.expiresIn,
  });

  factory ResendOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return ResendOtpResponseModel(
      status: json["status"],
      message: json["message"],
      expiresIn: json["expires_in"],
    );
  }
}