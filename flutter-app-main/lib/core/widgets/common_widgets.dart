import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────
// PRIMARY BUTTON
// ─────────────────────────────────────────────────────────
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppTheme.onPrimary,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label),
                  if (icon != null) ...[
                    const SizedBox(width: 8),
                    Icon(icon, size: 18),
                  ],
                ],
              ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// SECONDARY BUTTON
// ─────────────────────────────────────────────────────────
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// RISK BADGE
// ─────────────────────────────────────────────────────────
class RiskBadge extends StatelessWidget {
  final String risk;
  final bool small;

  const RiskBadge({super.key, required this.risk, this.small = false});

  Color get _bgColor {
    switch (risk.toLowerCase()) {
      case 'high':
        return const Color(0xFFFFDAD6);
      case 'medium':
        return const Color(0xFFFFEDD5);
      case 'low':
        return const Color(0xFFDCFCE7);
      default:
        return AppTheme.surfaceContainer;
    }
  }

  Color get _textColor {
    switch (risk.toLowerCase()) {
      case 'high':
        return const Color(0xFF93000A);
      case 'medium':
        return const Color(0xFF7C4400);
      case 'low':
        return const Color(0xFF166534);
      default:
        return AppTheme.onSurfaceVariant;
    }
  }

  IconData get _icon {
    switch (risk.toLowerCase()) {
      case 'high':
        return Icons.warning_rounded;
      case 'medium':
        return Icons.info_rounded;
      case 'low':
        return Icons.check_circle_rounded;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 10,
        vertical: small ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: small ? 12 : 14, color: _textColor),
          const SizedBox(width: 4),
          Text(
            risk,
            style: GoogleFonts.beVietnamPro(
              fontSize: small ? 11 : 12,
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// SYNC BADGE
// ─────────────────────────────────────────────────────────
class SyncBadge extends StatelessWidget {
  final bool synced;

  const SyncBadge({super.key, required this.synced});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: synced
            ? const Color(0xFFDCFCE7)
            : const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            synced ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
            size: 12,
            color: synced ? const Color(0xFF166534) : const Color(0xFF7C4400),
          ),
          const SizedBox(width: 4),
          Text(
            synced ? 'Synced' : 'Offline',
            style: GoogleFonts.beVietnamPro(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: synced ? const Color(0xFF166534) : const Color(0xFF7C4400),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// PATIENT CARD
// ─────────────────────────────────────────────────────────
class PatientCard extends StatelessWidget {
  final Map<String, dynamic> patient;
  final VoidCallback? onTap;

  const PatientCard({super.key, required this.patient, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppTheme.primaryFixed,
                child: Text(
                  patient['name'].toString().substring(0, 1),
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 20,
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            patient['name'],
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.onSurface,
                            ),
                          ),
                        ),
                        RiskBadge(risk: patient['risk'], small: true),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${patient['gestationalAge']} • ${patient['age']} yrs • G${patient['gravida']}P${patient['para']}',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 13,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        SyncBadge(synced: patient['synced']),
                        const SizedBox(width: 8),
                        Text(
                          'Last visit: ${patient['lastVisit']}',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 11,
                            color: AppTheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.outline,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// DASHBOARD STAT CARD
// ─────────────────────────────────────────────────────────
class DashboardStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback? onTap;

  const DashboardStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.bgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: GoogleFonts.beVietnamPro(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// VITAL CARD
// ─────────────────────────────────────────────────────────
class VitalCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final bool isAlert;

  const VitalCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isAlert
            ? AppTheme.errorContainer.withValues(alpha: 0.5)
            : AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAlert
              ? AppTheme.error.withValues(alpha: 0.3)
              : AppTheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: isAlert ? AppTheme.error : color, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ),
              if (isAlert)
                const Icon(Icons.warning_amber_rounded,
                    size: 14, color: AppTheme.error),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isAlert ? AppTheme.error : AppTheme.onSurface,
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 11,
                    color: AppTheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.beVietnamPro(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
              ),
            ),
          ),
          if (action != null)
            TextButton(
              onPressed: onAction,
              child: Text(
                action!,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// HISTORY CARD
// ─────────────────────────────────────────────────────────
class HistoryCard extends StatelessWidget {
  final Map<String, dynamic> event;
  final VoidCallback? onTap;

  const HistoryCard({super.key, required this.event, this.onTap});

  Color get _iconBgColor {
    switch (event['riskLevel']?.toString().toLowerCase()) {
      case 'high':
        return const Color(0xFFFFDAD6);
      case 'medium':
        return const Color(0xFFFFEDD5);
      case 'low':
        return const Color(0xFFDCFCE7);
      default:
        return AppTheme.primaryFixed;
    }
  }

  Color get _iconColor {
    switch (event['riskLevel']?.toString().toLowerCase()) {
      case 'high':
        return const Color(0xFF93000A);
      case 'medium':
        return const Color(0xFF7C4400);
      case 'low':
        return const Color(0xFF166534);
      default:
        return AppTheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.medical_services_rounded,
                color: _iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          event['title'],
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.onSurface,
                          ),
                        ),
                      ),
                      if (event['riskLevel'] != null)
                        RiskBadge(risk: event['riskLevel'], small: true),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event['description'],
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event['date'],
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 11,
                      color: AppTheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// REPORT CARD
// ─────────────────────────────────────────────────────────
class ReportCard extends StatelessWidget {
  final Map<String, dynamic> report;
  final VoidCallback? onTap;

  const ReportCard({super.key, required this.report, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primaryFixed,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.description_rounded,
                  color: AppTheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            report['patientName'],
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.onSurface,
                            ),
                          ),
                        ),
                        RiskBadge(risk: report['riskLevel'], small: true),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      report['type'],
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 13,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      report['date'],
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 11,
                        color: AppTheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.outline,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// PROFILE TILE
// ─────────────────────────────────────────────────────────
class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? iconColor;

  const ProfileTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (iconColor ?? AppTheme.primary).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: iconColor ?? AppTheme.primary,
          size: 20,
        ),
      ),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing:
          onTap != null ? const Icon(Icons.chevron_right_rounded, size: 18) : null,
      onTap: onTap,
    );
  }
}

// ─────────────────────────────────────────────────────────
// SETTING TILE
// ─────────────────────────────────────────────────────────
class SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.onSurfaceVariant, size: 18),
      ),
      title: Text(
        title,
        style: GoogleFonts.beVietnamPro(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppTheme.onSurface,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                color: AppTheme.onSurfaceVariant,
              ),
            )
          : null,
      trailing: trailing ??
          (onTap != null
              ? const Icon(Icons.chevron_right_rounded,
                  size: 18, color: AppTheme.outline)
              : null),
      onTap: onTap,
    );
  }
}

