import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_app/app/theme/app_theme.dart';
import 'package:new_app/app/constants/dummy_data.dart';
import 'package:new_app/core/widgets/common_widgets.dart';
import 'package:new_app/features/screening/domain/providers/screening_provider.dart';
import 'package:new_app/features/screening/domain/services/prediction_service.dart';

class ReviewSubmitPage extends ConsumerStatefulWidget {
  final String patientId;

  const ReviewSubmitPage({super.key, required this.patientId});

  @override
  ConsumerState<ReviewSubmitPage> createState() => _ReviewSubmitPageState();
}

class _ReviewSubmitPageState extends ConsumerState<ReviewSubmitPage> {
  bool _isPredicting = false;

  Future<void> _submitAndAnalyze() async {
    setState(() => _isPredicting = true);
    try {
      final formData = ref.read(screeningFormDataProvider);
      final service = ref.read(predictionServiceProvider);
      
      final result = await service.predict(formData);
      
      ref.read(predictionResultProvider.notifier).updateState(result);
      
      if (mounted) {
        context.pushReplacement('/screening/result/${widget.patientId}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Prediction failed: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPredicting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final patient = DummyData.patients.firstWhere(
      (p) => p['id'] == widget.patientId,
      orElse: () => DummyData.patients.first,
    );

    final formData = ref.watch(screeningFormDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review & Submit'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Patient banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryFixed,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppTheme.primary.withValues(alpha: 0.15),
                  child: Text(
                    patient['name'].toString().substring(0, 1),
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient['name'],
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${patient['gestationalAge']} • Routine ANC',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 13,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Vitals review
          _ReviewSection(
            title: 'Vitals',
            icon: Icons.monitor_heart_rounded,
            items: [
              _ReviewItem('Blood Pressure', '${formData.systolicBp?.toInt() ?? '-'}/${formData.diastolicBp?.toInt() ?? '-'} mmHg', formData.systolicBp != null && (formData.systolicBp! > 140 || formData.diastolicBp! > 90)),
              _ReviewItem('Heart Rate', '${formData.heartRate?.toInt() ?? '-'} bpm', false),
              _ReviewItem('Temperature', '${formData.bodyTemperature ?? '-'}°C', false),
              _ReviewItem('Blood Sugar', '${formData.bloodSugar ?? '-'} mmol/L', false),
              _ReviewItem('BMI', formData.bmi?.toStringAsFixed(1) ?? '-', false),
            ],
          ),
          const SizedBox(height: 12),
          // History
          _ReviewSection(
            title: 'Medical History',
            icon: Icons.history_edu_rounded,
            items: [
              _ReviewItem('Previous Complications', formData.previousComplications == 1.0 ? 'Yes' : 'No', formData.previousComplications == 1.0),
              _ReviewItem('Preexisting Diabetes', formData.preexistingDiabetes == 1.0 ? 'Yes' : 'No', formData.preexistingDiabetes == 1.0),
              _ReviewItem('Gestational Diabetes', formData.gestationalDiabetes == 1.0 ? 'Yes' : 'No', formData.gestationalDiabetes == 1.0),
              _ReviewItem('Mental Health Concerns', formData.mentalHealth == 1.0 ? 'Yes' : 'No', false),
            ],
          ),
          const SizedBox(height: 24),
          // AI Notice
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryFixed,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.psychology_rounded,
                    color: AppTheme.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Analysis Ready',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Submitting will trigger AI risk assessment. Results will be available immediately.',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 13,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _isPredicting
              ? const Center(child: CircularProgressIndicator())
              : PrimaryButton(
                  label: 'Submit & Analyze',
                  icon: Icons.send_rounded,
                  onPressed: _submitAndAnalyze,
                ),
          const SizedBox(height: 12),
          SecondaryButton(
            label: 'Edit Screening',
            onPressed: () => context.pop(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _ReviewSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<_ReviewItem> items;

  const _ReviewSection({
    required this.title,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: AppTheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.label,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 13,
                            color: AppTheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: item.isAlert
                              ? AppTheme.errorContainer
                              : AppTheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.value,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: item.isAlert
                                ? AppTheme.error
                                : AppTheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _ReviewItem {
  final String label;
  final String value;
  final bool isAlert;

  const _ReviewItem(this.label, this.value, this.isAlert);
}
