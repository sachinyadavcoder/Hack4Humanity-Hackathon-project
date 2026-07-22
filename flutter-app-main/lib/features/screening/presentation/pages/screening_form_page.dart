import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_app/app/theme/app_theme.dart';
import 'package:new_app/core/widgets/common_widgets.dart';
import 'package:new_app/features/screening/domain/providers/screening_provider.dart';
import 'package:new_app/app/constants/dummy_data.dart';
import 'package:new_app/features/screening/domain/models/screening_form_data.dart';

class ScreeningFormPage extends ConsumerStatefulWidget {
  final String patientId;

  const ScreeningFormPage({super.key, required this.patientId});

  @override
  ConsumerState<ScreeningFormPage> createState() => _ScreeningFormPageState();
}

class _ScreeningFormPageState extends ConsumerState<ScreeningFormPage> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  // Step 1: Vitals
  final _bpSystolicController = TextEditingController();
  final _bpDiastolicController = TextEditingController();
  final _bloodSugarController = TextEditingController();
  final _heartRateController = TextEditingController();
  final _tempController = TextEditingController();
  final _weightController = TextEditingController();
  final _hemoglobinController = TextEditingController();

  // Step 2: Symptoms (checkboxes)
  final Map<String, bool> _symptoms = {
    'Headache': false,
    'Visual disturbances': false,
    'Swelling (edema)': false,
    'Abdominal pain': false,
    'Vaginal bleeding': false,
    'Reduced fetal movement': false,
    'Nausea/Vomiting': false,
    'Fever/Chills': false,
    'Difficulty breathing': false,
    'Chest pain': false,
  };

  // Step 3: History
  final _prevComplicationsController = TextEditingController();
  bool _hasPrevComplications = false;
  bool _hasDiabetes = false;
  bool _hasGestationalDiabetes = false;
  bool _hasMentalHealthIssues = false;
  bool _hasHypertension = false;
  bool _hasMalaria = false;
  bool _hasPrevCSection = false;

  // Step 4: Lifestyle
  bool _smokes = false;
  bool _drinkAlcohol = false;
  bool _usesITN = true;
  bool _takesIronSupp = true;
  bool _attendsANC = true;

  final List<String> _stepTitles = [
    'Vitals',
    'Symptoms',
    'History',
    'Lifestyle',
  ];

  void _next() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      final patient = DummyData.patients.firstWhere(
        (p) => p['id'] == widget.patientId,
        orElse: () => DummyData.patients.first,
      );
      final age = (patient['age'] as num?)?.toDouble() ?? 25.0;
      
      double? bmi = double.tryParse(patient['bmi'].toString());
      final weight = double.tryParse(_weightController.text);
      if (weight != null) {
        final heightStr = patient['height'].toString().replaceAll(RegExp(r'[^0-9.]'), '');
        final heightCm = double.tryParse(heightStr);
        if (heightCm != null && heightCm > 0) {
          final heightM = heightCm / 100;
          bmi = weight / (heightM * heightM);
        }
      }

      ref.read(screeningFormDataProvider.notifier).updateState(ScreeningFormData(
        age: age,
        systolicBp: double.tryParse(_bpSystolicController.text),
        diastolicBp: double.tryParse(_bpDiastolicController.text),
        bloodSugar: double.tryParse(_bloodSugarController.text),
        bodyTemperature: double.tryParse(_tempController.text),
        bmi: bmi,
        previousComplications: _hasPrevComplications ? 1.0 : 0.0,
        preexistingDiabetes: _hasDiabetes ? 1.0 : 0.0,
        gestationalDiabetes: _hasGestationalDiabetes ? 1.0 : 0.0,
        mentalHealth: _hasMentalHealthIssues ? 1.0 : 0.0,
        heartRate: double.tryParse(_heartRateController.text),
      ));
      context.pushReplacement('/screening/review/${widget.patientId}');
    }
  }

  void _previous() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _bpSystolicController.dispose();
    _bpDiastolicController.dispose();
    _bloodSugarController.dispose();
    _heartRateController.dispose();
    _tempController.dispose();
    _weightController.dispose();
    _hemoglobinController.dispose();
    _prevComplicationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screening: ${_stepTitles[_currentStep]}'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Step indicator
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: List.generate(4, (i) {
                    final isDone = i < _currentStep;
                    final isActive = i == _currentStep;
                    return Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 4,
                              decoration: BoxDecoration(
                                color: isDone || isActive
                                    ? AppTheme.primary
                                    : AppTheme.outlineVariant,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                          if (i < 3) const SizedBox(width: 4),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Step ${_currentStep + 1} of 4',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 12,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _stepTitles[_currentStep],
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 12,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Page content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _VitalsStep(
                  systolicCtrl: _bpSystolicController,
                  diastolicCtrl: _bpDiastolicController,
                  bloodSugarCtrl: _bloodSugarController,
                  hrCtrl: _heartRateController,
                  tempCtrl: _tempController,
                  weightCtrl: _weightController,
                  hbCtrl: _hemoglobinController,
                ),
                _SymptomsStep(
                  symptoms: _symptoms,
                  onToggle: (key, val) =>
                      setState(() => _symptoms[key] = val),
                ),
                _HistoryStep(
                  complicationsCtrl: _prevComplicationsController,
                  hasPrevComplications: _hasPrevComplications,
                  hasDiabetes: _hasDiabetes,
                  hasGestationalDiabetes: _hasGestationalDiabetes,
                  hasMentalHealthIssues: _hasMentalHealthIssues,
                  hasHypertension: _hasHypertension,
                  hasMalaria: _hasMalaria,
                  hasPrevCSection: _hasPrevCSection,
                  onPrevComplicationsChanged: (v) =>
                      setState(() => _hasPrevComplications = v ?? false),
                  onDiabetesChanged: (v) =>
                      setState(() => _hasDiabetes = v ?? false),
                  onGestationalDiabetesChanged: (v) =>
                      setState(() => _hasGestationalDiabetes = v ?? false),
                  onMentalHealthIssuesChanged: (v) =>
                      setState(() => _hasMentalHealthIssues = v ?? false),
                  onHypertensionChanged: (v) =>
                      setState(() => _hasHypertension = v ?? false),
                  onMalariaChanged: (v) =>
                      setState(() => _hasMalaria = v ?? false),
                  onCSectionChanged: (v) =>
                      setState(() => _hasPrevCSection = v ?? false),
                ),
                _LifestyleStep(
                  smokes: _smokes,
                  drinkAlcohol: _drinkAlcohol,
                  usesITN: _usesITN,
                  takesIronSupp: _takesIronSupp,
                  attendsANC: _attendsANC,
                  onSmokesChanged: (v) =>
                      setState(() => _smokes = v ?? false),
                  onAlcoholChanged: (v) =>
                      setState(() => _drinkAlcohol = v ?? false),
                  onITNChanged: (v) =>
                      setState(() => _usesITN = v ?? true),
                  onIronSuppChanged: (v) =>
                      setState(() => _takesIronSupp = v ?? true),
                  onANCChanged: (v) =>
                      setState(() => _attendsANC = v ?? true),
                ),
              ],
            ),
          ),
          // Navigation buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: SecondaryButton(
                      label: 'Back',
                      onPressed: _previous,
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: PrimaryButton(
                    label: _currentStep == 3 ? 'Review & Submit' : 'Next',
                    icon: _currentStep == 3
                        ? Icons.check_rounded
                        : Icons.arrow_forward_rounded,
                    onPressed: _next,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Step 1: Vitals ─────────────────────────────────────
class _VitalsStep extends StatelessWidget {
  final TextEditingController systolicCtrl;
  final TextEditingController diastolicCtrl;
  final TextEditingController bloodSugarCtrl;
  final TextEditingController hrCtrl;
  final TextEditingController tempCtrl;
  final TextEditingController weightCtrl;
  final TextEditingController hbCtrl;

  const _VitalsStep({
    required this.systolicCtrl,
    required this.diastolicCtrl,
    required this.bloodSugarCtrl,
    required this.hrCtrl,
    required this.tempCtrl,
    required this.weightCtrl,
    required this.hbCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // BP
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.monitor_heart_rounded,
                        color: AppTheme.primary, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Blood Pressure',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: systolicCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Systolic',
                          hintText: '120',
                          suffixText: 'mmHg',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '/',
                        style: GoogleFonts.beVietnamPro(
                            fontSize: 24, color: AppTheme.outline),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: diastolicCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Diastolic',
                          hintText: '80',
                          suffixText: 'mmHg',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: hrCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Heart Rate',
                    hintText: '80',
                    prefixIcon: Icon(Icons.favorite_outline, size: 18),
                    suffixText: 'bpm',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: tempCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Temperature',
                    hintText: '36.8',
                    prefixIcon: Icon(Icons.thermostat_outlined, size: 18),
                    suffixText: '°C',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: bloodSugarCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Blood Sugar',
              hintText: '5.5',
              prefixIcon: Icon(Icons.water_drop_outlined, size: 18),
              suffixText: 'mmol/L',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: weightCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Weight',
                    hintText: '65',
                    prefixIcon: Icon(Icons.monitor_weight_outlined, size: 18),
                    suffixText: 'kg',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: hbCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Hemoglobin',
                    hintText: '11.0',
                    prefixIcon: Icon(Icons.bloodtype_outlined, size: 18),
                    suffixText: 'g/dL',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Step 2: Symptoms ────────────────────────────────────
class _SymptomsStep extends StatelessWidget {
  final Map<String, bool> symptoms;
  final void Function(String, bool) onToggle;

  const _SymptomsStep({required this.symptoms, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select all symptoms the patient is experiencing:',
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          ...symptoms.entries.map((entry) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: entry.value
                    ? AppTheme.primaryFixed
                    : AppTheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      entry.value ? AppTheme.primary : AppTheme.outlineVariant,
                ),
              ),
              child: CheckboxListTile(
                title: Text(
                  entry.key,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 14,
                    fontWeight: entry.value
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: entry.value
                        ? AppTheme.primary
                        : AppTheme.onSurface,
                  ),
                ),
                value: entry.value,
                onChanged: (v) => onToggle(entry.key, v ?? false),
                activeColor: AppTheme.primary,
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─── Step 3: Medical History ─────────────────────────────
class _HistoryStep extends StatelessWidget {
  final TextEditingController complicationsCtrl;
  final bool hasPrevComplications;
  final bool hasDiabetes;
  final bool hasGestationalDiabetes;
  final bool hasMentalHealthIssues;
  final bool hasHypertension;
  final bool hasMalaria;
  final bool hasPrevCSection;
  final ValueChanged<bool?> onPrevComplicationsChanged;
  final ValueChanged<bool?> onDiabetesChanged;
  final ValueChanged<bool?> onGestationalDiabetesChanged;
  final ValueChanged<bool?> onMentalHealthIssuesChanged;
  final ValueChanged<bool?> onHypertensionChanged;
  final ValueChanged<bool?> onMalariaChanged;
  final ValueChanged<bool?> onCSectionChanged;

  const _HistoryStep({
    required this.complicationsCtrl,
    required this.hasPrevComplications,
    required this.hasDiabetes,
    required this.hasGestationalDiabetes,
    required this.hasMentalHealthIssues,
    required this.hasHypertension,
    required this.hasMalaria,
    required this.hasPrevCSection,
    required this.onPrevComplicationsChanged,
    required this.onDiabetesChanged,
    required this.onGestationalDiabetesChanged,
    required this.onMentalHealthIssuesChanged,
    required this.onHypertensionChanged,
    required this.onMalariaChanged,
    required this.onCSectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Medical Conditions',
            style: GoogleFonts.beVietnamPro(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          _ConditionTile(
            label: 'Previous Complications',
            value: hasPrevComplications,
            onChanged: onPrevComplicationsChanged,
          ),
          _ConditionTile(
            label: 'Preexisting Diabetes',
            value: hasDiabetes,
            onChanged: onDiabetesChanged,
          ),
          _ConditionTile(
            label: 'Gestational Diabetes',
            value: hasGestationalDiabetes,
            onChanged: onGestationalDiabetesChanged,
          ),
          _ConditionTile(
            label: 'Mental Health Concerns',
            value: hasMentalHealthIssues,
            onChanged: onMentalHealthIssuesChanged,
          ),
          _ConditionTile(
            label: 'Hypertension',
            value: hasHypertension,
            onChanged: onHypertensionChanged,
          ),
          _ConditionTile(
            label: 'Previous/Current Malaria',
            value: hasMalaria,
            onChanged: onMalariaChanged,
          ),
          _ConditionTile(
            label: 'Previous C-Section',
            value: hasPrevCSection,
            onChanged: onCSectionChanged,
          ),
          const SizedBox(height: 20),
          Text(
            'Previous Pregnancy Complications (Details)',
            style: GoogleFonts.beVietnamPro(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: complicationsCtrl,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText:
                  'Describe any previous pregnancy complications...',
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConditionTile extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _ConditionTile({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: value ? AppTheme.errorContainer.withValues(alpha: 0.3) : AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? AppTheme.error.withValues(alpha: 0.4) : AppTheme.outlineVariant,
        ),
      ),
      child: CheckboxListTile(
        title: Text(
          label,
          style: GoogleFonts.beVietnamPro(
            fontSize: 14,
            fontWeight: value ? FontWeight.w600 : FontWeight.w400,
            color: value ? AppTheme.error : AppTheme.onSurface,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.error,
        controlAffinity: ListTileControlAffinity.leading,
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// ─── Step 4: Lifestyle ───────────────────────────────────
class _LifestyleStep extends StatelessWidget {
  final bool smokes;
  final bool drinkAlcohol;
  final bool usesITN;
  final bool takesIronSupp;
  final bool attendsANC;
  final ValueChanged<bool?> onSmokesChanged;
  final ValueChanged<bool?> onAlcoholChanged;
  final ValueChanged<bool?> onITNChanged;
  final ValueChanged<bool?> onIronSuppChanged;
  final ValueChanged<bool?> onANCChanged;

  const _LifestyleStep({
    required this.smokes,
    required this.drinkAlcohol,
    required this.usesITN,
    required this.takesIronSupp,
    required this.attendsANC,
    required this.onSmokesChanged,
    required this.onAlcoholChanged,
    required this.onITNChanged,
    required this.onIronSuppChanged,
    required this.onANCChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Risk Factors',
            style: GoogleFonts.beVietnamPro(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          _LifestyleTile(
            label: 'Smokes tobacco',
            value: smokes,
            onChanged: onSmokesChanged,
            isRisk: true,
          ),
          _LifestyleTile(
            label: 'Consumes alcohol',
            value: drinkAlcohol,
            onChanged: onAlcoholChanged,
            isRisk: true,
          ),
          const SizedBox(height: 20),
          Text(
            'Protective Factors',
            style: GoogleFonts.beVietnamPro(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          _LifestyleTile(
            label: 'Uses insecticide-treated net (ITN)',
            value: usesITN,
            onChanged: onITNChanged,
            isRisk: false,
          ),
          _LifestyleTile(
            label: 'Takes iron/folate supplements',
            value: takesIronSupp,
            onChanged: onIronSuppChanged,
            isRisk: false,
          ),
          _LifestyleTile(
            label: 'Attends ANC visits regularly',
            value: attendsANC,
            onChanged: onANCChanged,
            isRisk: false,
          ),
        ],
      ),
    );
  }
}

class _LifestyleTile extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final bool isRisk;

  const _LifestyleTile({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.isRisk,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = isRisk ? AppTheme.error : AppTheme.tertiary;
    final activeBg = isRisk
        ? AppTheme.errorContainer.withValues(alpha: 0.3)
        : const Color(0xFFDCFCE7);
    final activeBorder = isRisk
        ? AppTheme.error.withValues(alpha: 0.4)
        : AppTheme.tertiary.withValues(alpha: 0.4);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: value ? activeBg : AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? activeBorder : AppTheme.outlineVariant,
        ),
      ),
      child: CheckboxListTile(
        title: Text(
          label,
          style: GoogleFonts.beVietnamPro(
            fontSize: 14,
            fontWeight: value ? FontWeight.w600 : FontWeight.w400,
            color: value ? activeColor : AppTheme.onSurface,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: activeColor,
        controlAffinity: ListTileControlAffinity.leading,
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
