import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/dummy_data/mock_data_providers.dart';

class BabyScreen extends ConsumerWidget {
  const BabyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final userProfile = ref.watch(userProfileProvider);
    final isPregnancyActive = userProfile.isPregnancyActive;
    final userNotifier = ref.read(userProfileProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(isPregnancyActive ? 'Baby Development' : 'Baby Care'),
        actions: [
          // Dummy toggle to simulate mode switch
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () => userNotifier.togglePregnancyMode(!isPregnancyActive),
            tooltip: 'Toggle Pregnancy/Post-Delivery Mode',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: isPregnancyActive
            ? _buildPregnancyMode(context, colors, userProfile.pregnancyWeek)
            : _buildBabyCareMode(context, colors),
      ),
    );
  }

  Widget _buildPregnancyMode(BuildContext context, ColorScheme colors, int week) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Icon(Icons.child_friendly, size: 100, color: colors.primary),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Week $week Development',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(context, 'Size', 'Eggplant', Icons.straighten, colors.secondary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoCard(context, 'Weight', '1.0 kg', Icons.monitor_weight, Colors.orange),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Baby Milestones',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        _buildListCard(context, 'Brain development is rapid.', Icons.star),
        _buildListCard(context, 'Eyes can open and close.', Icons.star),
        _buildListCard(context, 'Can hear outside noises clearly.', Icons.star),
      ],
    );
  }

  Widget _buildBabyCareMode(BuildContext context, ColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: colors.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Icon(Icons.face, size: 100, color: colors.secondary),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Newborn Care',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        _buildActionRow(context, 'Feeding Reminder', 'Every 2-3 hours', Icons.restaurant, colors.primary),
        const SizedBox(height: 12),
        _buildActionRow(context, 'Sleep Tips', '14-17 hours daily', Icons.bedtime, colors.secondary),
        const SizedBox(height: 12),
        _buildActionRow(context, 'Vaccination Schedule', 'Check upcoming shots', Icons.vaccines, const Color(0xFF27AE60)),
        const SizedBox(height: 24),
        Text(
          'Emergency Symptoms',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: colors.error),
        ),
        const SizedBox(height: 12),
        Card(
          color: colors.error.withOpacity(0.1),
          elevation: 0,
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• Fever above 100.4°F (38°C)'),
                Text('• Difficulty breathing'),
                Text('• Not feeding well'),
                Text('• Continuous crying'),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
            Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildListCard(BuildContext context, String text, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(text),
      ),
    );
  }

  Widget _buildActionRow(BuildContext context, String title, String subtitle, IconData icon, Color color) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
