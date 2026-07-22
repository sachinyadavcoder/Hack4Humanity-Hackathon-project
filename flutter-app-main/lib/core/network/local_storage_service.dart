import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_app/features/patients/data/models/patient_model.dart';

class LocalStorageService {
  static const String _patientsListKey = 'cached_patients_list';
  static const String _patientDetailsPrefix = 'cached_patient_';

  /// Caches the entire list of patients for the dashboard and list pages
  static Future<void> cachePatientsList(List<PatientModel> patients) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> jsonList = patients.map((p) => p.toJson()).toList();
      final String jsonString = jsonEncode(jsonList);
      await prefs.setString(_patientsListKey, jsonString);
    } catch (e) {
      print('Error caching patients list: $e');
    }
  }

  /// Retrieves the cached list of patients
  static Future<List<PatientModel>> getCachedPatientsList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_patientsListKey);
      if (jsonString != null) {
        final List<dynamic> decodedList = jsonDecode(jsonString);
        return decodedList.map((json) => PatientModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error retrieving cached patients list: $e');
    }
    return [];
  }

  /// Caches details for a single patient
  static Future<void> cachePatientDetails(PatientModel patient) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(patient.toJson());
      await prefs.setString('$_patientDetailsPrefix${patient.patientId}', jsonString);
    } catch (e) {
      print('Error caching patient details: $e');
    }
  }

  /// Retrieves cached details for a single patient by ID
  static Future<PatientModel?> getCachedPatientDetails(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('$_patientDetailsPrefix$id');
      if (jsonString != null) {
        final decoded = jsonDecode(jsonString);
        return PatientModel.fromJson(decoded);
      }
    } catch (e) {
      print('Error retrieving cached patient details: $e');
    }
    return null;
  }
}
