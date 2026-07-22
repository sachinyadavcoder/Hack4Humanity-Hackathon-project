import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/app/theme/app_theme.dart';
import 'package:new_app/core/widgets/common_widgets.dart';
import 'package:new_app/features/patients/data/repositories/patient_repository.dart';
import 'package:new_app/features/patients/data/models/patient_model.dart';

class EditPatientPage extends StatefulWidget {
  final String patientId;

  const EditPatientPage({super.key, required this.patientId});

  @override
  State<EditPatientPage> createState() => _EditPatientPageState();
}

class _EditPatientPageState extends State<EditPatientPage> {
  PatientModel? _patient;
  bool _isLoading = true;
  String? _error;
  
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _loadPatient();
  }

  Future<void> _loadPatient() async {
    try {
      final patient = await PatientRepository.getPatientById(widget.patientId);
      if (mounted) {
        setState(() {
          _patient = patient;
          _nameController.text = patient.name;
          _ageController.text = patient.age.toString();
          _phoneController.text = patient.contact;
          _addressController.text = patient.village;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    if (_error != null || _patient == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Could not load patient: $_error')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Patient'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Update',
              style: GoogleFonts.beVietnamPro(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: AppTheme.primaryFixed,
                  child: Text(
                    _patient!.name.isNotEmpty ? _patient!.name.substring(0, 1).toUpperCase() : '?',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit_rounded,
                        size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          FormSection(
            title: 'PERSONAL INFORMATION',
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outlined, size: 20),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age (years)',
                  prefixIcon: Icon(Icons.cake_outlined, size: 20),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.call_outlined, size: 20),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: Icon(Icons.location_on_outlined, size: 20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            label: 'Update Patient',
            icon: Icons.save_rounded,
            onPressed: () async {
              try {
                // Show loading
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CircularProgressIndicator()),
                );
                
                await PatientRepository.updatePatient(widget.patientId, {
                  'name': _nameController.text,
                  'age': int.tryParse(_ageController.text) ?? 0,
                  'contact': _phoneController.text,
                  'village': _addressController.text,
                });
                
                if (context.mounted) {
                  context.pop(); // pop dialog
                  context.pop(); // pop edit screen
                }
              } catch (e) {
                if (context.mounted) {
                  context.pop(); // pop dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Update failed: $e')),
                  );
                }
              }
            },
          ),
          const SizedBox(height: 12),
          // Danger zone
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.errorContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppTheme.error.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Danger Zone',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.error,
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  icon: const Icon(Icons.delete_rounded, size: 18),
                  label: const Text('Delete Patient Record'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.error,
                    side: const BorderSide(color: AppTheme.error),
                  ),
                  onPressed: () => context.go('/patients'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
