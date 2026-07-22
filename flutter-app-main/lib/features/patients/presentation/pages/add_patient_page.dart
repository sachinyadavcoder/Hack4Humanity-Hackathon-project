import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/app/theme/app_theme.dart';
import 'package:new_app/core/widgets/common_widgets.dart';
import 'package:new_app/features/patients/data/models/patient_model.dart';
import 'package:new_app/features/patients/data/repositories/patient_repository.dart';

class AddPatientPage extends StatefulWidget {
  const AddPatientPage({super.key});

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _villageController = TextEditingController();
  final _ashaWorkerController = TextEditingController();
  final _lmpController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _gravidaController = TextEditingController();
  final _paraController = TextEditingController();
  final _allergiesController = TextEditingController();
  String _bloodType = 'O+';
  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  bool _hasDiabetes = false;
  bool _hasHypertension = false;
  bool _hasThyroid = false;
  bool _hasPrevCSection = false;
  bool _hasPrevMiscarriage = false;

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _villageController.dispose();
    _ashaWorkerController.dispose();
    _lmpController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _gravidaController.dispose();
    _paraController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Patient'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _savePatient,
            child: Text(
              'Save',
              style: GoogleFonts.beVietnamPro(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: AppTheme.primaryFixed,
                    child: const Icon(
                      Icons.person_rounded,
                      size: 52,
                      color: AppTheme.primary,
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
                      child: const Icon(Icons.camera_alt_rounded,
                          size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            // Personal Info
            FormSection(
              title: 'PERSONAL INFORMATION',
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'e.g. Amina Bello',
                    prefixIcon: Icon(Icons.person_outlined, size: 20),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Age (years)',
                          hintText: '25',
                          prefixIcon: Icon(Icons.cake_outlined, size: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _bloodType,
                        items: _bloodTypes
                            .map((t) =>
                                DropdownMenuItem(value: t, child: Text(t)))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _bloodType = v ?? 'O+'),
                        decoration: const InputDecoration(
                          labelText: 'Blood Type',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    hintText: '+234 800 000 0000',
                    prefixIcon: Icon(Icons.call_outlined, size: 20),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Phone number is required by the server';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _villageController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Village / Address',
                    hintText: 'Enter village or residential address',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 24),
                      child: Icon(Icons.location_on_outlined, size: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _ashaWorkerController,
                  decoration: const InputDecoration(
                    labelText: 'ASHA Worker (Optional)',
                    hintText: 'e.g. Sunita Devi',
                    prefixIcon: Icon(Icons.health_and_safety_outlined, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            // Obstetric Info
            FormSection(
              title: 'OBSTETRIC INFORMATION',
              children: [
                TextFormField(
                  controller: _lmpController,
                  decoration: const InputDecoration(
                    labelText: 'Last Menstrual Period (LMP)',
                    hintText: 'YYYY-MM-DD',
                    prefixIcon: Icon(Icons.calendar_today_outlined, size: 20),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _gravidaController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Gravida',
                          hintText: '1',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _paraController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Para',
                          hintText: '0',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            // Physical Measurements
            FormSection(
              title: 'PHYSICAL MEASUREMENTS',
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Weight (kg)',
                          hintText: '65',
                          prefixIcon: Icon(Icons.monitor_weight_outlined, size: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _heightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Height (cm)',
                          hintText: '160',
                          prefixIcon: Icon(Icons.height_rounded, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            // Medical History
            FormSection(
              title: 'MEDICAL HISTORY',
              children: [
                _buildCheckbox('Diabetes', _hasDiabetes, (v) => setState(() => _hasDiabetes = v ?? false)),
                _buildCheckbox('Hypertension', _hasHypertension, (v) => setState(() => _hasHypertension = v ?? false)),
                _buildCheckbox('Thyroid', _hasThyroid, (v) => setState(() => _hasThyroid = v ?? false)),
                _buildCheckbox('Previous C-Section', _hasPrevCSection, (v) => setState(() => _hasPrevCSection = v ?? false)),
                _buildCheckbox('Previous Miscarriage', _hasPrevMiscarriage, (v) => setState(() => _hasPrevMiscarriage = v ?? false)),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _allergiesController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Allergies',
                    hintText: 'List any allergies (or leave blank if none)',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 24),
                      child: Icon(Icons.warning_amber_rounded, size: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : PrimaryButton(
                    label: 'Save Patient',
                    icon: Icons.save_rounded,
                    onPressed: _savePatient,
                  ),
            const SizedBox(height: 12),
            SecondaryButton(
              label: 'Cancel',
              onPressed: () => context.pop(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, ValueChanged<bool?> onChanged) {
    return CheckboxListTile(
      title: Text(
        label,
        style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppTheme.onSurface),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.primary,
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }

  Future<void> _savePatient() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      // Calculate pregnancy info from LMP
      int weeks = 0;
      int trimester = 1;
      
      if (_lmpController.text.isNotEmpty) {
        try {
          final lmpDate = DateTime.parse(_lmpController.text);
          final now = DateTime.now();
          final diff = now.difference(lmpDate);
          weeks = (diff.inDays / 7).floor();
          
          if (weeks <= 13) {
            trimester = 1;
          } else if (weeks <= 27) {
            trimester = 2;
          } else {
            trimester = 3;
          }
        } catch (e) {
          // If parse fails, defaults are used
        }
      }

      final String pId = 'PT-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

      final patient = PatientModel(
        patientId: pId,
        name: _nameController.text,
        age: int.tryParse(_ageController.text) ?? 0,
        contact: _phoneController.text,
        village: _villageController.text,
        ashaWorker: _ashaWorkerController.text,
        trimester: trimester,
        pregnancyWeek: weeks,
        gravida: _gravidaController.text,
        bloodGroup: _bloodType,
        medicalHistory: MedicalHistory(
          diabetes: _hasDiabetes,
          hypertension: _hasHypertension,
          thyroid: _hasThyroid,
          previousCSection: _hasPrevCSection,
          previousMiscarriage: _hasPrevMiscarriage,
          allergies: _allergiesController.text.isEmpty ? 'None reported' : _allergiesController.text,
        ),
        vitals: Vitals(
          weight: _weightController.text.isNotEmpty ? '${_weightController.text} kg' : '',
        ),
      );

      final jsonStr = jsonEncode(patient.toJson());
      print('--- NEW PATIENT DATA ---');
      print(jsonStr);
      print('------------------------');

      try {
        await PatientRepository.createPatient(patient);
        if (mounted) {
          context.pushReplacement('/patients/$pId');
        }
      } catch (e) {
        print("Error saving to DB: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving patient: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }
}
