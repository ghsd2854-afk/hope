import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';
import '../model/profile_model.dart';

class ProfileService {
  final Dio _dio = DioService().dio;
  final box = GetStorage();

  Future<ProfileModel> getProfile() async {
    final token = box.read("token");

    final response = await _dio.get(
      ApiConstants.viewProfile,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    return ProfileModel.fromJson(response.data);
  }

  Future<ProfileModel> createProfile({required FormData data}) async {
    final token = box.read("token");

    final response = await _dio.post(
      ApiConstants.createProfile,
      data: data,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "multipart/form-data",
        },
      ),
    );

    return ProfileModel.fromJson(response.data);
  }

  Future<ProfileModel> updateProfile({required FormData data}) async {
    final token = box.read("token");

    final response = await _dio.post(
      ApiConstants.updateProfile,
      data: data,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "multipart/form-data",
        },
      ),
    );

    return ProfileModel.fromJson(response.data);
  }

  Future<void> deleteProfile() async {
    final token = box.read("token");

    await _dio.delete(
      ApiConstants.deleteProfile,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}
