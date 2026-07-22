class ScreeningFormData {
  final double? age;
  final double? systolicBp;
  final double? diastolicBp;
  final double? bloodSugar;
  final double? bodyTemperature;
  final double? bmi;
  final double? previousComplications; // 0.0 or 1.0
  final double? preexistingDiabetes; // 0.0 or 1.0
  final double? gestationalDiabetes; // 0.0 or 1.0
  final double? mentalHealth; // 0.0 or 1.0
  final double? heartRate;

  ScreeningFormData({
    this.age,
    this.systolicBp,
    this.diastolicBp,
    this.bloodSugar,
    this.bodyTemperature,
    this.bmi,
    this.previousComplications,
    this.preexistingDiabetes,
    this.gestationalDiabetes,
    this.mentalHealth,
    this.heartRate,
  });

  ScreeningFormData copyWith({
    double? age,
    double? systolicBp,
    double? diastolicBp,
    double? bloodSugar,
    double? bodyTemperature,
    double? bmi,
    double? previousComplications,
    double? preexistingDiabetes,
    double? gestationalDiabetes,
    double? mentalHealth,
    double? heartRate,
  }) {
    return ScreeningFormData(
      age: age ?? this.age,
      systolicBp: systolicBp ?? this.systolicBp,
      diastolicBp: diastolicBp ?? this.diastolicBp,
      bloodSugar: bloodSugar ?? this.bloodSugar,
      bodyTemperature: bodyTemperature ?? this.bodyTemperature,
      bmi: bmi ?? this.bmi,
      previousComplications: previousComplications ?? this.previousComplications,
      preexistingDiabetes: preexistingDiabetes ?? this.preexistingDiabetes,
      gestationalDiabetes: gestationalDiabetes ?? this.gestationalDiabetes,
      mentalHealth: mentalHealth ?? this.mentalHealth,
      heartRate: heartRate ?? this.heartRate,
    );
  }
}
