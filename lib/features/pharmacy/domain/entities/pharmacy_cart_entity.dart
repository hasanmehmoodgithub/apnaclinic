import 'pharmacy_cart_address_entity.dart';
import 'pharmacy_cart_item_entity.dart';
import 'pharmacy_payment_breakdown_entity.dart';

class PharmacyCartEntity {
  const PharmacyCartEntity({
    required this.bookingId,
    required this.items,
    this.paymentBreakdown,
    this.addresses = const [],
    this.failedPaymentUnifiedOrderId,
  });

  final String? bookingId;
  final List<PharmacyCartItemEntity> items;
  final PharmacyPaymentBreakdownEntity? paymentBreakdown;
  final List<PharmacyCartAddressEntity> addresses;

  /// From `data.failed_payment.unified_order_id` when a prior card payment failed.
  final int? failedPaymentUnifiedOrderId;
}
