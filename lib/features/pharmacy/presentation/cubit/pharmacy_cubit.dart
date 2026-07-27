import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cities/domain/repositories/cities_repository.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/functional/functional_export.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../../../core/utils/phone_format_utils.dart';
import '../../domain/entities/pharmacy_cart_item_entity.dart';
import '../../domain/entities/pharmacy_checkout_result_entity.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import '../../domain/use_cases/add_to_cart_use_case.dart';
import '../../domain/use_cases/get_pharmacy_cart_use_case.dart';
import '../../domain/use_cases/get_pharmacy_medicines_use_case.dart';
import '../../domain/use_cases/get_pharmacy_product_detail_use_case.dart';
import '../../domain/use_cases/pharmacy_checkout_use_case.dart';
import '../../domain/use_cases/update_pharmacy_cart_quantity_use_case.dart';
import 'pharmacy_state.dart';

class PharmacyCubit extends Cubit<PharmacyState> {
  PharmacyCubit({
    required this.getPharmacyMedicinesUseCase,
    required this.getPharmacyProductDetailUseCase,
    required this.getPharmacyCartUseCase,
    required this.addToCartUseCase,
    required this.updatePharmacyCartQuantityUseCase,
    required this.pharmacyCheckoutUseCase,
    required this.citiesRepository,
    required this.appPref,
  }) : super(const PharmacyState()) {
    loadMedicines();
    // Active cart requires auth — skip for guests.
    if (AuthGuard.isLoggedIn(appPref)) {
      loadCart();
    }
  }

  final GetPharmacyMedicinesUseCase getPharmacyMedicinesUseCase;
  final GetPharmacyProductDetailUseCase getPharmacyProductDetailUseCase;
  final GetPharmacyCartUseCase getPharmacyCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final UpdatePharmacyCartQuantityUseCase updatePharmacyCartQuantityUseCase;
  final PharmacyCheckoutUseCase pharmacyCheckoutUseCase;
  final CitiesRepository citiesRepository;
  final AppPref appPref;

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
    if (!AuthGuard.isLoggedIn(appPref)) return;

    final result = await getPharmacyCartUseCase(const GetPharmacyCartParams());
    if (isClosed) return;

    result.fold(
      (_) {},
      (cart) => emit(
        state.copyWith(
          cartBookingId: cart.bookingId,
          cartItems: cart.items,
          cartAddresses: cart.addresses,
          paymentBreakdown: cart.paymentBreakdown,
        ),
      ),
    );
  }

  Future<bool> addToCartApi(
    PharmacyMedicineEntity medicine, {
    int quantity = 1,
  }) async {
    if (!AuthGuard.isLoggedIn(appPref)) return false;

    final addQty = quantity < 1 ? 1 : quantity;
    final existingIndex = state.cartItems.indexWhere(
      (item) => item.medicine.id == medicine.id,
    );

    // Product already in cart → increase quantity via update API only.
    if (existingIndex >= 0) {
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
        cartAddresses: [],
        paymentBreakdown: null,
      ),
    );
  }

  Future<Either<ErrorMsg, PharmacyCheckoutResultEntity>> checkoutOrder({
    required String address,
    required String region,
  }) async {
    if (!AuthGuard.isLoggedIn(appPref)) {
      return const Left(AppStrings.pharmacyCheckoutMissingContextError);
    }

    final trimmedAddress = address.trim();
    final trimmedRegion = region.trim();
    if (trimmedAddress.isEmpty) {
      return const Left(AppStrings.pharmacyCheckoutAddressRequiredError);
    }

    if (state.cartItems.isEmpty) {
      return const Left(AppStrings.pharmacyCheckoutMissingContextError);
    }

    final guestPhone = _resolveGuestPhone();
    final guestName = _resolveGuestName();
    final cityId =
        citiesRepository.cityIdForName(trimmedRegion)?.trim() ?? '';
    final paymentMethod = _paymentMethodApiValue(state.selectedPaymentMethod);

    if (guestPhone.isEmpty || guestName.isEmpty || cityId.isEmpty) {
      return const Left(AppStrings.pharmacyCheckoutMissingContextError);
    }

    return pharmacyCheckoutUseCase(
      PharmacyCheckoutParams(
        guestPhone: guestPhone,
        guestName: guestName,
        paymentMethod: paymentMethod,
        guestAddressCityId: cityId,
      ),
    );
  }

  String _resolveGuestPhone() {
    final phone = appPref.getUserLocalModel()?.phone.trim() ?? '';
    if (phone.isEmpty) return '';
    return PhoneFormatUtils.toMsisdn(phone);
  }

  String _resolveGuestName() {
    final user = appPref.getUserLocalModel();
    if (user == null) return '';
    final fullName = '${user.firstName.trim()} ${user.lastName.trim()}'.trim();
    if (fullName.isNotEmpty) return fullName;
    return user.firstName.trim();
  }

  String _paymentMethodApiValue(PharmacyPaymentMethod method) {
    return switch (method) {
      PharmacyPaymentMethod.jazzCash => 'JAZZCASH',
      PharmacyPaymentMethod.debitCard => 'CARD',
      PharmacyPaymentMethod.cashOnDelivery => 'COD',
    };
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
    if (!AuthGuard.isLoggedIn(appPref)) return false;

    final result = await updatePharmacyCartQuantityUseCase(
      UpdatePharmacyCartQuantityParams(
        productId: medicineId,
        quantity: quantity.toString(),
      ),
    );
    if (isClosed) return false;

    return result.fold(
      (error) {
        log('updateCartQuantity failed: $error');
        return false;
      },
      (updateResult) {
        final nextBookingId =
            (updateResult.bookingId != null &&
                updateResult.bookingId!.trim().isNotEmpty)
            ? updateResult.bookingId!.trim()
            : state.cartBookingId;

        // Prefer server product list only when it actually has items
        // (or quantity was cleared). Empty `products: []` on a qty bump
        // must not wipe the local cart.
        if (updateResult.hasProductList &&
            (updateResult.items.isNotEmpty || quantity <= 0)) {
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
