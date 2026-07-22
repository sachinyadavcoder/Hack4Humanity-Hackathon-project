import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:onnxruntime/onnxruntime.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_app/features/screening/domain/models/prediction_result.dart';
import 'package:new_app/features/screening/domain/models/screening_form_data.dart';

final predictionServiceProvider = Provider<PredictionService>((ref) {
  return PredictionService();
});

class PredictionService {
  static const _modelPath = 'assets/models/pregnancy_risk_model.onnx';
  OrtSession? _session;
  bool _isInitialized = false;

  static const _scalerMean = [
    27.776607,
    116.683878,
    77.008430,
    7.535606,
    98.390938,
    23.318124,
    0.171760,
    0.293994,
    0.115911,
    0.330875,
    75.786091,
  ];

  static const _scalerStd = [
    13.191730,
    18.539314,
    14.177259,
    3.032918,
    1.098884,
    3.863300,
    0.377171,
    0.455589,
    0.320119,
    0.470528,
    7.325172,
  ];

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      OrtEnv.instance.init();
      final sessionOptions = OrtSessionOptions();
      final rawAssetFile = await rootBundle.load(_modelPath);
      final bytes = rawAssetFile.buffer.asUint8List(rawAssetFile.offsetInBytes, rawAssetFile.lengthInBytes);
      _session = OrtSession.fromBuffer(bytes, sessionOptions);
      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize ONNX session: $e');
    }
  }

  Future<PredictionResult> predict(ScreeningFormData data) async {
    if (!_isInitialized || _session == null) {
      await init();
    }

    try {
      // 11 features in order:
      // Age, Systolic BP, Diastolic BP, Blood Sugar, Body Temperature, BMI,
      // Previous Complications, Preexisting Diabetes, Gestational Diabetes, Mental Health, Heart Rate
      final rawFeatures = <double>[
        data.age ?? _scalerMean[0],
        data.systolicBp ?? _scalerMean[1],
        data.diastolicBp ?? _scalerMean[2],
        data.bloodSugar ?? _scalerMean[3],
        data.bodyTemperature ?? _scalerMean[4],
        data.bmi ?? _scalerMean[5],
        data.previousComplications ?? 0.0,
        data.preexistingDiabetes ?? 0.0,
        data.gestationalDiabetes ?? 0.0,
        data.mentalHealth ?? 0.0,
        data.heartRate ?? _scalerMean[10],
      ];

      final scaledFeatures = List<double>.generate(11, (i) {
        return (rawFeatures[i] - _scalerMean[i]) / _scalerStd[i];
      });

      // Prepare input tensor
      final shape = [1, 11];
      final inputOrt = OrtValueTensor.createTensorWithDataList(
          Float32List.fromList(scaledFeatures), shape);

      final inputs = {'float_input': inputOrt};
      
      final runOptions = OrtRunOptions();
      final outputs = _session!.run(runOptions, inputs);

      // Model label mapping: 0 -> High, 1 -> Low
      final outputLabel = outputs[0]?.value as List?;
      final outputProb = outputs[1]?.value as List?;

      inputOrt.release();
      runOptions.release();
      for (var element in outputs) {
        element?.release();
      }

      if (outputLabel == null || outputProb == null || outputLabel.isEmpty || outputProb.isEmpty) {
        throw Exception('Invalid output from model');
      }

      final labelValue = (outputLabel[0] as num).toInt();
      // The probability output might be a list of maps or a list of lists.
      // Usually outputProb is a List of Maps containing probabilities.
      // E.g. [{0: 0.8, 1: 0.2}]
      final probOrtValue = outputProb[0];
      final probMap = probOrtValue is Map ? probOrtValue : (probOrtValue as OrtValue).value as Map;
      
      final highProb = (probMap[0] as num?)?.toDouble() ?? 0.0;
      final lowProb = (probMap[1] as num?)?.toDouble() ?? 0.0;
      
      final risk = labelValue == 0 ? 'High' : 'Low';
      final confidence = labelValue == 0 ? highProb : lowProb;

      return PredictionResult(
        risk: risk,
        confidence: confidence,
        highProbability: highProb,
        lowProbability: lowProb,
      );

    } catch (e) {
      throw Exception('Inference failed: $e');
    }
  }

  void dispose() {
    _session?.release();
    OrtEnv.instance.release();
  }
}
