import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/dummy_data/mock_data_providers.dart';

class PregnancyJourneyScreen extends ConsumerWidget {
  const PregnancyJourneyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final userProfile = ref.watch(userProfileProvider);
    final currentWeek = userProfile.pregnancyWeek;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pregnancy Journey'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 40,
        itemBuilder: (context, index) {
          final week = index + 1;
          final isCurrent = week == currentWeek;
          final isPast = week < currentWeek;

          return _buildWeekCard(context, week, isCurrent, isPast, colors);
        },
      ),
    );
  }

  Widget _buildWeekCard(BuildContext context, int week, bool isCurrent, bool isPast, ColorScheme colors) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline indicator
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCurrent ? colors.primary : (isPast ? const Color(0xFF27AE60) : colors.surfaceDim),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$week',
                      style: TextStyle(
                        color: isCurrent || isPast ? colors.onPrimary : colors.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isPast || isCurrent ? const Color(0xFF27AE60) : colors.surfaceDim,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Content Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Card(
                elevation: isCurrent ? 4 : 1,
                color: isCurrent ? colors.primaryContainer : colors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: isCurrent ? BorderSide(color: colors.primary, width: 2) : BorderSide.none,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Week $week',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isCurrent ? colors.primary : colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.child_care, color: colors.secondary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Baby is the size of a ${week < 12 ? 'grape' : week < 24 ? 'banana' : week < 32 ? 'coconut' : 'watermelon'}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.pregnant_woman, color: colors.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'You might feel ${week < 12 ? 'nauseous' : week < 24 ? 'baby kicks' : 'tired'}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      if (isCurrent) ...[
                        const Divider(height: 24),
                        const Text('Health Tip', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF27AE60))),
                        const Text('Eat small, frequent meals.'),
                        const SizedBox(height: 8),
                        Text('Warning Sign', style: TextStyle(fontWeight: FontWeight.bold, color: colors.error)),
                        const Text('Contact ASHA if you have severe bleeding.'),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
