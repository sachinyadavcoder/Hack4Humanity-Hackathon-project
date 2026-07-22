import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_app/features/screening/domain/models/screening_form_data.dart';
import 'package:new_app/features/screening/domain/models/prediction_result.dart';

class ScreeningFormDataNotifier extends Notifier<ScreeningFormData> {
  @override
  ScreeningFormData build() => ScreeningFormData();
  
  void updateState(ScreeningFormData newData) {
    state = newData;
  }
}

final screeningFormDataProvider = NotifierProvider<ScreeningFormDataNotifier, ScreeningFormData>(() {
  return ScreeningFormDataNotifier();
});

class PredictionResultNotifier extends Notifier<PredictionResult?> {
  @override
  PredictionResult? build() => null;

  void updateState(PredictionResult? newData) {
    state = newData;
  }
}

final predictionResultProvider = NotifierProvider<PredictionResultNotifier, PredictionResult?>(() {
  return PredictionResultNotifier();
});
