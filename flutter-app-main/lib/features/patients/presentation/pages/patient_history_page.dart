import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/app/theme/app_theme.dart';
import 'package:new_app/app/constants/dummy_data.dart';
import 'package:new_app/core/widgets/common_widgets.dart';

class PatientHistoryPage extends StatelessWidget {
  final String patientId;

  const PatientHistoryPage({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    final patient = DummyData.patients.firstWhere(
      (p) => p['id'] == patientId,
      orElse: () => DummyData.patients.first,
    );
    final history = DummyData.patientHistory;

    return Scaffold(
      appBar: AppBar(
        title: Text('${patient['name'].toString().split(' ').first}\'s History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Patient summary bar
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.surfaceContainerLowest,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppTheme.primaryFixed,
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient['name'],
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${patient['gestationalAge']} • G${patient['gravida']}P${patient['para']}',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 12,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                RiskBadge(risk: patient['risk']),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final event = history[index];
                return Column(
                  children: [
                    HistoryCard(
                      event: event,
                      onTap: event['type'] == 'Screening'
                          ? () => context.push('/screening/details/SCR001')
                          : null,
                    ),
                    if (index < history.length - 1)
                      Container(
                        margin: const EdgeInsets.only(left: 36),
                        width: 2,
                        height: 16,
                        color: AppTheme.outlineVariant,
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
