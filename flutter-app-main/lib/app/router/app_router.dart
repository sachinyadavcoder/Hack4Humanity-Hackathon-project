import 'package:go_router/go_router.dart';
import 'package:new_app/features/auth/presentation/pages/splash_page.dart';
import 'package:new_app/features/auth/presentation/pages/onboarding_page.dart';
import 'package:new_app/features/auth/presentation/pages/login_page.dart';
import 'package:new_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:new_app/features/dashboard/presentation/pages/home_dashboard_page.dart';
import 'package:new_app/features/patients/presentation/pages/patient_list_page.dart';
import 'package:new_app/features/patients/presentation/pages/patient_details_page.dart';
import 'package:new_app/features/patients/presentation/pages/add_patient_page.dart';
import 'package:new_app/features/patients/presentation/pages/edit_patient_page.dart';
import 'package:new_app/features/patients/presentation/pages/patient_dashboard_page.dart';
import 'package:new_app/features/patients/presentation/pages/patient_history_page.dart';
import 'package:new_app/features/screening/presentation/pages/start_screening_page.dart';
import 'package:new_app/features/screening/presentation/pages/screening_form_page.dart';
import 'package:new_app/features/screening/presentation/pages/review_submit_page.dart';
import 'package:new_app/features/screening/presentation/pages/ai_result_page.dart';
import 'package:new_app/features/screening/presentation/pages/screening_success_page.dart';
import 'package:new_app/features/screening/presentation/pages/screening_history_page.dart';
import 'package:new_app/features/screening/presentation/pages/screening_details_page.dart';
import 'package:new_app/features/reports/presentation/pages/reports_list_page.dart';
import 'package:new_app/features/reports/presentation/pages/report_preview_page.dart';
import 'package:new_app/features/profile/presentation/pages/profile_page.dart';
import 'package:new_app/features/profile/presentation/pages/settings_page.dart';
import 'package:new_app/features/profile/presentation/pages/about_page.dart';
import 'package:new_app/features/utility/presentation/pages/search_patients_page.dart';
import 'package:new_app/features/utility/presentation/pages/utility_pages.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => const ErrorPage(),
  routes: [
    // ── Auth ──────────────────────────────────────────────
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    // ── Dashboard ─────────────────────────────────────────
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const HomeDashboardPage(),
    ),
    // ── Patients ──────────────────────────────────────────
    GoRoute(
      path: '/patients',
      builder: (context, state) => const PatientListPage(),
    ),
    GoRoute(
      path: '/patients/add',
      builder: (context, state) => const AddPatientPage(),
    ),
    GoRoute(
      path: '/patients/search',
      builder: (context, state) => const SearchPatientsPage(),
    ),
    GoRoute(
      path: '/patients/empty',
      builder: (context, state) => const EmptyPatientsPage(),
    ),
    GoRoute(
      path: '/patients/:id',
      builder: (context, state) =>
          PatientDetailsPage(patientId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/patients/:id/edit',
      builder: (context, state) =>
          EditPatientPage(patientId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/patients/:id/dashboard',
      builder: (context, state) =>
          PatientDashboardPage(patientId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/patients/:id/history',
      builder: (context, state) =>
          PatientHistoryPage(patientId: state.pathParameters['id']!),
    ),
    // ── Screening ─────────────────────────────────────────
    GoRoute(
      path: '/screening/start/:patientId',
      builder: (context, state) =>
          StartScreeningPage(patientId: state.pathParameters['patientId']!),
    ),
    GoRoute(
      path: '/screening/form/:patientId',
      builder: (context, state) =>
          ScreeningFormPage(patientId: state.pathParameters['patientId']!),
    ),
    GoRoute(
      path: '/screening/review/:patientId',
      builder: (context, state) =>
          ReviewSubmitPage(patientId: state.pathParameters['patientId']!),
    ),
    GoRoute(
      path: '/screening/result/:patientId',
      builder: (context, state) =>
          AIResultPage(patientId: state.pathParameters['patientId']!),
    ),
    GoRoute(
      path: '/screening/success/:patientId',
      builder: (context, state) => ScreeningSuccessPage(patientId: state.pathParameters['patientId']!),
    ),
    GoRoute(
      path: '/screening/history/:patientId',
      builder: (context, state) =>
          ScreeningHistoryPage(patientId: state.pathParameters['patientId']!),
    ),
    GoRoute(
      path: '/screening/details/:screeningId',
      builder: (context, state) =>
          ScreeningDetailsPage(screeningId: state.pathParameters['screeningId']!),
    ),
    GoRoute(
      path: '/screening/empty',
      builder: (context, state) => const EmptyScreeningPage(),
    ),
    // ── Reports ───────────────────────────────────────────
    GoRoute(
      path: '/reports',
      builder: (context, state) => const ReportsListPage(),
    ),
    GoRoute(
      path: '/reports/:reportId',
      builder: (context, state) =>
          ReportPreviewPage(reportId: state.pathParameters['reportId']!),
    ),
    // ── Profile ───────────────────────────────────────────
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutPage(),
    ),
    // ── Utility ───────────────────────────────────────────
    GoRoute(
      path: '/no-internet',
      builder: (context, state) => const NoInternetPage(),
    ),
    GoRoute(
      path: '/error',
      builder: (context, state) => const ErrorPage(),
    ),
  ],
);
