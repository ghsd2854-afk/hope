class VerifyPasswordOtpResponseModel {

  final int status;
  final String message;

  VerifyPasswordOtpResponseModel({
    required this.status,
    required this.message,
  });

  factory VerifyPasswordOtpResponseModel.fromJson(
      Map<String, dynamic> json) {

    return VerifyPasswordOtpResponseModel(
      status: int.parse(
        json["status"].toString(),
      ),
      message: json["message"].toString(),
    );
  }
}