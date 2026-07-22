import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:new_app/app/theme/app_theme.dart';
import 'package:new_app/app/constants/dummy_data.dart';
import 'package:new_app/core/widgets/common_widgets.dart';

class PatientDashboardPage extends StatelessWidget {
  final String patientId;

  const PatientDashboardPage({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    final patient = DummyData.patients.firstWhere(
      (p) => p['id'] == patientId,
      orElse: () => DummyData.patients.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${patient['name'].toString().split(' ').first}\'s Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Risk card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primary, AppTheme.primaryContainer],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Risk Assessment',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${patient['risk']} Risk',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${patient['gestationalAge']} gestation',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      patient['risk'] == 'High' ? '87%' : patient['risk'] == 'Medium' ? '52%' : '18%',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Vitals grid
          SectionHeader(title: 'Current Vitals'),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.4,
            children: [
              VitalCard(
                label: 'Blood Pressure',
                value: patient['bloodPressure'].toString().split(' ').first,
                unit: 'mmHg',
                icon: Icons.monitor_heart_rounded,
                color: AppTheme.primary,
                isAlert: patient['risk'] == 'High',
              ),
              VitalCard(
                label: 'Heart Rate',
                value: patient['heartRate'].toString().split(' ').first,
                unit: 'bpm',
                icon: Icons.favorite_rounded,
                color: AppTheme.secondary,
              ),
              VitalCard(
                label: 'Hemoglobin',
                value: patient['hemoglobin'].toString().split(' ').first,
                unit: 'g/dL',
                icon: Icons.bloodtype_rounded,
                color: const Color(0xFF7C4400),
                isAlert: true,
              ),
              VitalCard(
                label: 'Weight',
                value: patient['weight'].toString().split(' ').first,
                unit: 'kg',
                icon: Icons.monitor_weight_rounded,
                color: AppTheme.tertiary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // BP Trend Chart
          SectionHeader(title: 'Blood Pressure Trend'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 160,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, _) {
                            final weeks = ['W1', 'W2', 'W3', 'W4', 'W5'];
                            final idx = v.toInt();
                            if (idx >= 0 && idx < weeks.length) {
                              return Text(weeks[idx],
                                  style: GoogleFonts.beVietnamPro(
                                      fontSize: 10, color: AppTheme.outline));
                            }
                            return const SizedBox();
                          },
                          reservedSize: 22,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, _) => Text(
                            v.toInt().toString(),
                            style: GoogleFonts.beVietnamPro(
                                fontSize: 10, color: AppTheme.outline),
                          ),
                          reservedSize: 30,
                        ),
                      ),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 120),
                          FlSpot(1, 125),
                          FlSpot(2, 132),
                          FlSpot(3, 138),
                          FlSpot(4, 140),
                        ],
                        isCurved: true,
                        color: AppTheme.primary,
                        barWidth: 2.5,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppTheme.primary.withValues(alpha: 0.1),
                        ),
                      ),
                    ],
                    minY: 100,
                    maxY: 160,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Screenings summary
          SectionHeader(
            title: 'Screenings',
            action: 'View History',
            onAction: () => context.push('/patients/$patientId/history'),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _SummaryBadge(
                    label: 'Total',
                    value: patient['screeningCount'].toString(),
                    color: AppTheme.primary,
                  ),
                  _SummaryBadge(
                    label: 'High Risk',
                    value: '2',
                    color: AppTheme.error,
                  ),
                  _SummaryBadge(
                    label: 'Pending',
                    value: '0',
                    color: AppTheme.tertiary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Start New Screening',
            icon: Icons.medical_services_rounded,
            onPressed: () =>
                context.push('/screening/start/$patientId'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SummaryBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.beVietnamPro(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.beVietnamPro(
            fontSize: 12,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
