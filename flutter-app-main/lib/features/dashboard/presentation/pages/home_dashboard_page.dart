import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/app/theme/app_theme.dart';
import 'package:new_app/app/constants/dummy_data.dart';
import 'package:new_app/core/widgets/common_widgets.dart';
import 'package:new_app/features/patients/data/models/patient_model.dart';
import 'package:new_app/features/patients/data/repositories/patient_repository.dart';

class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({super.key});

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  int _navIndex = 0;
  bool _isLoading = true;
  List<PatientModel> _patients = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final patients = await PatientRepository.getPatients();
      if (mounted) {
        setState(() {
          _patients = patients;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onNavTap(int index) {
    setState(() => _navIndex = index);
    switch (index) {
      case 0:
        break;
      case 1:
        context.push('/patients');
      case 2:
        context.push('/reports');
      case 3:
        context.push('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final totalPatients = _patients.length;
    final highRiskCount = _patients.where((p) => p.risk.toLowerCase() == 'high').length;
    
    // We still keep screenings dummy data as backend doesn't have it yet
    final stats = DummyData.dashboardStats;
    final screenings = DummyData.screenings;
    final user = DummyData.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.background,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _navIndex,
        onDestinationSelected: _onNavTap,
      ),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.surfaceContainerLowest,
            elevation: 0,
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
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.2),
                              child: Text(
                                user['name'].toString().isNotEmpty ? user['name'].toString().substring(0, 1).toUpperCase() : 'A',
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Good morning 👋',
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 13,
                                      color: Colors.white.withValues(alpha: 0.8),
                                    ),
                                  ),
                                  Text(
                                    user['name'],
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.notifications_outlined,
                                  color: Colors.white),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              'Dashboard',
              style: GoogleFonts.beVietnamPro(
                  fontWeight: FontWeight.w700, color: AppTheme.onSurface),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Search bar
                GestureDetector(
                  onTap: () => context.push('/patients/search'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: AppTheme.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded,
                            color: AppTheme.outline),
                        const SizedBox(width: 10),
                        Text(
                          'Search patients...',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 15,
                            color: AppTheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Stats section
                SectionHeader(title: 'Overview'),
                const SizedBox(height: 8),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.2,
                  children: [
                    DashboardStatCard(
                      title: 'Total Patients',
                      value: totalPatients.toString(),
                      icon: Icons.people_rounded,
                      color: AppTheme.primary,
                      bgColor: AppTheme.primaryFixed,
                      onTap: () => context.push('/patients'),
                    ),
                    DashboardStatCard(
                      title: 'High Risk',
                      value: highRiskCount.toString(),
                      icon: Icons.warning_rounded,
                      color: const Color(0xFF93000A),
                      bgColor: const Color(0xFFFFDAD6),
                      onTap: () => context.push('/patients'),
                    ),
                    DashboardStatCard(
                      title: "Today's Screenings",
                      value: stats['screeningsToday'].toString(),
                      icon: Icons.medical_services_rounded,
                      color: AppTheme.tertiary,
                      bgColor: const Color(0xFFDCFCE7),
                      onTap: () {},
                    ),
                    DashboardStatCard(
                      title: 'Pending Sync',
                      value: stats['pendingSync'].toString(),
                      icon: Icons.sync_rounded,
                      color: const Color(0xFF7C4400),
                      bgColor: const Color(0xFFFFEDD5),
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Quick Actions
                SectionHeader(title: 'Quick Actions'),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _QuickActionChip(
                        icon: Icons.person_add_rounded,
                        label: 'Add Patient',
                        color: AppTheme.primary,
                        onTap: () => context.push('/patients/add'),
                      ),
                      const SizedBox(width: 8),
                      _QuickActionChip(
                        icon: Icons.medical_services_rounded,
                        label: 'Start Screening',
                        color: AppTheme.secondary,
                        onTap: () => context.push('/patients'),
                      ),
                      const SizedBox(width: 8),
                      _QuickActionChip(
                        icon: Icons.description_rounded,
                        label: 'View Reports',
                        color: AppTheme.tertiary,
                        onTap: () => context.push('/reports'),
                      ),
                      const SizedBox(width: 8),
                      _QuickActionChip(
                        icon: Icons.sync_rounded,
                        label: 'Sync Data',
                        color: const Color(0xFF7C4400),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Recent Patients
                SectionHeader(
                  title: 'Recent Patients',
                  action: 'See all',
                  onAction: () => context.push('/patients'),
                ),
              ]),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= _patients.take(3).length) return null;
                final pModel = _patients[index];
                
                final displayPatient = {
                  'id': pModel.patientId,
                  'name': pModel.name,
                  'age': pModel.age,
                  'risk': pModel.risk.isNotEmpty ? pModel.risk : 'Normal',
                  'gestationalAge': '${pModel.pregnancyWeek} weeks',
                  'gravida': pModel.gravida,
                  'para': '0',
                  'synced': true,
                  'lastVisit': 'Just now',
                };

                return PatientCard(
                  patient: displayPatient,
                  onTap: () =>
                      context.push('/patients/${pModel.patientId}'),
                );
              },
              childCount: _patients.take(3).length,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 4),
                // Recent Screenings
                SectionHeader(
                  title: 'Recent Screenings',
                  action: 'See all',
                  onAction: () {},
                ),
              ]),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= screenings.take(2).length) return null;
                final screening = screenings[index];
                return ScreeningCard(
                  screening: screening,
                  onTap: () => context.push(
                      '/screening/details/${screening['id']}'),
                );
              },
              childCount: 2,
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
        ],
      ),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.beVietnamPro(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
