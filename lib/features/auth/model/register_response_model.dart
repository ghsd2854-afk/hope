class RegisterResponseModel {
  final int status;
  final String message;
  final String expiresIn;

  RegisterResponseModel({
    required this.status,
    required this.message,
    required this.expiresIn,
  });

  factory RegisterResponseModel.fromJson(
      Map<String, dynamic> json) {
    return RegisterResponseModel(
      status: json['status'],
      message: json['message'],
      expiresIn: json['expires_in'],
    );
  }
}