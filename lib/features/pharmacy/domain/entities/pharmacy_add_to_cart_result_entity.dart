import 'pharmacy_cart_item_entity.dart';

class PharmacyAddToCartResultEntity {
  const PharmacyAddToCartResultEntity({
    required this.message,
    required this.bookingId,
    required this.items,
    required this.hasProductList,
  });

  final String message;
  final String? bookingId;
  final List<PharmacyCartItemEntity> items;

  /// True when the API returned a `products` array (even if empty).
  final bool hasProductList;
}
