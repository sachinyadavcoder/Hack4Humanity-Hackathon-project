import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/app/theme/app_theme.dart';
import 'package:new_app/app/constants/dummy_data.dart';
import 'package:new_app/core/widgets/common_widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _navIndex = 3;

  void _onNavTap(int index) {
    setState(() => _navIndex = index);
    switch (index) {
      case 0:
        context.go('/dashboard');
      case 1:
        context.push('/patients');
      case 2:
        context.push('/reports');
      case 3:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = DummyData.currentUser;
    return Scaffold(
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _navIndex,
        onDestinationSelected: _onNavTap,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            title: const Text('Profile'),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.primary, AppTheme.primaryContainer],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          child: Text(
                            'N',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                user['name'],
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                user['role'],
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 13,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                              Text(
                                user['facility'],
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Stats cards
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          label: 'Patients',
                          value: user['totalPatients'].toString(),
                          icon: Icons.people_rounded,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          label: 'Screenings',
                          value: user['totalScreenings'].toString(),
                          icon: Icons.medical_services_rounded,
                          color: AppTheme.secondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          label: 'High Risk',
                          value: user['highRiskCount'].toString(),
                          icon: Icons.warning_rounded,
                          color: AppTheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Account info
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    child: Column(
                      children: [
                        ProfileTile(
                          icon: Icons.badge_rounded,
                          title: 'Staff ID',
                          subtitle: user['staffId'],
                        ),
                        const Divider(height: 1, indent: 16),
                        ProfileTile(
                          icon: Icons.phone_rounded,
                          title: 'Phone',
                          subtitle: user['phone'],
                        ),
                        const Divider(height: 1, indent: 16),
                        ProfileTile(
                          icon: Icons.email_rounded,
                          title: 'Email',
                          subtitle: user['email'],
                        ),
                        const Divider(height: 1, indent: 16),
                        ProfileTile(
                          icon: Icons.location_on_rounded,
                          title: 'LGA',
                          subtitle: '${user['lga']}, ${user['state']}',
                        ),
                      ],
                    ),
                  ),
                ),
                // Options
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    child: Column(
                      children: [
                        ProfileTile(
                          icon: Icons.settings_rounded,
                          title: 'Settings',
                          onTap: () => context.push('/settings'),
                        ),
                        const Divider(height: 1, indent: 16),
                        ProfileTile(
                          icon: Icons.info_rounded,
                          title: 'About MaternalCare',
                          onTap: () => context.push('/about'),
                        ),
                        const Divider(height: 1, indent: 16),
                        ProfileTile(
                          icon: Icons.wifi_off_rounded,
                          title: 'Test Offline Mode',
                          onTap: () => context.push('/no-internet'),
                        ),
                        const Divider(height: 1, indent: 16),
                        ProfileTile(
                          icon: Icons.logout_rounded,
                          title: 'Sign Out',
                          iconColor: AppTheme.error,
                          onTap: () => _showLogoutDialog(context),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Sign Out',
          style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to sign out? Make sure all data is synced before leaving.',
          style: GoogleFonts.beVietnamPro(color: AppTheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => context.go('/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.beVietnamPro(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.beVietnamPro(
              fontSize: 11,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
