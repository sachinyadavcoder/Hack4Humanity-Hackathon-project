import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_app/core/widgets/common_widgets.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('No Connection'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: EmptyStateWidget(
        icon: Icons.wifi_off_rounded,
        title: 'No Internet Connection',
        subtitle:
            'You\'re currently offline. Don\'t worry — MaternalCare works offline. Data will sync when you\'re back online.',
        buttonLabel: 'Try Again',
        onButtonPressed: () => context.pop(),
      ),
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: EmptyStateWidget(
        icon: Icons.error_outline_rounded,
        title: 'Something Went Wrong',
        subtitle:
            'An unexpected error occurred. Please try again or contact support if the problem persists.',
        buttonLabel: 'Go to Dashboard',
        onButtonPressed: () => context.go('/dashboard'),
      ),
    );
  }
}

class EmptyPatientsPage extends StatelessWidget {
  const EmptyPatientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: EmptyStateWidget(
        icon: Icons.people_outlined,
        title: 'No Patients Yet',
        subtitle:
            'You haven\'t added any patients. Start by registering a new patient.',
        buttonLabel: 'Add First Patient',
        onButtonPressed: () => context.push('/patients/add'),
      ),
    );
  }
}

class EmptyScreeningPage extends StatelessWidget {
  const EmptyScreeningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screenings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: EmptyStateWidget(
        icon: Icons.medical_services_outlined,
        title: 'No Screenings Yet',
        subtitle:
            'This patient has no screening history. Start a new screening to assess maternal risk.',
        buttonLabel: 'Start Screening',
        onButtonPressed: () => context.push('/patients'),
      ),
    );
  }
}
