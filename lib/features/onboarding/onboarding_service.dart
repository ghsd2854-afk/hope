import 'dart:convert';
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/onboarding/onboarding_model.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';


/// عدّل الـ import تبع GetStorage / SharedPreferences حسب طريقة تخزين
/// التوكن عندك بالمشروع (نفس الطريقة يلي عم تستخدمها بباقي الـ Services)
class OnboardingService {
  final GetStorage _box = GetStorage();

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${_box.read('token') ?? ''}',
      };

  /// GET /api/onboarding -> جلب حالة الـ Onboarding الحالية
  Future<OnboardingStatusModel> getStatus() async {
    final response = await http.get(
      Uri.parse(ApiConstants.onboardingStatus),
      headers: _headers,
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['status'] == 'success') {
      return OnboardingStatusModel.fromJson(body);
    } else {
      throw Exception(body['message'] ?? 'فشل جلب حالة الـ Onboarding');
    }
  }

  /// POST /api/onboarding/step/{step}/complete -> إكمال خطوة معينة
  Future<OnboardingStepCompleteResponse> completeStep(int step) async {
    final response = await http.post(
      Uri.parse(ApiConstants.onboardingCompleteStep(step)),
      headers: _headers,
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['status'] == 'success') {
      return OnboardingStepCompleteResponse.fromJson(body);
    } else {
      throw Exception(body['message'] ?? 'فشل إكمال الخطوة');
    }
  }

  /// POST /api/onboarding/skip -> تخطي كامل الـ Onboarding
  Future<void> skip() async {
    final response = await http.post(
      Uri.parse(ApiConstants.onboardingSkip),
      headers: _headers,
    );

    final body = jsonDecode(response.body);

    if (!(response.statusCode == 200 && body['status'] == 'success')) {
      throw Exception(body['message'] ?? 'فشل تخطي الـ Onboarding');
    }
  }

  /// POST /api/onboarding/restart -> إعادة تشغيل الـ Onboarding
  Future<void> restart() async {
    final response = await http.post(
      Uri.parse(ApiConstants.onboardingRestart),
      headers: _headers,
    );

    final body = jsonDecode(response.body);

    if (!(response.statusCode == 200 && body['status'] == 'success')) {
      throw Exception(body['message'] ?? 'فشل إعادة تشغيل الـ Onboarding');
    }
  }
}