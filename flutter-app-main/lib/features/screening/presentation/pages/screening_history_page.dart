import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_app/app/constants/dummy_data.dart';
import 'package:new_app/core/widgets/common_widgets.dart';

class ScreeningHistoryPage extends StatelessWidget {
  final String patientId;

  const ScreeningHistoryPage({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    final screenings = DummyData.screenings
        .where((s) => s['patientId'] == patientId)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Screening History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: screenings.isEmpty
          ? EmptyStateWidget(
              icon: Icons.medical_services_outlined,
              title: 'No Screenings Yet',
              subtitle: 'This patient has no screening records.',
              buttonLabel: 'Start Screening',
              onButtonPressed: () =>
                  context.push('/screening/start/$patientId'),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: screenings.length,
              itemBuilder: (context, index) {
                final screening = screenings[index];
                return ScreeningCard(
                  screening: screening,
                  onTap: () => context.push(
                      '/screening/details/${screening['id']}'),
                );
              },
            ),
    );
  }
}
