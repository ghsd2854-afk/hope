import 'package:dio/dio.dart';

import 'package:hobe/features/APIS/api_constants.dart';

import 'package:get_storage/get_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioService {
  static final DioService _instance = DioService._internal();

  factory DioService() => _instance;

  late Dio dio;

  DioService._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,

        connectTimeout: const Duration(seconds: 30),

        receiveTimeout: const Duration(seconds: 30),

        headers: {"Accept": "application/json"},
      ),
    );

    // 2. إضافة الـ Logger إلى قائمة الـ Interceptors

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,

        requestBody: true,

        responseBody: true,

        responseHeader: false,

        error: true,

        compact: true,

        maxWidth: 90,
      ),
    );

    // 🌟 إضافة Interceptor لحقن الـ Token تلقائياً في كل الطلبات

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // جلب التوكن المحفوظ في ذاكرة الهاتف (تأكدي من الاسم المفتاحي 'token' لديكِ)

          final box = GetStorage();

          final token = box.read('token');

          if (token != null) {
            // إضافة التوكن للـ Headers لحل مشكلة Unauthenticated

            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options);
        },
      ),
    );
  }
}
