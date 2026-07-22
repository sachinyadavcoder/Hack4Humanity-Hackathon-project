import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/app/theme/app_theme.dart';
import 'package:new_app/app/constants/dummy_data.dart';
import 'package:new_app/core/widgets/common_widgets.dart';

class ReportPreviewPage extends StatelessWidget {
  final String reportId;

  const ReportPreviewPage({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    final report = DummyData.reports.firstWhere(
      (r) => r['id'] == reportId,
      orElse: () => DummyData.reports.first,
    );
    final screening = DummyData.screenings.firstWhere(
      (s) => s['id'] == report['screeningId'],
      orElse: () => DummyData.screenings.first,
    );
    final patient = DummyData.patients.firstWhere(
      (p) => p['id'] == report['patientId'],
      orElse: () => DummyData.patients.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Preview'),
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
            icon: const Icon(Icons.download_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Report header
            Container(
              width: double.infinity,
              color: AppTheme.primary,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.favorite_rounded,
                          color: Colors.white, size: 28),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MaternalCare',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Maternal Health AI — Report',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'ANTENATAL CARE SCREENING REPORT',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: 0.8),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Report ID: ${report['id']}  •  ${report['date']}',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Patient info section
                  _ReportSection(
                    title: 'PATIENT INFORMATION',
                    rows: [
                      _ReportRow('Name', patient['name']),
                      _ReportRow('Age', '${patient['age']} years'),
                      _ReportRow('Phone', patient['phone']),
                      _ReportRow('Blood Type', patient['bloodType']),
                      _ReportRow('Gravida/Para', 'G${patient['gravida']}P${patient['para']}'),
                      _ReportRow('Gestational Age', patient['gestationalAge']),
                      _ReportRow('LMP', patient['lmp']),
                      _ReportRow('EDD', patient['edd']),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Vitals
                  _ReportSection(
                    title: 'VITAL SIGNS',
                    rows: [
                      _ReportRow('Blood Pressure', '${screening['bloodPressure']} mmHg', isAlert: true),
                      _ReportRow('Heart Rate', patient['heartRate']),
                      _ReportRow('Temperature', patient['temperature']),
                      _ReportRow('Weight', '${screening['weight']}'),
                      _ReportRow('Hemoglobin', patient['hemoglobin'], isAlert: true),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // AI Assessment
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.errorContainer,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.error.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.psychology_rounded,
                                color: AppTheme.error, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'AI RISK ASSESSMENT',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.error,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Risk Level',
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 12,
                                      color: AppTheme.onSurfaceVariant,
                                    ),
                                  ),
                                  Text(
                                    screening['riskLevel'],
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.error,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Confidence',
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 12,
                                    color: AppTheme.onSurfaceVariant,
                                  ),
                                ),
                                Text(
                                  '${screening['aiScore']}%',
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.error,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Recommendation:',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.onSurface,
                          ),
                        ),
                        Text(
                          screening['recommendation'],
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 13,
                            color: AppTheme.onSurface,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Actions
                  PrimaryButton(
                    label: 'Download PDF',
                    icon: Icons.download_rounded,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    label: 'Share Report',
                    onPressed: () {},
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportSection extends StatelessWidget {
  final String title;
  final List<_ReportRow> rows;

  const _ReportSection({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            ...rows,
          ],
        ),
      ),
    );
  }
}

class _ReportRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isAlert;

  const _ReportRow(this.label, this.value, {this.isAlert = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: GoogleFonts.beVietnamPro(
                fontSize: 13,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.beVietnamPro(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isAlert ? AppTheme.error : AppTheme.onSurface,
              ),
            ),
          ),
          if (isAlert)
            const Icon(Icons.warning_amber_rounded,
                size: 14, color: AppTheme.error),
        ],
      ),
    );
  }
}