// ─────────────────────────────────────────────────────────
// EMPTY STATE WIDGET
// ─────────────────────────────────────────────────────────
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.buttonLabel,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.primaryFixed,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Icon(icon, size: 52, color: AppTheme.primary),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: GoogleFonts.beVietnamPro(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: GoogleFonts.beVietnamPro(
                fontSize: 14,
                color: AppTheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (buttonLabel != null && onButtonPressed != null) ...[
              const SizedBox(height: 32),
              PrimaryButton(label: buttonLabel!, onPressed: onButtonPressed),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// FORM SECTION
// ─────────────────────────────────────────────────────────
class FormSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const FormSection({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            title,
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// APP BOTTOM NAV BAR
// ─────────────────────────────────────────────────────────
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.people_outlined),
          selectedIcon: Icon(Icons.people_rounded),
          label: 'Patients',
        ),
        NavigationDestination(
          icon: Icon(Icons.assignment_outlined),
          selectedIcon: Icon(Icons.assignment_rounded),
          label: 'Reports',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outlined),
          selectedIcon: Icon(Icons.person_rounded),
          label: 'Profile',
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// SCREENING CARD
// ─────────────────────────────────────────────────────────
class ScreeningCard extends StatelessWidget {
  final Map<String, dynamic> screening;
  final VoidCallback? onTap;

  const ScreeningCard({super.key, required this.screening, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      screening['patientName'],
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurface,
                      ),
                    ),
                  ),
                  RiskBadge(risk: screening['riskLevel'], small: true),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.calendar_today_rounded,
                      size: 13, color: AppTheme.outline),
                  const SizedBox(width: 4),
                  Text(
                    screening['date'],
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 12, color: AppTheme.outline),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.medical_services_rounded,
                      size: 13, color: AppTheme.outline),
                  const SizedBox(width: 4),
                  Text(
                    screening['type'],
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 12, color: AppTheme.outline),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.psychology_rounded,
                        size: 14, color: AppTheme.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'AI Score: ${screening['aiScore']}%',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded,
                        size: 16, color: AppTheme.outline),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
