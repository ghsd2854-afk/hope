class ResetPasswordResponseModel {

  final int status;
  final String message;

  ResetPasswordResponseModel({
    required this.status,
    required this.message,
  });

  factory ResetPasswordResponseModel.fromJson(
      Map<String, dynamic> json) {

    return ResetPasswordResponseModel(
      status: int.parse(
        json["status"].toString(),
      ),
      message: json["message"].toString(),
    );
  }
}