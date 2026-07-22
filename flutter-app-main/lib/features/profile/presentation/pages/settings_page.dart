import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/app/theme/app_theme.dart';
import 'package:new_app/core/widgets/common_widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _offlineMode = false;
  bool _autoSync = true;
  bool _biometricLogin = true;
  bool _darkMode = false;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account
          _SettingsGroup(
            title: 'Account',
            children: [
              SettingTile(
                icon: Icons.person_rounded,
                title: 'Edit Profile',
                subtitle: 'Update your personal information',
                onTap: () {},
              ),
              SettingTile(
                icon: Icons.lock_rounded,
                title: 'Change Password',
                onTap: () {},
              ),
              SettingTile(
                icon: Icons.badge_rounded,
                title: 'Staff Credentials',
                subtitle: 'View facility and role info',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Notifications
          _SettingsGroup(
            title: 'Notifications',
            children: [
              SettingTile(
                icon: Icons.notifications_rounded,
                title: 'Push Notifications',
                subtitle: 'Receive alerts and reminders',
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: (v) =>
                      setState(() => _notificationsEnabled = v),
                  activeThumbColor: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Sync & Storage
          _SettingsGroup(
            title: 'Sync & Storage',
            children: [
              SettingTile(
                icon: Icons.cloud_sync_rounded,
                title: 'Auto-Sync',
                subtitle: 'Sync data when connected',
                trailing: Switch(
                  value: _autoSync,
                  onChanged: (v) => setState(() => _autoSync = v),
                  activeThumbColor: AppTheme.primary,
                ),
              ),
              SettingTile(
                icon: Icons.wifi_off_rounded,
                title: 'Offline Mode',
                subtitle: 'Store data locally when offline',
                trailing: Switch(
                  value: _offlineMode,
                  onChanged: (v) => setState(() => _offlineMode = v),
                  activeThumbColor: AppTheme.primary,
                ),
              ),
              SettingTile(
                icon: Icons.sync_rounded,
                title: 'Sync Now',
                subtitle: '2 items pending',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Security
          _SettingsGroup(
            title: 'Security',
            children: [
              SettingTile(
                icon: Icons.fingerprint_rounded,
                title: 'Biometric Login',
                subtitle: 'Use fingerprint to login',
                trailing: Switch(
                  value: _biometricLogin,
                  onChanged: (v) => setState(() => _biometricLogin = v),
                  activeThumbColor: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Appearance
          _SettingsGroup(
            title: 'Appearance',
            children: [
              SettingTile(
                icon: Icons.dark_mode_rounded,
                title: 'Dark Mode',
                trailing: Switch(
                  value: _darkMode,
                  onChanged: (v) => setState(() => _darkMode = v),
                  activeThumbColor: AppTheme.primary,
                ),
              ),
              SettingTile(
                icon: Icons.language_rounded,
                title: 'Language',
                subtitle: _language,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Data & Privacy
          _SettingsGroup(
            title: 'Data & Privacy',
            children: [
              SettingTile(
                icon: Icons.privacy_tip_rounded,
                title: 'Privacy Policy',
                onTap: () {},
              ),
              SettingTile(
                icon: Icons.delete_forever_rounded,
                title: 'Clear Local Cache',
                subtitle: 'Free up storage space',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'MaternalCare v1.0.0',
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                color: AppTheme.outline,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsGroup({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: GoogleFonts.beVietnamPro(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
              letterSpacing: 1,
            ),
          ),
        ),
        Card(
          child: Column(
            children: List.generate(children.length, (i) {
              return Column(
                children: [
                  children[i],
                  if (i < children.length - 1)
                    const Divider(height: 1, indent: 16),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
