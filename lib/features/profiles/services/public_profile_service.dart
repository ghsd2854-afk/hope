import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';
import 'package:hobe/features/profiles/mpdel/profile_completion_model.dart';
import 'package:hobe/features/profiles/mpdel/public_profile_model.dart';
import 'package:hobe/features/profiles/mpdel/public_profile_view_model.dart';

class PublicProfileService {
  final Dio _dio = DioService().dio;
  final box = GetStorage();

  Map<String, String> get _headers => {
        "Authorization": "Bearer ${box.read("token")}",
      };

  Future<ProfileCompletionModel> getCompletion() async {
    final response = await _dio.get(
      ApiConstants.profileCompletion,
      options: Options(headers: _headers),
    );
    return ProfileCompletionModel.fromJson(response.data["data"]);
  }

  Future<ProfileCompletionModel> recalculateCompletion() async {
    await _dio.post(
      ApiConstants.recalculateCompletion,
      options: Options(headers: _headers),
    );
    return getCompletion();
  }

  Future<PublicProfileModel> getPublicSettings() async {
    final response = await _dio.get(
      ApiConstants.publicProfileSettings,
      options: Options(headers: _headers),
    );
    return PublicProfileModel.fromJson(
      response.data["data"]["public_profile"],
    );
  }

  Future<PublicProfileModel> updatePublicSettings({
    required Map<String, dynamic> data,
  }) async {
    final response = await _dio.post(
      ApiConstants.publicProfileSettings,
      data: data,
      options: Options(headers: _headers),
    );
    return PublicProfileModel.fromJson(response.data["data"]);
  }

  Future<Map<String, dynamic>> changeSlug({required String slug}) async {
    final formData = FormData.fromMap({"slug": slug});
    final response = await _dio.post(
      ApiConstants.changeSlug,
      data: formData,
      options: Options(headers: _headers),
    );
    return response.data;
  }

  Future<PublicProfileViewModel> viewPublicProfile({
    required String slug,
  }) async {
    final response = await _dio.get(
      "${ApiConstants.viewPublicProfile}$slug",
    );
    return PublicProfileViewModel.fromJson(response.data["data"]);
  }
}