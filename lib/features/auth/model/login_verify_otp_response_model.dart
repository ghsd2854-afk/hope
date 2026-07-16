class LoginVerifyOtpResponseModel {

  final int status;
  final String message;
  final String token;
  final String name;
  final String email;

  LoginVerifyOtpResponseModel({
    required this.status,
    required this.message,
    required this.token,
    required this.name,
    required this.email,
  });

  factory LoginVerifyOtpResponseModel.fromJson(
      Map<String, dynamic> json) {

    return LoginVerifyOtpResponseModel(
      status: int.parse(
        json["status"].toString(),
      ),
      message: json["message"].toString(),
      token: json["token"].toString(),
      name: json["user"]["name"].toString(),
      email: json["user"]["email"].toString(),
    );
  }
}