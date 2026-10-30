class PromoCodeValidationModel {
  const PromoCodeValidationModel({
    required this.code,
    required this.discountType,
    required this.discountValue,
    required this.originalAmount,
    required this.discountAmount,
    required this.payableAmount,
    this.freeDelivery = false,
    this.note = '',
  });

  final String code;
  final String discountType;
  final double discountValue;
  final int originalAmount;
  final int discountAmount;
  final int payableAmount;

  /// Pharmacy: when true, delivery is free for this applied promo.
  final bool freeDelivery;
  final String note;

  factory PromoCodeValidationModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final root = data is Map<String, dynamic>
        ? data
        : (data is Map ? Map<String, dynamic>.from(data) : json);

    return PromoCodeValidationModel(
      code: (root['code'] ?? '').toString(),
      discountType: (root['discountType'] ?? root['discount_type'] ?? '')
          .toString(),
      discountValue: _asDouble(root['discountValue'] ?? root['discount_value']),
      originalAmount: _asInt(root['originalAmount'] ?? root['original_amount']),
      discountAmount: _asInt(root['discountAmount'] ?? root['discount_amount']),
      payableAmount: _asInt(root['payableAmount'] ?? root['payable_amount']),
      freeDelivery: _asBool(root['freeDelivery'] ?? root['free_delivery']),
      note: (root['note'] ?? '').toString().trim(),
    );
  }

  static bool _asBool(dynamic value) {
    return switch (value) {
      bool v => v,
      int v => v == 1,
      String v => v.toLowerCase() == 'true' || v == '1',
      _ => false,
    };
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.round();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _asDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
