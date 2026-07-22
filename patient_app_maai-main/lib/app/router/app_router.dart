import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import screens (we will create these next)
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/language_selection_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/main/main_scaffold.dart';
import '../../features/home/home_screen.dart';
import '../../features/health/my_health_screen.dart';
import '../../features/health/pregnancy_journey_screen.dart';
import '../../features/health/mother_recovery_screen.dart';
import '../../features/baby/baby_screen.dart';
import '../../features/appointments/appointments_screen.dart';
import '../../features/emergency/emergency_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/community/community_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/profile/settings_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/language',
        builder: (context, state) => const LanguageSelectionScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      // Main Scaffold contains the bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/health',
            builder: (context, state) => const MyHealthScreen(),
            routes: [
              GoRoute(
                path: 'journey',
                builder: (context, state) => const PregnancyJourneyScreen(),
              ),
              GoRoute(
                path: 'recovery',
                builder: (context, state) => const MotherRecoveryScreen(),
              ),
            ]
          ),
          GoRoute(
            path: '/baby',
            builder: (context, state) => const BabyScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ]
          ),
        ],
      ),
      // Standalone routes accessible from anywhere
      GoRoute(
        path: '/appointments',
        builder: (context, state) => const AppointmentsScreen(),
      ),
      GoRoute(
        path: '/emergency',
        builder: (context, state) => const EmergencyScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/community',
        builder: (context, state) => const CommunityScreen(),
      ),
    ],
  );
});
