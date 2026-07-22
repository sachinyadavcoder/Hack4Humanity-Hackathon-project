import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/app/theme/app_theme.dart';
import 'package:new_app/app/constants/dummy_data.dart';
import 'package:new_app/core/widgets/common_widgets.dart';

class ScreeningDetailsPage extends StatelessWidget {
  final String screeningId;

  const ScreeningDetailsPage({super.key, required this.screeningId});

  @override
  Widget build(BuildContext context) {
    final screening = DummyData.screenings.firstWhere(
      (s) => s['id'] == screeningId,
      orElse: () => DummyData.screenings.first,
    );

    final isHigh = screening['riskLevel'] == 'High';
    final riskColor = isHigh ? AppTheme.error : const Color(0xFF166534);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Screening Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.print_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.primaryContainer],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        child: Text(
                          screening['patientName']
                              .toString()
                              .substring(0, 1),
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              screening['patientName'],
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '${screening['type']} • ${screening['date']}',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      RiskBadge(risk: screening['riskLevel']),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _HeaderStat(
                          label: 'AI Score',
                          value: '${screening['aiScore']}%'),
                      _HeaderStat(
                          label: 'Gestation',
                          value: screening['gestationalAge']),
                      _HeaderStat(
                          label: 'BP',
                          value: '${screening['bloodPressure']} mmHg'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Findings
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Clinical Findings',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...(screening['findings'] as List).map((finding) =>
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.radio_button_checked_rounded,
                                  size: 14, color: riskColor),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  finding,
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 14,
                                    color: AppTheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Recommendation
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb_rounded,
                            color: AppTheme.primary, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Recommendation',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      screening['recommendation'],
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 14,
                        color: AppTheme.onSurface,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: 'View Full Report',
                    onPressed: () =>
                        context.push('/reports/RPT001'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SecondaryButton(
              label: 'Back to Patient',
              onPressed: () =>
                  context.push('/patients/${screening['patientId']}'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final String label;
  final String value;

  const _HeaderStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.beVietnamPro(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.beVietnamPro(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
