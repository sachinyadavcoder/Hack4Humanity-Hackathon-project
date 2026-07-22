import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community & Resources'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionHeader(context, 'Government Schemes', colors),
            _buildCard(context, 'JSY Scheme', 'Financial assistance for institutional delivery.', Icons.account_balance, colors.primary),
            _buildCard(context, 'PMMVY', 'Maternity benefit program for nutrition.', Icons.account_balance, colors.primary),
            
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Educational Videos', colors),
            _buildCard(context, 'How to breastfeed correctly', '10 mins video', Icons.play_circle_fill, colors.secondary),
            _buildCard(context, 'Exercises for normal delivery', '15 mins video', Icons.play_circle_fill, colors.secondary),
            
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Frequently Asked Questions', colors),
            _buildCard(context, 'Is it safe to eat papaya?', 'Read the expert answer.', Icons.question_answer, Colors.orange),
            _buildCard(context, 'When should I pack my hospital bag?', 'Read the expert answer.', Icons.question_answer, Colors.orange),
            _buildCard(context, 'How to manage back pain?', 'Read the expert answer.', Icons.question_answer, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String subtitle, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Dummy tap
        },
      ),
    );
  }
}
