class DeliveryFeeResult {
  final String productId;
  final double distanceKm;
  final double feeGhs;
  final double baseFee;
  final double distanceFee;
  final double ratePerKm;
  final String method;

  const DeliveryFeeResult({
    required this.productId,
    required this.distanceKm,
    required this.feeGhs,
    required this.baseFee,
    required this.distanceFee,
    required this.ratePerKm,
    required this.method,
  });

  factory DeliveryFeeResult.fromJson(Map<String, dynamic> j) {
    final b = (j['breakdown'] as Map<String, dynamic>?) ?? {};
    return DeliveryFeeResult(
      productId: (j['productId'] as String?) ?? '',
      distanceKm: _toDouble(j['distanceKm']),
      feeGhs: _toDouble(j['feeGhs']),
      baseFee: _toDouble(b['baseFee']),
      distanceFee: _toDouble(b['distanceFee']),
      ratePerKm: _toDouble(b['ratePerKm']),
      method: (b['method'] as String?) ?? '',
    );
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }
}
