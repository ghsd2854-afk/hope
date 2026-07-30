import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hobe/features/APIS/api_constants.dart';
import 'package:http/http.dart' as http;



/// =======================================================
/// Models
/// =======================================================

class OnboardingEntity {
  final int userId;
  final String userType;
  final int currentStep;
  final int totalSteps;
  final List<int> completedSteps;
  final DateTime updatedAt;
  final DateTime createdAt;
  final int id;

  OnboardingEntity({
    required this.userId,
    required this.userType,
    required this.currentStep,
    required this.totalSteps,
    required this.completedSteps,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory OnboardingEntity.fromJson(Map<String, dynamic> json) {
    return OnboardingEntity(
      userId: json['user_id'] ?? 0,
      userType: json['user_type'] ?? '',
      currentStep: json['current_step'] ?? 1,
      totalSteps: json['total_steps'] ?? 6,
      completedSteps: (json['completed_steps'] as List<dynamic>? ?? [])
          .map((e) => e as int)
          .toList(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      id: json['id'] ?? 0,
    );
  }
}

class OnboardingStatusModel {
  final OnboardingEntity onboarding;
  final Map<String, String> steps;
  final double progressPercentage;
  final bool? isCompleted;
  final bool? isSkipped;
  final int currentStep;
  final String? nextStep;

  OnboardingStatusModel({
    required this.onboarding,
    required this.steps,
    required this.progressPercentage,
    required this.isCompleted,
    required this.isSkipped,
    required this.currentStep,
    required this.nextStep,
  });

  factory OnboardingStatusModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return OnboardingStatusModel(
      onboarding: OnboardingEntity.fromJson(data['onboarding'] ?? {}),
      steps: Map<String, String>.from(data['steps'] ?? {}),
      progressPercentage: (data['progress_percentage'] ?? 0).toDouble(),
      isCompleted: data['is_completed'],
      isSkipped: data['is_skipped'],
      currentStep: data['current_step'] ?? 1,
      nextStep: data['next_step']?.toString(),
    );
  }
}

class OnboardingStepCompleteResponse {
  final String status;
  final String message;
  final double progressPercentage;
  final bool isCompleted;
  final int? nextStep;

  OnboardingStepCompleteResponse({
    required this.status,
    required this.message,
    required this.progressPercentage,
    required this.isCompleted,
    required this.nextStep,
  });

  factory OnboardingStepCompleteResponse.fromJson(Map<String, dynamic> json) {
    return OnboardingStepCompleteResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      progressPercentage: (json['progress_percentage'] ?? 0).toDouble(),
      isCompleted: json['is_completed'] ?? false,
      nextStep: json['next_step'],
    );
  }
}

/// =======================================================
/// Service
/// =======================================================

class OnboardingService {
  final GetStorage _box = GetStorage();

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${_box.read('token') ?? ''}',
      };

  Future<OnboardingStatusModel> getStatus() async {
    final response = await http.get(
      Uri.parse(ApiConstants.onboardingStatus),
      headers: _headers,
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 && body['status'] == 'success') {
      return OnboardingStatusModel.fromJson(body);
    }
    throw Exception(body['message'] ?? 'فشل جلب حالة الـ Onboarding');
  }

  Future<OnboardingStepCompleteResponse> completeStep(int step) async {
    final response = await http.post(
      Uri.parse(ApiConstants.onboardingCompleteStep(step)),
      headers: _headers,
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 && body['status'] == 'success') {
      return OnboardingStepCompleteResponse.fromJson(body);
    }
    throw Exception(body['message'] ?? 'فشل إكمال الخطوة');
  }

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

/// =======================================================
/// Controller
/// =======================================================

class OnboardingStepGroup {
  final int apiStep;
  final String key;
  final int pageCount;

  const OnboardingStepGroup({
    required this.apiStep,
    required this.key,
    required this.pageCount,
  });
}

class OnboardingController extends GetxController {
  final OnboardingService _service = OnboardingService();

