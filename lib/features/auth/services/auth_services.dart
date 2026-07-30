import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';

import 'package:hobe/features/auth/model/login_model.dart';
import 'package:hobe/features/auth/model/login_verify_otp_response_model.dart';
import 'package:hobe/features/auth/model/register_response_model.dart';
import 'package:hobe/features/auth/model/verify_otp_response_model.dart';
import 'package:hobe/features/auth/model/resend_otp_response_model.dart';
import 'package:hobe/features/auth/model/forgot_password_response_model.dart';
import 'package:hobe/features/auth/model/verify_password_otp_response_model.dart';
import 'package:hobe/features/auth/model/reset_password_response_model.dart';

class AuthService {
  final Dio _dio = DioService().dio;

  final box = GetStorage();
  

  // ================= REGISTER =================

  Future<RegisterResponseModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: FormData.fromMap({
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation":
              passwordConfirmation,
        }),
      );

      return RegisterResponseModel.fromJson(
        response.data,
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Registration failed",
      );
    }
  }

  // ================= REGISTER OTP =================

  Future<VerifyOtpResponseModel> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.verifyOtp,
        data: FormData.fromMap({
          "email": email,
          "otp": otp,
        }),
      );

      return VerifyOtpResponseModel.fromJson(
        response.data,
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "OTP verification failed",
      );
    }
  }

  // ================= LOGIN =================

  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: FormData.fromMap({
          "email": email,
          "password": password,
        }),
      );
print(response.data);
      return LoginResponseModel.fromJson(
        response.data,
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Login failed",
      );
    }
  }

  // ================= LOGIN OTP =================
Future<ResendOtpResponseModel> resendOtp({
  required String email,
}) async {
  try {
    final response = await _dio.post(
      ApiConstants.resendOtp,
      data: FormData.fromMap({
        "email": email,
      }),
    );

    return ResendOtpResponseModel.fromJson(response.data);

  } on DioException catch (e) {
    throw Exception(
      e.response?.data["message"] ??
          "Resend OTP failed",
    );
  }
}
  Future<LoginVerifyOtpResponseModel>
      verifyLoginOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.loginVerifyOtp,
        data: FormData.fromMap({
          "email": email,
          "otp": otp,
        }),
      );
print("LOGIN OTP RESPONSE => ${response.data}"); 
      return LoginVerifyOtpResponseModel
          .fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "OTP verification failed",
      );
    }
  }

  // ================= REQUEST PASSWORD OTP =================

  Future<ForgotPasswordResponseModel>
      requestPasswordOtp({
    required String email,
  }) async {
    try {
      final token = box.read("token");

      print("TOKEN => $token");

      final response = await _dio.post(
        ApiConstants.requestPasswordOtp,
        data: FormData.fromMap({
          "email": email,
        }),
        options: Options(
          headers: {
            "Authorization":
                "Bearer $token",
          },
        ),
      );

      return ForgotPasswordResponseModel
          .fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Request OTP failed",
      );
    }
  }// ================= VERIFY PASSWORD OTP =================

  Future<VerifyPasswordOtpResponseModel>
      verifyPasswordOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final token = box.read("token");

      final response = await _dio.post(
        ApiConstants.verifyPasswordOtp,
        data: FormData.fromMap({
          "email": email,
          "otp": otp,
        }),
        options: Options(
          headers: {
            "Authorization":
                "Bearer $token",
          },
        ),
      );

      return VerifyPasswordOtpResponseModel
          .fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "OTP verification failed",
      );
    }
  }




  Future<void> logout() async {
    final token = box.read("token");

    await _dio.post(
      ApiConstants.logout,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );
  }

  // ================= RESET PASSWORD =================

  Future<ResetPasswordResponseModel>
      resetPassword({
    required String email,
    required String new_password,
    required String new_password_confirmation,
  }) async {
    try {
      final token = box.read("token");

      final response = await _dio.post(
        ApiConstants.resetPassword,
        data: FormData.fromMap({
          "email": email,
          "new_password": new_password,
          "new_password_confirmation":
              new_password_confirmation,
        }),
        options: Options(
          headers: {
            "Authorization":
                "Bearer $token",
          },
        ),
      );

      return ResetPasswordResponseModel
          .fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Reset password failed",
      );
    }
  }
}