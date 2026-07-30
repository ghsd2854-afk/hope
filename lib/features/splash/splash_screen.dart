import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:hobe/app_routes.dart';
import 'package:hobe/features/profiles/services/profile_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final box = GetStorage();
  final ProfileService _profileService = ProfileService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _decideRoute());
  }

Future<void> _decideRoute() async {
  final token = box.read("token");

  if (token == null || token.toString().trim().isEmpty) {
    Get.offAllNamed(AppRoutes.login);
    return;
  }

  try {
    await _profileService.getProfile();

    Get.offAllNamed(AppRoutes.home);

  } on DioException catch (e) {

    print("STATUS CODE: ${e.response?.statusCode}");
    print("DATA: ${e.response?.data}");

    if (e.response?.statusCode == 401) {

      // التوكن غير صالح
      await box.remove("token");
      await box.remove("name");
      await box.remove("email");

      Get.offAllNamed(AppRoutes.login);

    } else if (e.response?.statusCode == 404) {

      // المستخدم موجود لكن ما عنده بروفايل
      Get.offAllNamed(AppRoutes.profile);

    } else {

      Get.offAllNamed(AppRoutes.login);
    }

  } catch (e) {

    print(e);
    Get.offAllNamed(AppRoutes.login);

  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFDCCBFF),
              Color(0xFFF8F7FF),
            ],
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF7C3AED),
          ),
        ),
      ),
    );
  }
}