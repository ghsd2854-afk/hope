class ApiConstants {
  static const String baseUrl = "http://192.168.1.15:8000/api";
  static const String listJobs = "/jobs";
  static const String followUnfollow = "/companies/";
  static const String jobLike = "/posts/";
  static const String jobSave = "/saved-posts/toggle";
  static const String getCategories = "/categories";
  static const String createStartupProject = "/startup-projects";
  static String jobApply(int jobId) {
    return "/jobs/$jobId/apply";
  }

  static const String block = "/blocks"; // POST -> حظر / GET -> عرض القائمة
  static const String checkBlock = "/blocks/check"; // POST -> فحص هل محظور
  static String unblock(int blockId) => "/blocks/$blockId";
  static const String logout = "$baseUrl/logout";
  static const String register = "/register";
  static const String verifyOtp = "/verify-otp";

  static const String login = "/login";
  static const String loginVerifyOtp = "/login/verify-otp";

  static const String requestPasswordOtp = "/password/request-otp";

  static const String verifyPasswordOtp = "/password/verify-otp";

  static const String resetPassword = "/password/reset";
  static const String createProfile = "$baseUrl/profile";

  static const String viewProfile = "$baseUrl/profile";

  static const String updateProfile = "$baseUrl/profile/update";

  static const String deleteProfile = "$baseUrl/profile";
  static const String createSkill = "/skills";

  static const String getSkills = "/skills";

  static const String updateSkill = "/skills";

  static const String deleteSkill = "/skills";
  static const String createTraining = "/trainings";

  static const String getTrainings = "/trainings";

  static const String updateTraining = "/trainings";

  static const String deleteTraining = "/trainings";
  static const String createEducation = "/educations";

  static const String getEducations = "/educations";

  static const String updateEducation = "/educations";

  static const String deleteEducation = "/educations";

  static const String showEducation = "/educations";
  static const String createExperience = "/experiences";

  static const String getExperiences = "/experiences";

  static const String updateExperience = "/experiences";

  static const String deleteExperience = "/experiences";

  static const String showExperience = "/experiences";
  static const String createProject = "/projects";

  static const String getProjects = "/projects";

  static const String updateProject = "/projects";

  static const String deleteProject = "/projects";

  static const String showProject = "/projects";
  static const String createCertification = "/certifications";

  static const String getCertifications = "/certifications";

  static const String updateCertification = "/certifications";

  static const String deleteCertification = "/certifications";

  static const String showCertification = "/certifications";
  static const String createInterest = "/interests";
  // Interest
  static const String getInterests = "$baseUrl/interests";

  static const String getJobs = "/jobs";
  static const String blocks = "/blocks";

  static const String updateInterest = "$baseUrl/interests";

  static const String deleteInterest = "$baseUrl/interests";
  static const generateSuggestions = "$baseUrl/ai/skill-suggestions";

  static const getSuggestions = "$baseUrl/skills/suggestions";

  static const acceptSuggestion = "$baseUrl/skills/suggestions";

  static const rejectSuggestion = "$baseUrl/skills/suggestions";
  // CV AI
  // CV
  static const String generateCv = "$baseUrl/cv/generate";
  static const String analyzeCv = "$baseUrl/cv/analyze";
  static const String uploadAndExtractCv = "$baseUrl/cv/upload";

  static const String confirmUploadedCv = "$baseUrl/cv/upload/confirm";
  static const String listCvFiles = "$baseUrl/cv/files";
  static const String enhanceCv = "$baseUrl/cv/enhance";

  static const String saveEnhancedCv = "$baseUrl/cv/enhance/save";

  static const String matchCv = "$baseUrl/cv/match";

  static const String generatePdf = "$baseUrl/cv/pdf";

  static const String cvFiles = "$baseUrl/cv/files";
  static String cvFileDetails(int id) => "$baseUrl/cv/files/$id";
  static String downloadCvFile(int id) => "$baseUrl/cv/files/$id/download";
  static const String profileCompletion = "$baseUrl/profile/completion";
  static const String recalculateCompletion =
      "$baseUrl/profile/completion/recalculate";
  static const String publicProfileSettings = "$baseUrl/profile/public";
  static const String changeSlug = "$baseUrl/profile/public/change-slug";
  static const String viewPublicProfile = "$baseUrl/p/";
  static const String resendOtp = "$baseUrl/resend-otp";
  static const String deleteAccountRequest = '$baseUrl/account/delete/request';
  static const String deleteAccountConfirm = '$baseUrl/account/delete/confirm';
  static const String deleteAccountRestore = '$baseUrl/account/delete/restore';
  // Onboarding
  // ---------------- Onboarding ----------------
  // GET  -> جلب حالة الـ Onboarding الحالية
  static const String onboardingStatus = "$baseUrl/onboarding";

  // POST -> إكمال خطوة معينة (step = رقم الخطوة 1..6)
  static String onboardingCompleteStep(int step) =>
      "$baseUrl/onboarding/step/$step/complete";

  // POST -> تخطي كامل الـ Onboarding
  static const String onboardingSkip = "$baseUrl/onboarding/skip";

  // POST -> إعادة تشغيل الـ Onboarding من الصفر
  static const String onboardingRestart = "$baseUrl/onboarding/restart";
  static const String createExport = "/account/export";
  static const String exportStatus = "/account/export/status";
  static String downloadExport(int id) => "/account/export/$id/download";
  static const String conversations = "/conversations";
}
