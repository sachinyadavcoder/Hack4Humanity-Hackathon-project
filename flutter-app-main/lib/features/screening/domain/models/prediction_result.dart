class PredictionResult {
  final String risk;
  final double confidence;
  final double highProbability;
  final double lowProbability;

  PredictionResult({
    required this.risk,
    required this.confidence,
    required this.highProbability,
    required this.lowProbability,
  });
}
