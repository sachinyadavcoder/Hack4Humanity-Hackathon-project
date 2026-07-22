import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/app/theme/app_theme.dart';
import 'package:new_app/app/constants/dummy_data.dart';
import 'package:new_app/core/widgets/common_widgets.dart';

class ReportsListPage extends StatefulWidget {
  const ReportsListPage({super.key});

  @override
  State<ReportsListPage> createState() => _ReportsListPageState();
}

class _ReportsListPageState extends State<ReportsListPage> {
  int _navIndex = 2;
  String _filterRisk = 'All';
  final List<String> _riskFilters = ['All', 'High', 'Medium', 'Low'];

  void _onNavTap(int index) {
    setState(() => _navIndex = index);
    switch (index) {
      case 0:
        context.go('/dashboard');
      case 1:
        context.push('/patients');
      case 2:
        break;
      case 3:
        context.push('/profile');
    }
  }

  List<Map<String, dynamic>> get _filteredReports {
    if (_filterRisk == 'All') return DummyData.reports;
    return DummyData.reports
        .where((r) => r['riskLevel'] == _filterRisk)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _navIndex,
        onDestinationSelected: _onNavTap,
      ),
      body: Column(
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: _riskFilters.map((risk) {
                final isSelected = _filterRisk == risk;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(risk),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _filterRisk = risk),
                    backgroundColor: AppTheme.surfaceContainer,
                    selectedColor: AppTheme.primaryFixed,
                    checkmarkColor: AppTheme.primary,
                    labelStyle: GoogleFonts.beVietnamPro(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? AppTheme.primary : AppTheme.onSurfaceVariant,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Stats banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _StatChip(
                  label: 'Total',
                  value: DummyData.reports.length.toString(),
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 8),
                _StatChip(
                  label: 'High Risk',
                  value: DummyData.reports
                      .where((r) => r['riskLevel'] == 'High')
                      .length
                      .toString(),
                  color: AppTheme.error,
                ),
                const SizedBox(width: 8),
                _StatChip(
                  label: 'This Month',
                  value: '4',
                  color: AppTheme.tertiary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _filteredReports.isEmpty
                ? EmptyStateWidget(
                    icon: Icons.description_outlined,
                    title: 'No Reports Found',
                    subtitle: 'Reports appear after screenings are completed.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _filteredReports.length,
                    itemBuilder: (context, index) {
                      final report = _filteredReports[index];
                      return ReportCard(
                        report: report,
                        onTap: () =>
                            context.push('/reports/${report['id']}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Text(
            value,
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.beVietnamPro(
              fontSize: 12,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
