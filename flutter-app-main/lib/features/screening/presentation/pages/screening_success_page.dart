import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/app/theme/app_theme.dart';
import 'package:new_app/core/widgets/common_widgets.dart';

class ScreeningSuccessPage extends StatelessWidget {
  final String patientId;
  const ScreeningSuccessPage({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated success icon
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (_, value, child) =>
                    Transform.scale(scale: value, child: child),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.tertiary.withValues(alpha: 0.3),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    size: 72,
                    color: AppTheme.tertiary,
                  ),
                ),
              ),
              const SizedBox(height: 36),
              Text(
                'Screening Saved!',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'The screening has been saved successfully. The AI report is ready and can be viewed or shared.',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 15,
                  color: AppTheme.onSurfaceVariant,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Summary row
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.outlineVariant),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _SummaryItem(
                      icon: Icons.save_rounded,
                      label: 'Saved',
                      color: AppTheme.tertiary,
                    ),
                    Container(
                        width: 1, height: 40, color: AppTheme.outlineVariant),
                    _SummaryItem(
                      icon: Icons.cloud_outlined,
                      label: 'Queued',
                      color: const Color(0xFF7C4400),
                    ),
                    Container(
                        width: 1, height: 40, color: AppTheme.outlineVariant),
                    _SummaryItem(
                      icon: Icons.psychology_rounded,
                      label: 'AI Done',
                      color: AppTheme.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              PrimaryButton(
                label: 'View AI Result',
                icon: Icons.psychology_rounded,
                onPressed: () =>
                    context.pushReplacement('/screening/result/$patientId'),
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                label: 'Back to Patient',
                onPressed: () => context.go('/patients/$patientId'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/dashboard'),
                child: Text(
                  'Go to Dashboard',
                  style: GoogleFonts.beVietnamPro(
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.beVietnamPro(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
