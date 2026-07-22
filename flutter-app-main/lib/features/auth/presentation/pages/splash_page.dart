import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/app/theme/app_theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      if (mounted) context.go('/onboarding');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.5,
            colors: [
              Color(0xFFE3DFFF),
              AppTheme.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo & Title
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 60),
                        child: Column(
                          children: [
                            ScaleTransition(
                              scale: _scaleAnimation,
                              child: Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primary
                                          .withValues(alpha: 0.3),
                                      blurRadius: 24,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.favorite_rounded,
                                  color: AppTheme.onPrimaryContainer,
                                  size: 48,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'MaternalCare',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'MATERNAL HEALTH AI',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.onSurfaceVariant,
                                letterSpacing: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Illustration
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.surfaceContainerLowest,
                          border: Border.all(
                              color: AppTheme.outlineVariant, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withValues(alpha: 0.1),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.pregnant_woman_rounded,
                              size: 140,
                              color: AppTheme.primaryFixed,
                            ),
                            Positioned(
                              bottom: 20,
                              right: 20,
                              child: _FloatingChip(
                                icon: Icons.favorite_rounded,
                                label: 'Healthy Heartbeat',
                                color: AppTheme.tertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Loading & Tagline
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 48),
                        child: Column(
                          children: [
                            const _LoadingBar(),
                            const SizedBox(height: 16),
                            Text(
                              'Personalized care for every stage',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 14,
                                color: AppTheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Powering better outcomes through AI',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 12,
                                color: AppTheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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

class _LoadingBar extends StatefulWidget {
  const _LoadingBar();

  @override
  State<_LoadingBar> createState() => _LoadingBarState();
}

class _LoadingBarState extends State<_LoadingBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: LinearProgressIndicator(
          backgroundColor: AppTheme.surfaceContainerHigh,
          color: AppTheme.primary,
        ),
      ),
    );
  }
}

class _FloatingChip extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _FloatingChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  State<_FloatingChip> createState() => _FloatingChipState();
}

class _FloatingChipState extends State<_FloatingChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _bounceAnimation = Tween<double>(begin: 0, end: -8).animate(
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
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceAnimation.value),
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, size: 14, color: AppTheme.onTertiaryContainer),
            const SizedBox(width: 4),
            Text(
              widget.label,
              style: GoogleFonts.beVietnamPro(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.onTertiaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
