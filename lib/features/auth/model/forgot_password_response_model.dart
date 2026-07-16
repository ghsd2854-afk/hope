class ForgotPasswordResponseModel {

  final int status;
  final String message;
  final String expiresIn;

  ForgotPasswordResponseModel({
    required this.status,
    required this.message,
    required this.expiresIn,
  });

  factory ForgotPasswordResponseModel.fromJson(
      Map<String, dynamic> json) {

    return ForgotPasswordResponseModel(
      status: int.parse(
        json["status"].toString(),
      ),
      message: json["message"].toString(),
      expiresIn:
          json["expires_in"].toString(),
    );
  }
}