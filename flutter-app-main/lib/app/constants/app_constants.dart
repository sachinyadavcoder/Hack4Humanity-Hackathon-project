class AppConstants {
  static const String appName = 'MaternalCare';
  static const String appTagline = 'Maternal Health AI';
  static const String appVersion = '1.0.0';
  static const String appBuild = '1';

  // Route Names
  static const String routeSplash = '/';
  static const String routeOnboarding = '/onboarding';
  static const String routeLogin = '/login';
  static const String routeForgotPassword = '/forgot-password';
  static const String routeDashboard = '/dashboard';
  static const String routePatientList = '/patients';
  static const String routeAddPatient = '/patients/add';
  static const String routeEditPatient = '/patients/:id/edit';
  static const String routePatientDetails = '/patients/:id';
  static const String routePatientDashboard = '/patients/:id/dashboard';
  static const String routePatientHistory = '/patients/:id/history';
  static const String routeSearchPatients = '/patients/search';
  static const String routeStartScreening = '/screening/start/:patientId';
  static const String routeScreeningForm = '/screening/form/:patientId';
  static const String routeReviewSubmit = '/screening/review/:patientId';
  static const String routeAIResult = '/screening/result/:screeningId';
  static const String routeScreeningSuccess = '/screening/success';
  static const String routeScreeningHistory = '/screening/history/:patientId';
  static const String routeScreeningDetails = '/screening/details/:screeningId';
  static const String routeReportsList = '/reports';
  static const String routeReportPreview = '/reports/:reportId';
  static const String routeProfile = '/profile';
  static const String routeSettings = '/settings';
  static const String routeAbout = '/about';
  static const String routeNoInternet = '/no-internet';
  static const String routeError = '/error';
  static const String routeEmptyPatients = '/patients/empty';
  static const String routeEmptyScreening = '/screening/empty';
}
