// lib/data/services/account_service.dart
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:http/http.dart' as http;

class AccountService {
  final _storage = GetStorage();

  Map<String, String> get _authHeaders => {
        'Authorization': 'Bearer ${_storage.read('token')}',
      };

  /// خطوة 1: طلب حذف الحساب -> بيبعت OTP عالإيميل
  Future<Map<String, dynamic>> deleteAccountRequest() async {
    final response = await http.post(
      Uri.parse(ApiConstants.deleteAccountRequest),
      headers: _authHeaders,
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return {'success': true, 'message': body['message']};
    }
    return {'success': false, 'message': body['message'] ?? 'حدث خطأ'};
  }

  /// خطوة 2: تأكيد الحذف بالـ OTP
  Future<Map<String, dynamic>> deleteAccountConfirm({
    required String email,
    required String otp,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConstants.deleteAccountConfirm),
    );
    request.headers.addAll(_authHeaders);
    request.fields['email'] = email;
    request.fields['otp'] = otp;

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'message': body['message']};
    }
    return {'success': false, 'message': body['message'] ?? 'حدث خطأ'};
  }
}