  final Rx<OnboardingStatusModel?> status = Rx<OnboardingStatusModel?>(null);
  final RxBool isLoading = false.obs;
  final RxInt currentPageIndex = 0.obs;

  final PageController pageController = PageController();

  final List<OnboardingStepGroup> stepGroups = const [
    OnboardingStepGroup(apiStep: 1, key: 'profile', pageCount: 1),
    OnboardingStepGroup(apiStep: 2, key: 'experiences', pageCount: 2),
    OnboardingStepGroup(apiStep: 3, key: 'skills', pageCount: 4),
    OnboardingStepGroup(apiStep: 4, key: 'education', pageCount: 1),
    OnboardingStepGroup(apiStep: 5, key: 'cv_file', pageCount: 1),
    OnboardingStepGroup(apiStep: 6, key: 'preferences', pageCount: 1),
  ];

  late final List<int> _pageToGroupIndex = _buildPageMap();

  List<int> _buildPageMap() {
    final List<int> map = [];
    for (int g = 0; g < stepGroups.length; g++) {
      map.addAll(List.filled(stepGroups[g].pageCount, g));
    }
    return map;
  }

  int get totalPages => _pageToGroupIndex.length;
  int get currentGroupIndex => _pageToGroupIndex[currentPageIndex.value];
  OnboardingStepGroup get currentGroup => stepGroups[currentGroupIndex];

  bool get isLastPageInCurrentGroup {
    final nextIndex = currentPageIndex.value + 1;
    return nextIndex >= totalPages ||
        _pageToGroupIndex[nextIndex] != currentGroupIndex;
  }

  int _firstPageIndexOfGroup(int groupIndex) {
    int pageIndex = 0;
    for (int i = 0; i < groupIndex; i++) {
      pageIndex += stepGroups[i].pageCount;
    }
    return pageIndex;
  }

  @override
  void onInit() {
    super.onInit();
    fetchStatus();
  }

  Future<void> fetchStatus() async {
    try {
      isLoading.value = true;
      final result = await _service.getStatus();
      status.value = result;

      if (result.isCompleted == true || result.isSkipped == true) {
        Get.offAllNamed('/home');
        return;
      }

      final groupIdx =
          stepGroups.indexWhere((g) => g.apiStep == result.currentStep);
      final safeGroupIdx = groupIdx == -1 ? 0 : groupIdx;
      final pageIndex = _firstPageIndexOfGroup(safeGroupIdx);
      currentPageIndex.value = pageIndex;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (pageController.hasClients) {
          pageController.jumpToPage(pageIndex);
        }
      });
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onSubStepSaved() async {
    if (!isLastPageInCurrentGroup) {
      _goToPageIndex(currentPageIndex.value + 1);
      return;
    }

    final step = currentGroup.apiStep;
    try {
      isLoading.value = true;
      final result = await _service.completeStep(step);

      if (result.isCompleted) {
        Get.offAllNamed('/home');
        Get.snackbar('تم', 'أنجزت كل خطوات الـ Onboarding 🎉');
        return;
      }

      final nextApiStep = result.nextStep ?? (step + 1);
      final nextGroupIdx =
          stepGroups.indexWhere((g) => g.apiStep == nextApiStep);
      final nextPageIndex =
          _firstPageIndexOfGroup(nextGroupIdx == -1 ? 0 : nextGroupIdx);

      _goToPageIndex(nextPageIndex);
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _goToPageIndex(int index) {
    currentPageIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void goToPreviousStep() {
    if (currentPageIndex.value > 0) {
      _goToPageIndex(currentPageIndex.value - 1);
    }
  }

  Future<void> skipOnboarding() async {
    try {
      isLoading.value = true;
      await _service.skip();
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> restartOnboarding() async {
    try {
      isLoading.value = true;
      await _service.restart();
      currentPageIndex.value = 0;
      await fetchStatus();
      if (pageController.hasClients) {
        pageController.jumpToPage(0);
      }
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}