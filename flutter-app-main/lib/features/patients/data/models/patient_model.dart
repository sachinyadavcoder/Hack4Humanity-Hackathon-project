class PatientModel {
  final String patientId;
  final String name;
  final int age;
  final String contact;
  final String village;
  final String? ashaWorker;
  final int trimester;
  final int pregnancyWeek;
  final String gravida;
  final String bloodGroup;
  final String risk;
  final int riskScore;
  final List<String> reasons;
  final String? prediction;
  final DateTime? lastVisit;
  final MedicalHistory medicalHistory;
  final Vitals? vitals;
  final List<Report> reports;
  final List<PreviousVisit> previousVisits;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PatientModel({
    required this.patientId,
    required this.name,
    required this.age,
    required this.contact,
    required this.village,
    this.ashaWorker,
    required this.trimester,
    required this.pregnancyWeek,
    required this.gravida,
    required this.bloodGroup,
    this.risk = 'Normal',
    this.riskScore = 0,
    this.reasons = const [],
    this.prediction,
    this.lastVisit,
    required this.medicalHistory,
    this.vitals,
    this.reports = const [],
    this.previousVisits = const [],
    this.createdAt,
    this.updatedAt,
  });

  static DateTime? _parseDate(dynamic dateJson) {
    if (dateJson == null) return null;
    if (dateJson is String) return DateTime.tryParse(dateJson);
    if (dateJson is Map && dateJson['\$date'] != null) {
      return DateTime.tryParse(dateJson['\$date']);
    }
    return null;
  }

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      patientId: json['patientId'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      contact: json['contact'] ?? '',
      village: json['village'] ?? '',
      ashaWorker: json['ashaWorker'],
      trimester: json['trimester'] ?? 1,
      pregnancyWeek: json['pregnancyWeek'] ?? 0,
      gravida: json['gravida'] ?? '',
      bloodGroup: json['bloodGroup'] ?? '',
      risk: json['risk'] ?? json['riskLevel'] ?? 'Normal',
      riskScore: json['riskScore'] ?? 0,
      reasons: (json['reasons'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      prediction: json['prediction'],
      lastVisit: _parseDate(json['lastVisit']),
      medicalHistory: json['medicalHistory'] != null 
          ? MedicalHistory.fromJson(json['medicalHistory'] as Map<String, dynamic>) 
          : MedicalHistory(),
      vitals: json['vitals'] != null ? Vitals.fromJson(json['vitals']) : null,
      reports: (json['reports'] as List<dynamic>?)
              ?.map((e) => Report.fromJson(e))
              .toList() ??
          [],
      previousVisits: (json['previousVisits'] as List<dynamic>?)
              ?.map((e) => PreviousVisit.fromJson(e))
              .toList() ??
          [],
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'name': name,
      'age': age,
      'contact': contact,
      'village': village,
      if (ashaWorker != null && ashaWorker!.isNotEmpty) 'ashaWorker': ashaWorker,
      'trimester': trimester,
      'pregnancyWeek': pregnancyWeek,
      'gravida': gravida,
      'bloodGroup': bloodGroup,
      'risk': risk,
      'riskScore': riskScore,
      'reasons': reasons,
      'prediction': prediction,
      'lastVisit': lastVisit?.toIso8601String(),
      'medicalHistory': medicalHistory.toJson(),
      if (vitals != null) 'vitals': vitals!.toJson(),
      'reports': reports.map((e) => e.toJson()).toList(),
      'previousVisits': previousVisits.map((e) => e.toJson()).toList(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}

class MedicalHistory {
  final bool diabetes;
  final bool hypertension;
  final bool thyroid;
  final bool previousCSection;
  final bool previousMiscarriage;
  final String allergies;

  MedicalHistory({
    this.diabetes = false,
    this.hypertension = false,
    this.thyroid = false,
    this.previousCSection = false,
    this.previousMiscarriage = false,
    this.allergies = 'None reported',
  });

  factory MedicalHistory.fromJson(Map<String, dynamic> json) {
    return MedicalHistory(
      diabetes: json['diabetes'] ?? false,
      hypertension: json['hypertension'] ?? false,
      thyroid: json['thyroid'] ?? false,
      previousCSection: json['previousCSection'] ?? false,
      previousMiscarriage: json['previousMiscarriage'] ?? false,
      allergies: json['allergies'] ?? 'None reported',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diabetes': diabetes,
      'hypertension': hypertension,
      'thyroid': thyroid,
      'previousCSection': previousCSection,
      'previousMiscarriage': previousMiscarriage,
      'allergies': allergies,
    };
  }
}

class Vitals {
  final String bp;
  final String weight;
  final String hemoglobin;
  final String sugar;
  final String ultrasoundSummary;

  Vitals({
    this.bp = '',
    this.weight = '',
    this.hemoglobin = '',
    this.sugar = '',
    this.ultrasoundSummary = '',
  });

  factory Vitals.fromJson(Map<String, dynamic> json) {
    return Vitals(
      bp: json['bp'] ?? '',
      weight: json['weight'] ?? '',
      hemoglobin: json['hemoglobin'] ?? '',
      sugar: json['sugar'] ?? '',
      ultrasoundSummary: json['ultrasoundSummary'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bp': bp,
      'weight': weight,
      'hemoglobin': hemoglobin,
      'sugar': sugar,
      'ultrasoundSummary': ultrasoundSummary,
    };
  }
}

class Report {
  final String type;
  final DateTime? date;
  final String fileName;
  final String id;

  Report({
    required this.type,
    this.date,
    required this.fileName,
    required this.id,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    String parsedId = '';
    if (json['_id'] != null) {
      if (json['_id'] is Map && json['_id']['\$oid'] != null) {
        parsedId = json['_id']['\$oid'];
      } else {
        parsedId = json['_id'].toString();
      }
    }

    DateTime? parsedDate;
    if (json['date'] != null) {
      if (json['date'] is String) {
        parsedDate = DateTime.tryParse(json['date']);
      } else if (json['date'] is Map && json['date']['\$date'] != null) {
        parsedDate = DateTime.tryParse(json['date']['\$date']);
      }
    }

    return Report(
      type: json['type'] ?? '',
      date: parsedDate,
      fileName: json['fileName'] ?? '',
      id: parsedId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      if (date != null) 'date': date!.toIso8601String(),
      'fileName': fileName,
      '_id': id,
    };
  }
}

class PreviousVisit {
  final DateTime? date;
  final String bp;
  final String weight;
  final String notes;
  final String id;

  PreviousVisit({
    this.date,
    this.bp = '',
    this.weight = '',
    this.notes = '',
    required this.id,
  });

  factory PreviousVisit.fromJson(Map<String, dynamic> json) {
    String parsedId = '';
    if (json['_id'] != null) {
      if (json['_id'] is Map && json['_id']['\$oid'] != null) {
        parsedId = json['_id']['\$oid'];
      } else {
        parsedId = json['_id'].toString();
      }
    }

    DateTime? parsedDate;
    if (json['date'] != null) {
      if (json['date'] is String) {
        parsedDate = DateTime.tryParse(json['date']);
      } else if (json['date'] is Map && json['date']['\$date'] != null) {
        parsedDate = DateTime.tryParse(json['date']['\$date']);
      }
    }

    return PreviousVisit(
      date: parsedDate,
      bp: json['bp'] ?? '',
      weight: json['weight'] ?? '',
      notes: json['notes'] ?? '',
      id: parsedId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (date != null) 'date': date!.toIso8601String(),
      'bp': bp,
      'weight': weight,
      'notes': notes,
      '_id': id,
    };
  }
}
