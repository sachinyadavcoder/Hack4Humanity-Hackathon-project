import 'package:flutter/material.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Help'),
        backgroundColor: colors.errorContainer,
      ),
      backgroundColor: colors.errorContainer,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.warning_amber_rounded, size: 80, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Do you need immediate medical help?',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            _buildEmergencyButton(context, 'Call Ambulance', Icons.local_hospital, Colors.red, Colors.white),
            const SizedBox(height: 16),
            _buildEmergencyButton(context, 'Call Doctor', Icons.medical_services, Colors.orange, Colors.white),
            const SizedBox(height: 16),
            _buildEmergencyButton(context, 'Call ASHA Worker', Icons.support_agent, colors.primary, Colors.white),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Offline Instructions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const Text('• Lie down on your left side.'),
                    const SizedBox(height: 8),
                    const Text('• Keep your hospital bag ready.'),
                    const SizedBox(height: 8),
                    const Text('• Breathe slowly and wait for help.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyButton(BuildContext context, String title, IconData icon, Color bgColor, Color fgColor) {
    return ElevatedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Calling $title...')));
      },
      icon: Icon(icon, size: 32),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        padding: const EdgeInsets.symmetric(vertical: 24),
        textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
