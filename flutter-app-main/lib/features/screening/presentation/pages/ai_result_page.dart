import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_app/app/theme/app_theme.dart';
import 'package:new_app/core/widgets/common_widgets.dart';
import 'package:new_app/features/patients/data/repositories/patient_repository.dart';
import 'package:new_app/features/screening/domain/providers/screening_provider.dart';

class AIResultPage extends ConsumerWidget {
  final String patientId;

  const AIResultPage({super.key, required this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prediction = ref.watch(predictionResultProvider);

    if (prediction == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('AI Risk Result')),
        body: const Center(child: Text('No prediction result found.')),
      );
    }

    final isHigh = prediction.risk == 'High';
    final riskColor = isHigh ? AppTheme.error : AppTheme.tertiary;
    final riskBg = isHigh ? AppTheme.errorContainer : const Color(0xFFDCFCE7);
    
    final confidencePercent = (prediction.confidence * 100).toStringAsFixed(1);
    final highProbPercent = (prediction.highProbability * 100).toStringAsFixed(1);
    final lowProbPercent = (prediction.lowProbability * 100).toStringAsFixed(1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Risk Result'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.go('/patients/$patientId'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Main risk card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: riskBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: riskColor.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  // AI icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: riskColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.psychology_rounded,
                      size: 42,
                      color: riskColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${prediction.risk} Risk',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: riskColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'AI Confidence Score',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13,
                      color: riskColor.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$confidencePercent%',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: riskColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: LinearProgressIndicator(
                      value: prediction.confidence,
                      backgroundColor: riskColor.withValues(alpha: 0.15),
                      color: riskColor,
                      minHeight: 10,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Key findings
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.analytics_rounded,
                            color: AppTheme.primary, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Model Probabilities',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildProbRow('High Risk Probability', '$highProbPercent%', AppTheme.error),
                    const SizedBox(height: 8),
                    _buildProbRow('Low Risk Probability', '$lowProbPercent%', AppTheme.tertiary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Recommendation
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primary,
                    AppTheme.primaryContainer,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lightbulb_rounded,
                          color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'AI Recommendation',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isHigh
                        ? 'High risk of complications detected. Immediate referral to a specialist or higher care facility is strongly recommended. Monitor vitals closely.'
                        : 'Low risk detected. Continue with standard routine antenatal care and regular follow-ups.',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Action buttons
            PrimaryButton(
              label: 'Save & Generate Report',
              icon: Icons.description_rounded,
              onPressed: () {
                // Here we will update the patient risk in the backend
                // before navigating to success page
                PatientRepository.updatePatientRisk(patientId, prediction.risk);
                context.pushReplacement('/screening/success/$patientId');
              }
            ),
            const SizedBox(height: 12),
            SecondaryButton(
              label: 'View Patient',
              onPressed: () =>
                  context.go('/patients/$patientId'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.share_rounded, size: 18),
                    label: const Text('Share'),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.print_rounded, size: 18),
                    label: const Text('Print'),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProbRow(String label, String value, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.pie_chart_rounded, size: 16, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              color: AppTheme.onSurface,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.beVietnamPro(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.onSurface,
          ),
        ),
      ],
    );
  }
}
