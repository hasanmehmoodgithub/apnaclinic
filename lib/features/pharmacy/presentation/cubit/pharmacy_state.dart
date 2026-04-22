import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/state_status.dart';
import '../../domain/entities/pharmacy_cart_item_entity.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';

part 'pharmacy_state.freezed.dart';

enum PharmacyPaymentMethod { jazzCash, debitCard, cashOnDelivery }

@freezed
abstract class PharmacyState with _$PharmacyState {
  const factory PharmacyState({
    @Default(StateStatus.idle) StateStatus medicinesLoadingStateStatus,
    @Default([]) List<PharmacyMedicineEntity> medicines,
    String? medicinesErrorMessage,
    @Default('') String searchQuery,
    @Default('Islamabad') String selectedCity,
    @Default([]) List<PharmacyCartItemEntity> cartItems,
    @Default(PharmacyPaymentMethod.jazzCash)
    PharmacyPaymentMethod selectedPaymentMethod,
  }) = _PharmacyState;
}

extension PharmacyStateX on PharmacyState {
  int get cartCount =>
      cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
  double get subtotal =>
      cartItems.fold<double>(0, (sum, item) => sum + item.total);
  double get discount => subtotal * 0.08;
  double get deliveryCharges => cartItems.isEmpty ? 0 : 250;
  double get total => (subtotal - discount) + deliveryCharges;
}
