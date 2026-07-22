import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/app/theme/app_theme.dart';
import 'package:new_app/app/constants/dummy_data.dart';
import 'package:new_app/core/widgets/common_widgets.dart';
import 'package:new_app/features/patients/data/repositories/patient_repository.dart';
import 'package:new_app/features/patients/data/models/patient_model.dart';

class PatientDetailsPage extends StatefulWidget {
  final String patientId;

  const PatientDetailsPage({super.key, required this.patientId});

  @override
  State<PatientDetailsPage> createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  PatientModel? patient;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPatient();
  }

  Future<void> _loadPatient() async {
    try {
      final PatientModel pModel = await PatientRepository.getPatientById(widget.patientId);
      
      setState(() {
        patient = pModel;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    if (_error != null || patient == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Could not load patient: $_error')),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              expandedHeight: 220,
              pinned: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/dashboard');
                  }
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit_rounded),
                  onPressed: () =>
                      context.push('/patients/${widget.patientId}/edit'),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert_rounded),
                  onPressed: () {},
                ),
              ],
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundColor:
                                    Colors.white.withValues(alpha: 0.25),
                                child: Text(
                                  patient!.name.isEmpty ? '?' : patient!.name.substring(0, 1).toUpperCase(),
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      patient!.name,
                                      style: GoogleFonts.beVietnamPro(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${patient!.age} yrs • ${patient!.pregnancyWeek} weeks',
                                      style: GoogleFonts.beVietnamPro(
                                        fontSize: 14,
                                        color: Colors.white
                                            .withValues(alpha: 0.8),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        RiskBadge(risk: patient!.risk.isNotEmpty ? patient!.risk : 'Normal'),
                                        const SizedBox(width: 8),
                                        SyncBadge(synced: true),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Overview'),
                  Tab(text: 'Vitals'),
                  Tab(text: 'History'),
                ],
                indicatorColor: AppTheme.primary,
                labelColor: AppTheme.primary,
                unselectedLabelColor: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
          body: TabBarView(
            children: [
              _OverviewTab(patient: patient!, patientId: widget.patientId),
              _VitalsTab(patient: patient!),
              _HistoryTab(patient: patient!, patientId: widget.patientId),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () =>
              context.push('/screening/start/${widget.patientId}'),
          icon: const Icon(Icons.medical_services_rounded),
          label: const Text('Start Screening'),
          backgroundColor: AppTheme.secondary,
          foregroundColor: AppTheme.onSecondary,
        ),
      ),
    );
  }
}

// ─── Overview Tab ───────────────────────────────────────
class _OverviewTab extends StatelessWidget {
  final PatientModel patient;
  final String patientId;

  const _OverviewTab({required this.patient, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Info card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _InfoRow(label: 'Patient ID', value: patient.patientId),
                _InfoRow(label: 'Phone', value: patient.contact),
                _InfoRow(label: 'Gravida', value: patient.gravida),
                _InfoRow(label: 'Blood Type', value: patient.bloodGroup),
                _InfoRow(label: 'Address', value: patient.village, isLast: true),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Appointments
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appointments',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  label: 'Last Visit',
                  value: patient.lastVisit != null 
                    ? '${patient.lastVisit!.day}/${patient.lastVisit!.month}/${patient.lastVisit!.year}' 
                    : 'No previous visits',
                ),
                _InfoRow(
                  label: 'Next Visit',
                  value: 'Not scheduled',
                  isLast: true,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Quick actions
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.history_rounded, size: 18),
                label: const Text('History'),
                onPressed: () =>
                    context.push('/patients/$patientId/history'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.dashboard_rounded, size: 18),
                label: const Text('Dashboard'),
                onPressed: () =>
                    context.push('/patients/$patientId/dashboard'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}

// ─── Vitals Tab ─────────────────────────────────────────
class _VitalsTab extends StatelessWidget {
  final PatientModel patient;

  const _VitalsTab({required this.patient});

  @override
  Widget build(BuildContext context) {
    final vitals = patient.vitals;
    if (vitals == null || (vitals.bp.isEmpty && vitals.weight.isEmpty && vitals.hemoglobin.isEmpty)) {
      return const Center(child: Text('No vitals recorded'));
    }

    bool hemoglobinAlert = false;
    if (vitals.hemoglobin.isNotEmpty) {
      final val = double.tryParse(vitals.hemoglobin.split(' ').first);
      if (val != null && val < 10) hemoglobinAlert = true;
    }

    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        VitalCard(
          label: 'Blood Pressure',
          value: vitals.bp.isNotEmpty ? vitals.bp : '-',
          unit: 'mmHg',
          icon: Icons.monitor_heart_rounded,
          color: AppTheme.primary,
          isAlert: patient.risk == 'High',
        ),
        VitalCard(
          label: 'Weight',
          value: vitals.weight.isNotEmpty ? vitals.weight.split(' ').first : '-',
          unit: 'kg',
          icon: Icons.monitor_weight_rounded,
          color: AppTheme.primary,
        ),
        VitalCard(
          label: 'Hemoglobin',
          value: vitals.hemoglobin.isNotEmpty ? vitals.hemoglobin.split(' ').first : '-',
          unit: 'g/dL',
          icon: Icons.bloodtype_rounded,
          color: const Color(0xFF7C4400),
          isAlert: hemoglobinAlert,
        ),
        VitalCard(
          label: 'Sugar',
          value: vitals.sugar.isNotEmpty ? vitals.sugar.split(' ').first : '-',
          unit: 'mg/dL',
          icon: Icons.water_drop_rounded,
          color: AppTheme.tertiary,
        ),
        if (vitals.ultrasoundSummary.isNotEmpty) 
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ultrasound', style: GoogleFonts.beVietnamPro(fontSize: 12, color: AppTheme.onSurfaceVariant)),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      vitals.ultrasoundSummary, 
                      style: GoogleFonts.beVietnamPro(fontSize: 14, fontWeight: FontWeight.bold),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }
}

// ─── History Tab ────────────────────────────────────────
class _HistoryTab extends StatelessWidget {
  final PatientModel patient;
  final String patientId;

  const _HistoryTab({required this.patient, required this.patientId});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> combinedHistory = [];
    
    for (var visit in patient.previousVisits) {
       combinedHistory.add({
          'date': visit.date != null ? '${visit.date!.day}/${visit.date!.month}/${visit.date!.year}' : 'Unknown Date',
          'title': 'Visit',
          'description': visit.notes.isNotEmpty ? visit.notes : 'BP: ${visit.bp}, Wt: ${visit.weight}',
          'type': 'screening',
          'doctor': patient.ashaWorker ?? 'Unknown',
       });
    }
    
    for (var report in patient.reports) {
       combinedHistory.add({
          'date': report.date != null ? '${report.date!.day}/${report.date!.month}/${report.date!.year}' : 'Unknown Date',
          'title': '${report.type} Report',
          'description': report.fileName,
          'type': 'lab',
          'doctor': 'Lab',
       });
    }

    if (combinedHistory.isEmpty) {
      return const Center(child: Text('No history available'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: combinedHistory.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 16),
      itemBuilder: (context, index) {
        return HistoryCard(
          event: combinedHistory[index],
          onTap: () {},
        );
      },
    );
  }
}

// ─── Helper Widget ──────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  label,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }
}
