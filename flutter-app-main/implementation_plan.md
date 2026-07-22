# MaternalCare Flutter UI Implementation Plan

## Design System (from Stitch AI)

- **App Name**: MaternalCare (Maternal Health AI)
- **Font**: Be Vietnam Pro (via google_fonts package)
- **Primary**: #4D41DF (indigo), **Secondary**: #AA2A6A (rose), **Tertiary**: #006A35 (green)
- **Background**: #F8F9FA, **Surface**: #F8F9FA
- **Material Design 3** with `useMaterial3: true`

## Architecture (UI Only)

```
lib/
  app/
    router/         → app_router.dart (GoRouter)
    theme/          → app_theme.dart
    constants/      → app_constants.dart, dummy_data.dart
  core/
    widgets/        → Reusable widgets
  features/
    auth/presentation/pages/ → splash, onboarding, login, forgot_password
    dashboard/presentation/pages/ → home_dashboard
    patients/presentation/pages/ → patient_list, add_patient, edit_patient, patient_details, patient_dashboard, patient_history
    screening/presentation/pages/ → start_screening, screening_form, review_submit, ai_result, screening_success, screening_history, screening_details
    reports/presentation/pages/ → reports_list, report_preview
    profile/presentation/pages/ → profile, settings, about
    utility/presentation/pages/ → search_patients, empty_patients, empty_screening, no_internet, error_page
  main.dart
```

## Dependencies (pubspec.yaml)
- go_router: ^14.0.0
- google_fonts: ^6.0.0
- fl_chart: ^0.69.0 (for charts on dashboard/patient)

## Screens (30 total)

### Auth
1. SplashPage - gradient bg, logo, loading bar, illustration
2. OnboardingPage - 3-step PageView with dots + Next button
3. LoginPage - glass card form, phone+password fields
4. ForgotPasswordPage - email field, send OTP button

### Dashboard
5. HomeDashboardPage - stats cards, recent patients, quick actions, bottom nav

### Patients
6. PatientListPage - search bar, patient cards with risk badges
7. AddPatientPage - form with sections
8. EditPatientPage - pre-filled form
9. PatientDetailsPage - tab: info/vitals/history
10. PatientDashboardPage - charts, vitals cards
11. PatientHistoryPage - timeline list

### Screening
12. StartScreeningPage - patient info + start button
13. ScreeningFormPage - 4-step stepper (Vitals/Symptoms/History/Lifestyle)
14. ReviewSubmitPage - summary cards
15. AIResultPage - risk level card, recommendations
16. ScreeningSuccessPage - success illustration
17. ScreeningHistoryPage - list of past screenings
18. ScreeningDetailsPage - detailed view

### Reports
19. ReportsListPage - filterable list of report cards
20. ReportPreviewPage - full report view

### Profile
21. ProfilePage - user info, stats
22. SettingsPage - grouped settings tiles
23. AboutPage - app info, version, licenses

### Utility
24. SearchPatientsPage - search with results
25. EmptyPatientsPage - empty state illustration
26. EmptyScreeningPage - empty state
27. NoInternetPage - no connection illustration
28. ErrorPage - 404 illustration

## Reusable Widgets
- PatientCard, RiskBadge, SyncBadge, DashboardStatCard
- VitalCard, SectionHeader, PrimaryButton, SecondaryButton
- FormSection, HistoryCard, ReportCard, ProfileTile, SettingTile
- AppBottomNavBar, AppLoadingIndicator, EmptyStateWidget

## Navigation Flow
Splash → Onboarding → Login → Dashboard
Dashboard ↔ PatientList ↔ PatientDetails ↔ StartScreening → ScreeningForm → Review → AIResult → ScreeningSuccess
PatientDetails → PatientHistory → ScreeningDetails
Dashboard → Reports → ReportPreview
Dashboard → Profile → Settings / About
