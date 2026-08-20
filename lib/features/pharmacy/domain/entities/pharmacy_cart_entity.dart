import 'pharmacy_cart_address_entity.dart';
import 'pharmacy_cart_item_entity.dart';
import 'pharmacy_payment_breakdown_entity.dart';

class PharmacyCartEntity {
  const PharmacyCartEntity({
    required this.bookingId,
    required this.items,
    this.paymentBreakdown,
    this.addresses = const [],
    this.status,
    this.orderId,
    this.unifiedOrderId,
  });

  final String? bookingId;
  final List<PharmacyCartItemEntity> items;
  final PharmacyPaymentBreakdownEntity? paymentBreakdown;
  final List<PharmacyCartAddressEntity> addresses;
  final String? status;
  final String? orderId;
  final int? unifiedOrderId;

  bool get isAwaitingPayment {
    final value = (status ?? '').trim().toUpperCase();
    return value == 'AWAITING_PAYMENT' ||
        value == 'PENDING_PAYMENT' ||
        value == 'PAYMENT_PENDING';
  }
}
