class LoginResponseModel {

  final int status;
  final String message;

  LoginResponseModel({
    required this.status,
    required this.message,
  });

  factory LoginResponseModel.fromJson(
      Map<String, dynamic> json) {

    return LoginResponseModel(
      status: int.parse(
        json["status"].toString(),
      ),
      message: json["message"].toString(),
    );
  }
}