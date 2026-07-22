import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/app/theme/app_theme.dart';
import 'package:new_app/app/constants/dummy_data.dart';
import 'package:new_app/core/widgets/common_widgets.dart';
import 'package:new_app/features/patients/data/models/patient_model.dart';
import 'package:new_app/features/patients/data/repositories/patient_repository.dart';

class PatientListPage extends StatefulWidget {
  const PatientListPage({super.key});

  @override
  State<PatientListPage> createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterRisk = 'All';
  bool _isLoading = true;
  List<PatientModel> _allPatients = [];

  final List<String> _riskFilters = ['All', 'High', 'Medium', 'Low', 'Normal'];

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    setState(() => _isLoading = true);
    try {
      final patients = await PatientRepository.getPatients();
      setState(() {
        _allPatients = patients;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading patients: $e');
      setState(() => _isLoading = false);
    }
  }

  List<PatientModel> get _filteredPatients {
    return _allPatients.where((p) {
      final matchSearch = p.name
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final riskVal = p.risk.isNotEmpty ? p.risk : 'Normal';
      final matchRisk = _filterRisk == 'All' || 
          riskVal.toLowerCase() == _filterRisk.toLowerCase();
      return matchSearch && matchRisk;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => context.push('/patients/search'),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/patients/add');
          _loadPatients();
        },
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Add Patient'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
            ),
          ),
          // Risk filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _riskFilters.map((risk) {
                final isSelected = _filterRisk == risk;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(risk),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _filterRisk = risk),
                    backgroundColor: AppTheme.surfaceContainer,
                    selectedColor: AppTheme.primaryFixed,
                    checkmarkColor: AppTheme.primary,
                    labelStyle: GoogleFonts.beVietnamPro(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? AppTheme.primary : AppTheme.onSurfaceVariant,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          // Count badge
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  '${_filteredPatients.length} patient${_filteredPatients.length != 1 ? 's' : ''}',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // Patient list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredPatients.isEmpty
                    ? EmptyStateWidget(
                        icon: Icons.people_outlined,
                        title: 'No Patients Found',
                        subtitle: 'Try adjusting your search or add a new patient.',
                        buttonLabel: 'Add Patient',
                        onButtonPressed: () async {
                          await context.push('/patients/add');
                          _loadPatients();
                        },
                      )
                    : ListView.builder(
                        itemCount: _filteredPatients.length,
                        itemBuilder: (context, index) {
                          final patient = _filteredPatients[index];
                          
                          // Convert PatientModel to the Map format PatientCard expects for now
                          final displayPatient = {
                            'id': patient.patientId,
                            'name': patient.name,
                            'age': patient.age,
                            'risk': patient.risk.isNotEmpty ? patient.risk : 'Normal',
                            'contact': patient.contact,
                            'village': patient.village,
                            'trimester': patient.trimester,
                            'weeks': patient.pregnancyWeek,
                            'synced': true, // Assuming it's synced if it's from backend
                            'gestationalAge': '${patient.pregnancyWeek} weeks',
                            'gravida': patient.gravida,
                            'para': '0', // Not in PatientModel yet, dummy value
                            'lastVisit': 'Just now', // Not in PatientModel yet, dummy value
                          };

                          return PatientCard(
                            patient: displayPatient,
                            onTap: () async {
                              await context.push('/patients/${patient.patientId}');
                              _loadPatients(); // Refresh in case data changed
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
