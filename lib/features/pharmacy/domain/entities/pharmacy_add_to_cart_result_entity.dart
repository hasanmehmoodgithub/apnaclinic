import 'pharmacy_cart_item_entity.dart';
import 'pharmacy_payment_breakdown_entity.dart';

class PharmacyAddToCartResultEntity {
  const PharmacyAddToCartResultEntity({
    required this.message,
    required this.bookingId,
    required this.items,
    required this.hasProductList,
    this.paymentBreakdown,
    this.failedPaymentUnifiedOrderId,
  });

  final String message;
  final String? bookingId;
  final List<PharmacyCartItemEntity> items;

  /// True when the API returned a `products` / `items` array (even if empty).
  final bool hasProductList;
  final PharmacyPaymentBreakdownEntity? paymentBreakdown;

  /// From `failed_payment.unified_order_id` when present.
  final int? failedPaymentUnifiedOrderId;
}
