import '../domain/entities/pharmacy_cart_invalid_item_entity.dart';

/// Structured pharmacy API failure (preserves aggregator error codes).
class PharmacyApiFailure implements Exception {
  const PharmacyApiFailure({
    required this.message,
    this.code,
    this.statusCode,
    this.failedItems = const [],
  });

  final String message;
  final String? code;
  final int? statusCode;
  final List<PharmacyCartInvalidItemEntity> failedItems;

  @override
  String toString() => message;
}
