import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/app/theme/app_theme.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About MaternalCare'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // App branding
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryFixed, Color(0xFFFFD9E4)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryContainer,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.3),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: AppTheme.onPrimaryContainer,
                      size: 42,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'MaternalCare',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primary,
                    ),
                  ),
                  Text(
                    'Maternal Health AI',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 14,
                      color: AppTheme.onSurfaceVariant,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      'Version 1.0.0 (Build 1)',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Mission
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.flag_rounded,
                            color: AppTheme.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Our Mission',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'MaternalCare uses AI to help community health workers identify high-risk pregnancies early, improving maternal and child health outcomes across underserved communities.',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 14,
                        color: AppTheme.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Features
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Key Features',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...[
                      ('AI Risk Assessment', Icons.psychology_rounded,
                          AppTheme.primary),
                      ('Offline-First Design', Icons.wifi_off_rounded,
                          AppTheme.secondary),
                      ('Patient Management', Icons.people_rounded,
                          AppTheme.tertiary),
                      ('Automated Reports', Icons.description_rounded,
                          const Color(0xFF7C4400)),
                      ('Secure & Private', Icons.security_rounded,
                          AppTheme.primary),
                    ].map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: item.$3.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(item.$2,
                                    color: item.$3, size: 18),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                item.$1,
                                style: GoogleFonts.beVietnamPro(
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Legal
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined,
                        color: AppTheme.outline),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.chevron_right_rounded,
                        size: 18),
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 16),
                  ListTile(
                    leading: const Icon(Icons.gavel_rounded,
                        color: AppTheme.outline),
                    title: const Text('Terms of Service'),
                    trailing: const Icon(Icons.chevron_right_rounded,
                        size: 18),
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 16),
                  ListTile(
                    leading: const Icon(Icons.article_rounded,
                        color: AppTheme.outline),
                    title: const Text('Open Source Licenses'),
                    trailing: const Icon(Icons.chevron_right_rounded,
                        size: 18),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '© 2026 MaternalCare. All rights reserved.',
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                color: AppTheme.outline,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
