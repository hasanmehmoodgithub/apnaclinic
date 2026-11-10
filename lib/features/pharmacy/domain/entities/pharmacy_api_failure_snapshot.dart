import 'pharmacy_cart_invalid_item_entity.dart';

/// Last structured pharmacy API error remembered by the repository.
class PharmacyApiFailureSnapshot {
  const PharmacyApiFailureSnapshot({
    required this.message,
    this.code,
    this.statusCode,
    this.failedItems = const [],
  });

  final String message;
  final String? code;
  final int? statusCode;
  final List<PharmacyCartInvalidItemEntity> failedItems;
}
