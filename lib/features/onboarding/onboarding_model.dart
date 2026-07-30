/// يمثل الـ object "onboarding" الجوا الرد
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

/// يمثل الرد الكامل لـ GET /api/onboarding
class OnboardingStatusModel {
  final OnboardingEntity onboarding;
  final Map<String, String> steps; // {"1": "profile", "2": "experiences", ...}
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
    final data = json['data'] ?? json; // لتغطية شكل GET وشكل POST سوا
    return OnboardingStatusModel(
      onboarding: OnboardingEntity.fromJson(data['onboarding'] ?? {}),
      steps: Map<String, String>.from(data['steps'] ?? {}),
      progressPercentage:
          (data['progress_percentage'] ?? 0).toDouble(),
      isCompleted: data['is_completed'],
      isSkipped: data['is_skipped'],
      currentStep: data['current_step'] ?? 1,
      nextStep: data['next_step']?.toString(),
    );
  }

  /// اسم الخطوة الحالية (profile / experiences / skills / education / cv_file / preferences)
  String get currentStepKey => steps[currentStep.toString()] ?? '';
}

/// موديل مبسّط للرد يلي بيرجع بعد ما تكمل خطوة
/// (POST /api/onboarding/step/{step}/complete)
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