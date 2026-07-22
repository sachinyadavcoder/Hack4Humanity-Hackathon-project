import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/dummy_data/mock_data_providers.dart';

class MyHealthScreen extends ConsumerWidget {
  const MyHealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final userProfile = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Health'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              color: const Color(0xFF27AE60).withOpacity(0.1),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: const Color(0xFF27AE60).withOpacity(0.5)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Color(0xFF27AE60), size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'All is well',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: const Color(0xFF27AE60),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Your health indicators are normal.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Health Metrics
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    context,
                    'Weight',
                    '${userProfile.weight} kg',
                    '↑ 1kg',
                    colors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    context,
                    'Blood Pressure',
                    userProfile.bloodPressure,
                    '→ Normal',
                    colors.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    context,
                    'Hemoglobin',
                    '${userProfile.hemoglobin} g/dL',
                    '→ Normal',
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    context,
                    'Blood Sugar',
                    '${userProfile.bloodSugar} mg/dL',
                    '↓ Normal',
                    Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Today's Suggestions
            Text(
              'Today\'s Suggestions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _buildSuggestionCard(context, 'Drink Water', '8 glasses minimum', Icons.water_drop, Colors.blue),
            _buildSuggestionCard(context, 'Take Iron Tablet', 'After meal', Icons.medication, colors.primary),
            _buildSuggestionCard(context, 'Walk', '15 mins evening walk', Icons.directions_walk, const Color(0xFF27AE60)),
            _buildSuggestionCard(context, 'Rest', 'Sleep 8 hours', Icons.bed, colors.secondary),
            
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.push('/health/journey'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primaryContainer,
                foregroundColor: colors.primary,
              ),
              child: const Text('View Pregnancy Journey'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.push('/health/recovery'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.surface,
                foregroundColor: colors.primary,
                side: BorderSide(color: colors.primary),
              ),
              child: const Text('Mother Recovery Checklist'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, String value, String status, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionCard(BuildContext context, String title, String subtitle, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.check_circle_outline),
      ),
    );
  }
}
