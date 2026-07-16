class ApiConstants {
  static const String baseUrl = "http://192.168.1.15:8000/api";

  static const String register = "/register";
  static const String verifyOtp = "/verify-otp";
  static const String login = "/login";
  static const String loginVerifyOtp = "/login/verify-otp";
  static const String requestPasswordOtp = "/password/request-otp";
  static const String verifyPasswordOtp = "/password/verify-otp";
  static const String resetPassword = "/password/reset";
  static const String createProfile = "/profile";
  static const String viewProfile = "/profile";
  static const String updateProfile = "/profile/update";
  static const String deleteProfile = "/profile";
  static const String listJobs = "/jobs";
  static const String followUnfollow = "/companies/";
  static const String jobLike = "/posts/";
  static const String jobSave = "/saved-posts/toggle";
  static const String getCategories = "/categories";
  static String jobApply(int jobId) {
    return "/jobs/$jobId/apply";
  }
}
