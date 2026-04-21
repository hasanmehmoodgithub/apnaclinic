import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/state_status.dart';
import '../../domain/entities/pharmacy_cart_item_entity.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import '../../domain/use_cases/add_to_cart_use_case.dart';
import '../../domain/use_cases/get_pharmacy_cart_use_case.dart';
import '../../domain/use_cases/get_pharmacy_medicines_use_case.dart';
import 'pharmacy_state.dart';

class PharmacyCubit extends Cubit<PharmacyState> {
  PharmacyCubit({
    required this.getPharmacyMedicinesUseCase,
    required this.getPharmacyCartUseCase,
    required this.addToCartUseCase,
  })
      : super(const PharmacyState()) {
    loadMedicines();
    loadCart();
  }

  final GetPharmacyMedicinesUseCase getPharmacyMedicinesUseCase;
  final GetPharmacyCartUseCase getPharmacyCartUseCase;
  final AddToCartUseCase addToCartUseCase;

  Future<void> loadMedicines({bool refresh = false}) async {
    emit(
      state.copyWith(
        medicinesLoadingStateStatus: refresh
            ? StateStatus.refreshing
            : StateStatus.loading,
        medicinesErrorMessage: null,
      ),
    );

    final result =
        await getPharmacyMedicinesUseCase(const GetPharmacyMedicinesParams());
    if (isClosed) return;

    result.fold(
      (error) => emit(
        state.copyWith(
          medicinesLoadingStateStatus: StateStatus.error,
          medicinesErrorMessage: error,
        ),
      ),
      (data) => emit(
        state.copyWith(
          medicinesLoadingStateStatus:
              data.isEmpty ? StateStatus.empty : StateStatus.success,
          medicines: data,
          medicinesErrorMessage: null,
        ),
      ),
    );
  }

  Future<void> loadCart() async {
    final result = await getPharmacyCartUseCase(const GetPharmacyCartParams());
    if (isClosed) return;

    result.fold(
      (_) {},
      (items) => emit(state.copyWith(cartItems: items)),
    );
  }

  void addToCart(PharmacyMedicineEntity medicine, {int quantity = 1}) {
    final existingIndex =
        state.cartItems.indexWhere((item) => item.medicine.id == medicine.id);
    final items = [...state.cartItems];

    if (existingIndex >= 0) {
      final existing = items[existingIndex];
      items[existingIndex] =
          existing.copyWith(quantity: existing.quantity + quantity);
    } else {
      items.add(PharmacyCartItemEntity(medicine: medicine, quantity: quantity));
    }
    emit(state.copyWith(cartItems: items));
  }

  Future<bool> addToCartApi(PharmacyMedicineEntity medicine, {int quantity = 1}) async {
    final result = await addToCartUseCase(
      AddToCartParams(medicineId: medicine.id, quantity: quantity),
    );
    if (isClosed) return false;

    return result.fold(
      (_) {
        // Keep cart UX responsive even if API is temporarily unavailable.
        addToCart(medicine, quantity: quantity);
        return true;
      },
      (_) {
        addToCart(medicine, quantity: quantity);
        return true;
      },
    );
  }

  void increaseQuantity(String medicineId) {
    _updateQuantity(medicineId, delta: 1);
  }

  void decreaseQuantity(String medicineId) {
    _updateQuantity(medicineId, delta: -1);
  }

  void removeFromCart(String medicineId) {
    emit(
      state.copyWith(
        cartItems:
            state.cartItems.where((item) => item.medicine.id != medicineId).toList(),
      ),
    );
  }

  void selectPaymentMethod(PharmacyPaymentMethod method) {
    emit(state.copyWith(selectedPaymentMethod: method));
  }

  void clearCart() {
    emit(state.copyWith(cartItems: []));
  }

  void _updateQuantity(String medicineId, {required int delta}) {
    final items = [...state.cartItems];
    final index = items.indexWhere((item) => item.medicine.id == medicineId);
    if (index < 0) return;
    final nextQty = items[index].quantity + delta;
    if (nextQty <= 0) {
      items.removeAt(index);
    } else {
      items[index] = items[index].copyWith(quantity: nextQty);
    }
    emit(state.copyWith(cartItems: items));
  }
}
