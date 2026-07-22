import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/dummy_data/mock_data_providers.dart';

class MotherRecoveryScreen extends ConsumerWidget {
  const MotherRecoveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checklist = ref.watch(recoveryChecklistProvider);
    final notifier = ref.read(recoveryChecklistProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Recovery'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Your health is as important as your baby\'s.',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildChecklistItem(context, 'Water Intake', 'At least 8 glasses', checklist.waterIntake, () => notifier.toggleItem('water')),
            _buildChecklistItem(context, 'Nutrition', 'Healthy meals', checklist.nutrition, () => notifier.toggleItem('nutrition')),
            _buildChecklistItem(context, 'Medicine', 'Iron & Calcium', checklist.medicine, () => notifier.toggleItem('medicine')),
            _buildChecklistItem(context, 'Walking', '15 mins gentle walk', checklist.walking, () => notifier.toggleItem('walking')),
            _buildChecklistItem(context, 'Breastfeeding', 'Nursed the baby', checklist.breastfeeding, () => notifier.toggleItem('breastfeeding')),
            _buildChecklistItem(context, 'Sleep', 'Rested well', checklist.sleep, () => notifier.toggleItem('sleep')),
            
            const SizedBox(height: 32),
            Text(
              'How are you feeling today?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMoodButton(context, 'Sad', '😢', checklist.mood, () => notifier.setMood('Sad')),
                _buildMoodButton(context, 'Okay', '😐', checklist.mood, () => notifier.setMood('Okay')),
                _buildMoodButton(context, 'Good', '🙂', checklist.mood, () => notifier.setMood('Good')),
                _buildMoodButton(context, 'Happy', '😊', checklist.mood, () => notifier.setMood('Happy')),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Progress saved!')));
              },
              child: const Text('Save Progress'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem(BuildContext context, String title, String subtitle, bool isChecked, VoidCallback onTap) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: CheckboxListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        value: isChecked,
        onChanged: (val) => onTap(),
        activeColor: colors.primary,
        checkColor: colors.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildMoodButton(BuildContext context, String mood, String emoji, String currentMood, VoidCallback onTap) {
    final isSelected = mood == currentMood;
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? colors.primaryContainer : colors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colors.primary : colors.outline.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(mood, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
