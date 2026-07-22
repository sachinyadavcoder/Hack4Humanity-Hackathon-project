import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/app/theme/app_theme.dart';
import 'package:new_app/core/widgets/common_widgets.dart';
import 'package:new_app/features/patients/data/repositories/patient_repository.dart';
import 'package:new_app/features/patients/data/models/patient_model.dart';

class StartScreeningPage extends StatefulWidget {
  final String patientId;

  const StartScreeningPage({super.key, required this.patientId});

  @override
  State<StartScreeningPage> createState() => _StartScreeningPageState();
}

class _StartScreeningPageState extends State<StartScreeningPage> {
  PatientModel? _patient;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPatient();
  }

  Future<void> _loadPatient() async {
    try {
      final patient = await PatientRepository.getPatientById(widget.patientId);
      if (mounted) {
        setState(() {
          _patient = patient;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    if (_error != null || _patient == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Could not load patient: $_error')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Screening'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient info card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryFixed,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppTheme.primary.withValues(alpha: 0.15),
                    child: Text(
                      _patient!.name.isNotEmpty ? _patient!.name.substring(0, 1).toUpperCase() : '?',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _patient!.name,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_patient!.pregnancyWeek} weeks • ${_patient!.age} yrs',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 13,
                            color: AppTheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            RiskBadge(risk: _patient!.risk.isNotEmpty ? _patient!.risk : 'Normal'),
                            const SizedBox(width: 8),
                            Text(
                              _patient!.gravida.isNotEmpty ? _patient!.gravida : 'G1P0',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 12,
                                color: AppTheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Screening type selection
            Text(
              'Screening Type',
              style: GoogleFonts.beVietnamPro(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            ...[
              _ScreeningTypeCard(
                icon: Icons.schedule_rounded,
                title: 'Routine ANC',
                description: 'Standard antenatal care screening',
                color: AppTheme.primary,
              ),
              _ScreeningTypeCard(
                icon: Icons.repeat_rounded,
                title: 'Follow-up',
                description: 'Track changes from previous screening',
                color: AppTheme.tertiary,
              ),
              _ScreeningTypeCard(
                icon: Icons.emergency_rounded,
                title: 'Emergency Assessment',
                description: 'Immediate risk assessment',
                color: AppTheme.secondary,
              ),
            ],
            const SizedBox(height: 24),
            // Info box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded,
                      size: 20, color: AppTheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This screening will use AI to analyze vitals, symptoms, and history to assess maternal risk. You can proceed offline — data will sync when connected.',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 13,
                        color: AppTheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              label: 'Begin Screening',
              icon: Icons.arrow_forward_rounded,
              onPressed: () =>
                  context.push('/screening/form/${widget.patientId}'),
            ),
            const SizedBox(height: 12),
            SecondaryButton(
              label: 'Cancel',
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScreeningTypeCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _ScreeningTypeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  State<_ScreeningTypeCard> createState() => _ScreeningTypeCardState();
}

class _ScreeningTypeCardState extends State<_ScreeningTypeCard> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _selected = !_selected),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _selected
              ? widget.color.withValues(alpha: 0.08)
              : AppTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _selected
                ? widget.color
                : AppTheme.outlineVariant,
            width: _selected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(widget.icon, color: widget.color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  Text(
                    widget.description,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              _selected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: _selected ? widget.color : AppTheme.outline,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
