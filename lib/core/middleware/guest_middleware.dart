import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hobe/app_routes.dart';



class GuestMiddleware extends GetMiddleware {

  final box = GetStorage();

  @override
  RouteSettings? redirect(String? route) {

    final token = box.read('token');

    if (token == null) {
      return const RouteSettings(
        name: AppRoutes.login,
      );
    }

    return null;
  }
}