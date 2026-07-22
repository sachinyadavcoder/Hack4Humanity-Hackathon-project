import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/app/theme/app_theme.dart';
import 'package:new_app/core/widgets/common_widgets.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _phoneController = TextEditingController();
  bool _otpSent = false;
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Forgot Password'),
      ),
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
                const SizedBox(height: 20),
                // Illustration
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryFixed,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const Icon(
                    Icons.lock_reset_rounded,
                    size: 64,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Reset Your Password',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _otpSent
                      ? 'Enter the OTP sent to your phone number to reset your password.'
                      : 'Enter your registered phone number and we\'ll send you an OTP.',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 14,
                    color: AppTheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppTheme.outlineVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          hintText: '+234 800 000 0000',
                          prefixIcon: Icon(Icons.call_rounded, size: 20),
                        ),
                      ),
                      if (_otpSent) ...[
                        const SizedBox(height: 16),
                        Text(
                          'One-Time Password',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: '000000',
                            prefixIcon: Icon(Icons.pin_rounded, size: 20),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: _otpSent ? 'Verify & Reset' : 'Send OTP',
                        icon: _otpSent
                            ? Icons.check_rounded
                            : Icons.send_rounded,
                        onPressed: () {
                          if (_otpSent) {
                            context.go('/login');
                          } else {
                            setState(() => _otpSent = true);
                          }
                        },
                      ),
                      if (_otpSent) ...[
                        const SizedBox(height: 12),
                        Center(
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Resend OTP',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 14,
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(
                    'Back to Login',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 14,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
