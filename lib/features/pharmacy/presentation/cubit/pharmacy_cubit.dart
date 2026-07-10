import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cities/domain/repositories/cities_repository.dart';
import '../../../../core/enums/state_status.dart';
import '../../domain/entities/pharmacy_cart_item_entity.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import '../../domain/use_cases/add_to_cart_use_case.dart';
import '../../domain/use_cases/get_pharmacy_cart_use_case.dart';
import '../../domain/use_cases/get_pharmacy_medicines_use_case.dart';
import '../../domain/use_cases/get_pharmacy_product_detail_use_case.dart';
import '../../domain/use_cases/update_pharmacy_cart_quantity_use_case.dart';
import 'pharmacy_state.dart';

class PharmacyCubit extends Cubit<PharmacyState> {
  PharmacyCubit({
    required this.getPharmacyMedicinesUseCase,
    required this.getPharmacyProductDetailUseCase,
    required this.getPharmacyCartUseCase,
    required this.addToCartUseCase,
    required this.updatePharmacyCartQuantityUseCase,
    required this.citiesRepository,
  }) : super(const PharmacyState()) {
    loadMedicines();
    loadCart();
  }

  final GetPharmacyMedicinesUseCase getPharmacyMedicinesUseCase;
  final GetPharmacyProductDetailUseCase getPharmacyProductDetailUseCase;
  final GetPharmacyCartUseCase getPharmacyCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final UpdatePharmacyCartQuantityUseCase updatePharmacyCartQuantityUseCase;
  final CitiesRepository citiesRepository;

  Future<void> loadMedicines({bool refresh = false}) async {
    final displayName = state.searchQuery.trim();
    emit(
      state.copyWith(
        medicinesLoadingStateStatus: refresh
            ? StateStatus.refreshing
            : StateStatus.loading,
        medicinesErrorMessage: null,
        isLoadingMore: false,
      ),
    );

    final result = await getPharmacyMedicinesUseCase(
      GetPharmacyMedicinesParams(
        page: 1,
        displayName: displayName,
      ),
    );
    if (isClosed) return;

    result.fold(
      (error) => emit(
        state.copyWith(
          medicinesLoadingStateStatus: StateStatus.error,
          medicinesErrorMessage: error,
        ),
      ),
      (page) => emit(
        state.copyWith(
          medicinesLoadingStateStatus: page.items.isEmpty
              ? StateStatus.empty
              : StateStatus.success,
          medicines: page.items,
          currentPage: page.currentPage,
          lastPage: page.lastPage,
          totalProducts: page.total,
          medicinesErrorMessage: null,
        ),
      ),
    );
  }

  Future<void> loadProductDetail(String productId) async {
    final trimmedId = productId.trim();
    if (trimmedId.isEmpty) return;

    emit(
      state.copyWith(
        productDetailLoadingStateStatus: StateStatus.loading,
        productDetailErrorMessage: null,
        selectedProduct: null,
        relatedProducts: const [],
      ),
    );

    final result = await getPharmacyProductDetailUseCase(
      GetPharmacyProductDetailParams(productId: trimmedId),
    );
    if (isClosed) return;

    result.fold(
      (error) => emit(
        state.copyWith(
          productDetailLoadingStateStatus: StateStatus.error,
          productDetailErrorMessage: error,
        ),
      ),
      (detail) => emit(
        state.copyWith(
          productDetailLoadingStateStatus: StateStatus.success,
          selectedProduct: detail.product,
          relatedProducts: detail.relatedItems,
          productDetailErrorMessage: null,
        ),
      ),
    );
  }

  Future<void> loadMoreMedicines() async {
    if (state.isLoadingMore || !state.hasMoreProducts) return;

    emit(state.copyWith(isLoadingMore: true));

    final result = await getPharmacyMedicinesUseCase(
      GetPharmacyMedicinesParams(
        page: state.currentPage + 1,
        displayName: state.searchQuery.trim(),
      ),
    );
    if (isClosed) return;

    result.fold(
      (error) => emit(
        state.copyWith(
          isLoadingMore: false,
          medicinesErrorMessage: error,
        ),
      ),
      (page) => emit(
        state.copyWith(
          isLoadingMore: false,
          medicines: [...state.medicines, ...page.items],
          currentPage: page.currentPage,
          lastPage: page.lastPage,
          totalProducts: page.total,
          medicinesLoadingStateStatus: StateStatus.success,
        ),
      ),
    );
  }

  Future<void> loadCart() async {
    final result = await getPharmacyCartUseCase(const GetPharmacyCartParams());
    if (isClosed) return;

    result.fold(
      (_) {},
      (cart) => emit(
        state.copyWith(
          cartBookingId: cart.bookingId,
          cartItems: cart.items,
          paymentBreakdown: cart.paymentBreakdown,
        ),
      ),
    );
  }

  Future<bool> addToCartApi(
    PharmacyMedicineEntity medicine, {
    int quantity = 1,
  }) async {
    final addQty = quantity < 1 ? 1 : quantity;
    final existingIndex = state.cartItems.indexWhere(
      (item) => item.medicine.id == medicine.id,
    );
    final bookingId = state.cartBookingId?.trim();
    final hasBookingId = bookingId != null && bookingId.isNotEmpty;

    // Product already in cart → increase quantity via update API only.
    if (existingIndex >= 0 && hasBookingId) {
      final nextQty = state.cartItems[existingIndex].quantity + addQty;
      return _setCartQuantity(
        medicineId: medicine.id,
        quantity: nextQty,
      );
    }

    final result = await addToCartUseCase(
      AddToCartParams(
        medicineId: medicine.id,
        quantity: addQty,
        bookingId: hasBookingId ? bookingId : null,
      ),
    );
    if (isClosed) return false;

    return result.fold(
      (_) => false,
      (addResult) {
        _applyAddToCartResult(
          medicine: medicine,
          quantity: addQty,
          bookingId: addResult.bookingId,
          items: addResult.items,
          hasProductList: addResult.hasProductList,
        );
        return true;
      },
    );
  }

