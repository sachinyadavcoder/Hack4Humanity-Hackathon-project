import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/app/theme/app_theme.dart';
import 'package:new_app/core/widgets/common_widgets.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = const [
    _OnboardingData(
      icon: Icons.analytics_rounded,
      bgIcon: Icons.pregnant_woman_rounded,
      title: 'Track Pregnancy Effortlessly',
      description:
          'Manage patient records and screenings in one place. Reliable care, organized for health workers.',
      accentIcon: Icons.analytics_rounded,
      accentIcon2: Icons.favorite_rounded,
    ),
    _OnboardingData(
      icon: Icons.psychology_rounded,
      bgIcon: Icons.health_and_safety_rounded,
      title: 'AI-Powered Risk Assessment',
      description:
          'Advanced machine learning analyzes maternal health data to identify high-risk pregnancies early and accurately.',
      accentIcon: Icons.psychology_rounded,
      accentIcon2: Icons.shield_rounded,
    ),
    _OnboardingData(
      icon: Icons.cloud_sync_rounded,
      bgIcon: Icons.medical_services_rounded,
      title: 'Work Offline, Sync Anytime',
      description:
          'Record screenings without internet. Data syncs automatically when connectivity is restored — no data lost.',
      accentIcon: Icons.cloud_sync_rounded,
      accentIcon2: Icons.wifi_off_rounded,
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background blobs
          Positioned(
            top: -80,
            left: -80,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: AppTheme.secondary.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'MaternalCare',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: Text(
                          'Skip',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Page content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemCount: _pages.length,
                    itemBuilder: (context, index) =>
                        _OnboardingPageContent(data: _pages[index]),
                  ),
                ),
                // Footer
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  child: Column(
                    children: [
                      // Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_pages.length, (i) {
                          final isActive = i == _currentPage;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: isActive ? 28 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppTheme.primary
                                  : AppTheme.outlineVariant,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),
                      // Next button
                      PrimaryButton(
                        label: _currentPage == _pages.length - 1
                            ? 'Get Started'
                            : 'Next',
                        icon: Icons.arrow_forward_rounded,
                        onPressed: _nextPage,
                      ),
                    ],
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

class _OnboardingData {
  final IconData icon;
  final IconData bgIcon;
  final String title;
  final String description;
  final IconData accentIcon;
  final IconData accentIcon2;

  const _OnboardingData({
    required this.icon,
    required this.bgIcon,
    required this.title,
    required this.description,
    required this.accentIcon,
    required this.accentIcon2,
  });
}

class _OnboardingPageContent extends StatelessWidget {
  final _OnboardingData data;

  const _OnboardingPageContent({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                          color: AppTheme.outlineVariant.withValues(alpha: 0.5)),
                    ),
                    child: Icon(
                      data.bgIcon,
                      size: 160,
                      color: AppTheme.primaryFixed,
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: _FloatingIconCard(icon: data.accentIcon),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 20,
                    child: _FloatingIconCard(
                      icon: data.accentIcon2,
                      color: AppTheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            data.title,
            style: GoogleFonts.beVietnamPro(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            data.description,
            style: GoogleFonts.beVietnamPro(
              fontSize: 15,
              color: AppTheme.onSurfaceVariant,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _FloatingIconCard extends StatefulWidget {
  final IconData icon;
  final Color? color;

  const _FloatingIconCard({required this.icon, this.color});

  @override
  State<_FloatingIconCard> createState() => _FloatingIconCardState();
}

class _FloatingIconCardState extends State<_FloatingIconCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppTheme.primary;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _animation.value),
        child: child,
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(widget.icon, color: color, size: 22),
      ),
    );
  }
}
