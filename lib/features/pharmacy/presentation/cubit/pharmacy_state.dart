import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/state_status.dart';
import '../../domain/entities/pharmacy_cart_address_entity.dart';
import '../../domain/entities/pharmacy_cart_item_entity.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import '../../domain/entities/pharmacy_payment_breakdown_entity.dart';

part 'pharmacy_state.freezed.dart';

enum PharmacyPaymentMethod { jazzCash, debitCard, cashOnDelivery }

@freezed
abstract class PharmacyState with _$PharmacyState {
  const factory PharmacyState({
    @Default(StateStatus.idle) StateStatus medicinesLoadingStateStatus,
    @Default([]) List<PharmacyMedicineEntity> medicines,
    String? medicinesErrorMessage,
    @Default('') String searchQuery,
    @Default(1) int currentPage,
    @Default(1) int lastPage,
    @Default(0) int totalProducts,
    @Default(false) bool isLoadingMore,
    @Default(StateStatus.idle) StateStatus productDetailLoadingStateStatus,
    PharmacyMedicineEntity? selectedProduct,
    @Default([]) List<PharmacyMedicineEntity> relatedProducts,
    String? productDetailErrorMessage,
    @Default('Islamabad') String selectedCity,
    @Default([]) List<String> checkoutCities,
    String? cartBookingId,
    @Default([]) List<PharmacyCartItemEntity> cartItems,
    @Default([]) List<PharmacyCartAddressEntity> cartAddresses,
    PharmacyPaymentBreakdownEntity? paymentBreakdown,
    @Default(PharmacyPaymentMethod.jazzCash)
    PharmacyPaymentMethod selectedPaymentMethod,
  }) = _PharmacyState;
}

extension PharmacyStateX on PharmacyState {
  bool get hasMoreProducts => currentPage < lastPage;

  int get cartCount =>
      cartItems.fold<int>(0, (sum, item) => sum + item.quantity);

  double get computedSubtotal =>
      cartItems.fold<double>(0, (sum, item) => sum + item.total);

  double get subtotal => paymentBreakdown?.subtotal ?? computedSubtotal;

  double get discount => paymentBreakdown?.discount ?? 0;

  double get deliveryCharges => paymentBreakdown?.deliveryCharges ?? 0;

  /// `subtotal - discount + delivery_charges` from the cart API fields.
  double get total => (subtotal - discount) + deliveryCharges;

  /// API `discount_percentage` when present; otherwise `discount / subtotal`.
  double? get discountPercent {
    final fromApi = paymentBreakdown?.discountPercent;
    if (fromApi != null) return fromApi;
    if (discount > 0 && subtotal > 0) {
      return (discount / subtotal) * 100;
    }
    return null;
  }
}
