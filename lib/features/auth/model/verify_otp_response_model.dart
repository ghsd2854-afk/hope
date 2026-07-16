class VerifyOtpResponseModel {
  final int status;
  final String message;
  final String token;

  VerifyOtpResponseModel({
    required this.status,
    required this.message,
    required this.token,
  });

  factory VerifyOtpResponseModel.fromJson(
      Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      status: json['status'],
      message: json['message'],
      token: json['token'],
    );
  }
}