  void _applyAddToCartResult({
    required PharmacyMedicineEntity medicine,
    required int quantity,
    required String? bookingId,
    required List<PharmacyCartItemEntity> items,
    required bool hasProductList,
  }) {
    final nextBookingId =
        (bookingId != null && bookingId.trim().isNotEmpty)
        ? bookingId.trim()
        : state.cartBookingId;

    if (hasProductList) {
      emit(
        state.copyWith(
          cartBookingId: nextBookingId,
          cartItems: items,
          paymentBreakdown: null,
        ),
      );
      return;
    }

    final cartItems = [...state.cartItems];
    final index = cartItems.indexWhere((item) => item.medicine.id == medicine.id);
    if (index >= 0) {
      cartItems[index] = cartItems[index].copyWith(
        quantity: cartItems[index].quantity + quantity,
      );
    } else {
      cartItems.add(
        PharmacyCartItemEntity(medicine: medicine, quantity: quantity),
      );
    }

    emit(
      state.copyWith(
        cartBookingId: nextBookingId,
        cartItems: cartItems,
        paymentBreakdown: null,
      ),
    );
  }

  Future<void> increaseQuantity(String medicineId) async {
    await _updateQuantity(medicineId, delta: 1);
  }

  Future<void> decreaseQuantity(String medicineId) async {
    await _updateQuantity(medicineId, delta: -1);
  }

  void removeFromCart(String medicineId) {
    emit(
      state.copyWith(
        cartItems: state.cartItems
            .where((item) => item.medicine.id != medicineId)
            .toList(),
      ),
    );
  }

  void selectPaymentMethod(PharmacyPaymentMethod method) {
    emit(state.copyWith(selectedPaymentMethod: method));
  }

  void submitSearch(String query) {
    final trimmed = query.trim();
    if (trimmed == state.searchQuery) return;
    emit(state.copyWith(searchQuery: trimmed));
    loadMedicines();
  }

  void selectCheckoutCity(String city) {
    emit(state.copyWith(selectedCity: city));
  }

  Future<void> loadCheckoutCities() async {
    await citiesRepository.loadCities();
    if (isClosed) return;

    final names = citiesRepository.cityNames;
    if (names.isEmpty) return;

    final selected = names.contains(state.selectedCity)
        ? state.selectedCity
        : citiesRepository.defaultCityName;

    emit(
      state.copyWith(
        checkoutCities: names,
        selectedCity: selected,
      ),
    );
  }

  void clearCart() {
    emit(
      state.copyWith(
        cartBookingId: null,
        cartItems: [],
        paymentBreakdown: null,
      ),
    );
  }

  Future<void> _updateQuantity(String medicineId, {required int delta}) async {
    final items = state.cartItems;
    final index = items.indexWhere((item) => item.medicine.id == medicineId);
    if (index < 0) return;

    final nextQty = items[index].quantity + delta;
    if (nextQty < 0) return;

    await _setCartQuantity(medicineId: medicineId, quantity: nextQty);
  }

  Future<bool> _setCartQuantity({
    required String medicineId,
    required int quantity,
  }) async {
    final bookingId = state.cartBookingId;
    if (bookingId == null || bookingId.trim().isEmpty) return false;

    final result = await updatePharmacyCartQuantityUseCase(
      UpdatePharmacyCartQuantityParams(
        bookingId: bookingId,
        productId: medicineId,
        quantity: quantity.toString(),
      ),
    );
    if (isClosed) return false;

    return result.fold(
      (_) => false,
      (updateResult) {
        if (updateResult.hasProductList) {
          final nextBookingId =
              (updateResult.bookingId != null &&
                  updateResult.bookingId!.trim().isNotEmpty)
              ? updateResult.bookingId!.trim()
              : state.cartBookingId;
          emit(
            state.copyWith(
              cartBookingId: nextBookingId,
              cartItems: updateResult.items,
              paymentBreakdown: null,
            ),
          );
          return true;
        }

        _applyLocalQuantityUpdate(
          medicineId: medicineId,
          quantity: quantity,
          bookingId: updateResult.bookingId,
        );
        return true;
      },
    );
  }

  void _applyLocalQuantityUpdate({
    required String medicineId,
    required int quantity,
    String? bookingId,
  }) {
    final nextBookingId =
        (bookingId != null && bookingId.trim().isNotEmpty)
        ? bookingId.trim()
        : state.cartBookingId;

    final items = [...state.cartItems];
    final index = items.indexWhere((item) => item.medicine.id == medicineId);
    if (index < 0) {
      if (nextBookingId != state.cartBookingId) {
        emit(
          state.copyWith(
            cartBookingId: nextBookingId,
            paymentBreakdown: null,
          ),
        );
      }
      return;
    }

    if (quantity <= 0) {
      items.removeAt(index);
    } else {
      items[index] = items[index].copyWith(quantity: quantity);
    }

    emit(
      state.copyWith(
        cartBookingId: nextBookingId,
        cartItems: items,
        paymentBreakdown: null,
      ),
    );
  }
}
