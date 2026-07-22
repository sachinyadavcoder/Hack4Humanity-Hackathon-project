import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_app/core/network/api_client.dart';
import 'package:new_app/features/patients/data/models/patient_model.dart';
import 'package:new_app/core/network/local_storage_service.dart';

class PatientRepository {
  static Future<void> createPatient(PatientModel patient) async {
    final url = Uri.parse('${ApiClient.baseUrl}/patients');
    
    final patientData = patient.toJson();
    // Add dummy risk prediction
    patientData['risk'] = 'Normal';
    patientData['riskScore'] = 0;
    patientData['reasons'] = [];
    patientData['prediction'] = null;
    patientData['vitals'] ??= Vitals().toJson();
    patientData['reports'] ??= [];
    patientData['previousVisits'] ??= [];

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(patientData),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create patient: ${response.body}');
    }
  }

  static Future<List<PatientModel>> getPatients() async {
    try {
      final url = Uri.parse('${ApiClient.baseUrl}/patients');
      // Timeout added to fall back to cache quickly if offline
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        
        List<dynamic> dataList;
        if (decoded is List) {
          dataList = decoded;
        } else if (decoded is Map && decoded.containsKey('patients') && decoded['patients'] is List) {
          // Express backend returns { patients: [...], total: X, page: Y }
          dataList = decoded['patients'];
        } else if (decoded is Map && decoded.containsKey('data') && decoded['data'] is List) {
          dataList = decoded['data'];
        } else {
          throw Exception('Unexpected response format: $decoded');
        }
        
        final patients = dataList.reversed.map((json) => PatientModel.fromJson(json)).toList();
        // Cache the list for offline use
        await LocalStorageService.cachePatientsList(patients);
        return patients;
      } else {
        throw Exception('Failed to load patients: ${response.statusCode}');
      }
    } catch (e) {
      print('Network error loading patients ($e), falling back to cache...');
      final cachedPatients = await LocalStorageService.getCachedPatientsList();
      if (cachedPatients.isNotEmpty) {
        return cachedPatients;
      }
      throw Exception('Failed to load patients and no offline cache available: $e');
    }
  }

  static Future<PatientModel> getPatientById(String id) async {
    try {
      final url = Uri.parse('${ApiClient.baseUrl}/patients/$id');
      // Timeout added to fall back to cache quickly if offline
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final patient = PatientModel.fromJson(decoded);
        // Cache the detailed patient
        await LocalStorageService.cachePatientDetails(patient);
        return patient;
      } else {
        throw Exception('Failed to load patient: ${response.statusCode}');
      }
    } catch (e) {
      print('Network error loading patient details ($e), falling back to cache...');
      final cachedPatient = await LocalStorageService.getCachedPatientDetails(id);
      if (cachedPatient != null) {
        return cachedPatient;
      }
      throw Exception('Failed to load patient details and no offline cache available: $e');
    }
  }

  static Future<void> updatePatientRisk(String id, String riskLevel) async {
    try {
      final url = Uri.parse('${ApiClient.baseUrl}/patients/$id');
      
      // First get the existing patient
      final getResponse = await http.get(url);
      if (getResponse.statusCode == 200) {
        final Map<String, dynamic> patientData = jsonDecode(getResponse.body);
        
        // Update the risk level
        patientData['risk'] = riskLevel;
        
        // Send it back via PUT
        await http.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(patientData),
        );
      }
    } catch (e) {
      print('Failed to update patient risk: $e');
    }
  }

  static Future<void> updatePatient(String id, Map<String, dynamic> updates) async {
    final url = Uri.parse('${ApiClient.baseUrl}/patients/$id');
    
    // First get the existing patient
    final getResponse = await http.get(url);
    if (getResponse.statusCode == 200) {
      final Map<String, dynamic> patientData = jsonDecode(getResponse.body);
      
      // Merge updates
      patientData.addAll(updates);
      
      // Send it back via PUT
      final putResponse = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(patientData),
      );
      
      if (putResponse.statusCode != 200 && putResponse.statusCode != 201) {
        throw Exception('Failed to update patient: ${putResponse.body}');
      }
    } else {
      throw Exception('Failed to fetch patient for update: ${getResponse.statusCode}');
    }
  }
}
