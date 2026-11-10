import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/state_status.dart';
import '../../../consultation/domain/entities/payment_provider_entity.dart';
import '../../domain/entities/pharmacy_cart_address_entity.dart';
import '../../domain/entities/pharmacy_cart_invalid_item_entity.dart';
import '../../domain/entities/pharmacy_cart_item_entity.dart';
import '../../domain/entities/pharmacy_city_entity.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import '../../domain/entities/pharmacy_cart_messages_entity.dart';
import '../../domain/entities/pharmacy_payment_breakdown_entity.dart';
import 'prescription_scan_state.dart';

part 'pharmacy_state.freezed.dart';

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
    @Default(false) bool productUnavailableInCity,
    /// Stored pharmacy delivery city name (empty until the user confirms).
    @Default('') String selectedCity,
    int? pharmacyCityId,
    @Default('') String pharmacyPartner,
    @Default([]) List<PharmacyCityEntity> pharmacyCities,
    @Default(false) bool needsPharmacyCitySelection,
    @Default([]) List<String> checkoutCities,
    String? cartBookingId,
    @Default([]) List<PharmacyCartItemEntity> cartItems,
    @Default([]) List<PharmacyCartAddressEntity> cartAddresses,
    PharmacyPaymentBreakdownEntity? paymentBreakdown,
    @Default([]) List<PaymentProviderEntity> paymentProviders,
    @Default(StateStatus.idle) StateStatus paymentProvidersStatus,
    String? paymentProvidersErrorMessage,
    String? selectedPaymentProviderCode,
    PharmacyCartMessagesEntity? cartMessages,
    @Default([]) List<PharmacyCartInvalidItemEntity> checkoutInvalidItems,
    @Default(PrescriptionScanState()) PrescriptionScanState prescriptionScan,
  }) = _PharmacyState;
}

extension PharmacyStateX on PharmacyState {
  PaymentProviderEntity? get selectedPaymentProvider {
    final code = selectedPaymentProviderCode?.trim();
    if (code == null || code.isEmpty) return null;
    for (final provider in paymentProviders) {
      if (provider.code == code) return provider;
    }
    return null;
  }

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

  String? get freeDeliveryMessage {
    final value = paymentBreakdown?.freeDeliveryMessage?.trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }

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
