import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/app/theme/app_theme.dart';
import 'package:new_app/core/widgets/common_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE3DFFF), AppTheme.background],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Brand header
                Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryContainer,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withValues(alpha: 0.25),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: AppTheme.onPrimaryContainer,
                        size: 38,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'MaternalCare',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Secured health portal for mothers and care workers.',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 14,
                        color: AppTheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 36),
                // Login card
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                        color: AppTheme.outlineVariant.withValues(alpha: 0.4)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sign in to your account',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 14,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Phone field
                      Text(
                        'Phone Number',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Enter registered number',
                          prefixIcon: Icon(Icons.call_rounded, size: 20),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Password field
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Password',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.onSurfaceVariant,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.push('/forgot-password'),
                            child: Text(
                              'Forgot Password?',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_rounded, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20,
                              color: AppTheme.outline,
                            ),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Login button
                      PrimaryButton(
                        label: 'Login',
                        icon: Icons.arrow_forward_rounded,
                        onPressed: () => context.go('/dashboard'),
                      ),
                      const SizedBox(height: 16),
                      // Divider
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'or',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 12,
                                color: AppTheme.outline,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Touch ID button
                      Center(
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.fingerprint_rounded,
                              color: AppTheme.primary),
                          label: Text(
                            'Quick Login with Touch ID',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Register link
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 14, color: AppTheme.onSurfaceVariant),
                    children: [
                      const TextSpan(text: 'New to MaternalCare? '),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Register Now',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.secondary,
                              decoration: TextDecoration.underline,
                              decorationColor: AppTheme.secondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Support banner
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.surfaceContainerHigh.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                        color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppTheme.tertiaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.support_agent_rounded,
                          size: 16,
                          color: AppTheme.onTertiaryContainer,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Need help? Contact local health worker',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 12,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
