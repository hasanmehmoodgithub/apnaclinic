import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cities/domain/repositories/cities_repository.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/functional/functional_export.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/preference/app_pref_keys.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../domain/entities/pharmacy_cart_entity.dart';
import '../../domain/entities/pharmacy_cart_item_entity.dart';
import '../../domain/entities/pharmacy_cart_address_entity.dart';
import '../../domain/entities/pharmacy_checkout_result_entity.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import '../../domain/use_cases/abandon_pharmacy_order_use_case.dart';
import '../../domain/use_cases/add_pharmacy_profile_address_use_case.dart';
import '../../domain/use_cases/add_to_cart_use_case.dart';
import '../../domain/use_cases/get_pharmacy_bookings_use_case.dart';
import '../../domain/use_cases/get_pharmacy_cart_use_case.dart';
import '../../domain/use_cases/get_pharmacy_medicines_use_case.dart';
import '../../domain/use_cases/get_pharmacy_product_detail_use_case.dart';
import '../../domain/use_cases/get_pharmacy_profile_addresses_use_case.dart';
import '../../domain/use_cases/pharmacy_checkout_use_case.dart';
import '../../domain/use_cases/update_pharmacy_cart_quantity_use_case.dart';
import '../../domain/use_cases/upload_pharmacy_prescription_use_case.dart';
import 'pharmacy_state.dart';

class PharmacyCubit extends Cubit<PharmacyState> {
  PharmacyCubit({
    required this.getPharmacyMedicinesUseCase,
    required this.getPharmacyProductDetailUseCase,
    required this.getPharmacyCartUseCase,
    required this.addToCartUseCase,
    required this.updatePharmacyCartQuantityUseCase,
    required this.uploadPharmacyPrescriptionUseCase,
    required this.pharmacyCheckoutUseCase,
    required this.abandonPharmacyOrderUseCase,
    required this.getPharmacyBookingsUseCase,
    required this.getPharmacyProfileAddressesUseCase,
    required this.addPharmacyProfileAddressUseCase,
    required this.citiesRepository,
    required this.appPref,
  }) : super(const PharmacyState()) {
    loadMedicines();
  }

  final GetPharmacyMedicinesUseCase getPharmacyMedicinesUseCase;
  final GetPharmacyProductDetailUseCase getPharmacyProductDetailUseCase;
  final GetPharmacyCartUseCase getPharmacyCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final UpdatePharmacyCartQuantityUseCase updatePharmacyCartQuantityUseCase;
  final UploadPharmacyPrescriptionUseCase uploadPharmacyPrescriptionUseCase;
  final PharmacyCheckoutUseCase pharmacyCheckoutUseCase;
  final AbandonPharmacyOrderUseCase abandonPharmacyOrderUseCase;
  final GetPharmacyBookingsUseCase getPharmacyBookingsUseCase;
  final GetPharmacyProfileAddressesUseCase getPharmacyProfileAddressesUseCase;
  final AddPharmacyProfileAddressUseCase addPharmacyProfileAddressUseCase;
  final CitiesRepository citiesRepository;
  final AppPref appPref;

  /// In-session fallback when prefs were not written (e.g. older checkout).
  String? _pendingPaymentOrderId;
  int? _pendingPaymentUnifiedOrderId;

  /// Backend locks cart while an unpaid card checkout is in flight.
  static bool isPaymentInProgressCartError(String message) {
    final normalized = message.trim().toLowerCase();
    if (normalized.isEmpty) return false;
    return normalized.contains(
          'payment for your current order is being processed',
        ) ||
        (normalized.contains('resolve your payment') &&
            normalized.contains('modifying your cart'));
  }

  bool get hasPendingCardPaymentOrder {
    final orderId = _resolvePendingOrderId();
    return orderId.isNotEmpty || (_resolvePendingUnifiedOrderId() != 0);
  }

  String _resolvePendingOrderId() {
    final fromPref =
        (appPref.getString(AppPrefKeys.pharmacyPendingPaymentOrderId) ?? '')
            .trim();
    if (fromPref.isNotEmpty) return fromPref;
    final fromMemory = (_pendingPaymentOrderId ?? '').trim();
    if (fromMemory.isNotEmpty) return fromMemory;
    return (state.cartBookingId ?? '').trim();
  }

  int _resolvePendingUnifiedOrderId() {
    final fromPref =
        appPref.getInt(AppPrefKeys.pharmacyPendingPaymentUnifiedOrderId);
    if (fromPref != null && fromPref != 0) return fromPref;
    final fromMemory = _pendingPaymentUnifiedOrderId;
    if (fromMemory != null && fromMemory != 0) return fromMemory;
    return 0;
  }

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

    await result.fold(
      (_) async {},
      (cart) async {
        emit(
          state.copyWith(
            cartBookingId: cart.bookingId,
            cartItems: _mergePrescriptionUrls(cart.items),
            cartAddresses: cart.addresses,
            paymentBreakdown: cart.paymentBreakdown,
          ),
        );
        if (cart.isAwaitingPayment) {
          await _syncPendingPaymentFromCart(cart);
        }
      },
    );
  }

  Future<void> _syncPendingPaymentFromCart(PharmacyCartEntity cart) async {
    final orderId = (cart.orderId ?? cart.bookingId ?? '').trim();
    final unified = cart.unifiedOrderId ?? 0;
    if (orderId.isEmpty && unified == 0) return;

    _pendingPaymentOrderId =
        orderId.isNotEmpty ? orderId : _pendingPaymentOrderId;
    _pendingPaymentUnifiedOrderId =
        unified != 0 ? unified : _pendingPaymentUnifiedOrderId;

    if (orderId.isNotEmpty) {
      await appPref.setString(
        AppPrefKeys.pharmacyPendingPaymentOrderId,
        orderId,
      );
    }
    if (unified != 0) {
      await appPref.setInt(
        AppPrefKeys.pharmacyPendingPaymentUnifiedOrderId,
        unified,
      );
    }
  }

  /// Uploads prescription file; returns URL on success, null on failure.
  Future<String?> uploadPrescription({
    required String productId,
    required String filePath,
    required String fileName,
  }) async {
    if (!AuthGuard.isLoggedIn(appPref)) return null;

    final result = await uploadPharmacyPrescriptionUseCase(
      UploadPharmacyPrescriptionParams(
        productId: productId,
        filePath: filePath,
        fileName: fileName,
      ),
    );
    if (isClosed) return null;

    return result.fold((_) => null, (url) => url.trim().isEmpty ? null : url);
  }

  /// Returns `null` on success, otherwise a user-facing error message.
  Future<String?> addToCartApi(
    PharmacyMedicineEntity medicine, {
    int quantity = 1,
    String prescriptionUrl = '',
  }) async {
    if (!AuthGuard.isLoggedIn(appPref)) {
      return AppStrings.pharmacyLoadError;
    }

    final addQty = quantity < 1 ? 1 : quantity;
    final existingIndex = state.cartItems.indexWhere(
      (item) => item.medicine.id == medicine.id,
    );

    // Product already in cart → increase quantity via update API only.
    if (existingIndex >= 0) {
      final existing = state.cartItems[existingIndex];
      final nextQty = existing.quantity + addQty;
      final error = await _setCartQuantity(
        medicineId: medicine.id,
        quantity: nextQty,
      );
      if (error != null) return error;
      if (prescriptionUrl.trim().isNotEmpty) {
        _setPrescriptionUrl(medicine.id, prescriptionUrl.trim());
      }
      return null;
    }

    final result = await addToCartUseCase(
      AddToCartParams(
        medicineId: medicine.id,
        quantity: addQty,
      ),
    );
    if (isClosed) return AppStrings.pharmacyLoadError;

    return result.fold(
      (error) => error,
      (addResult) {
        _applyAddToCartResult(
          medicine: medicine,
          quantity: addQty,
          bookingId: addResult.bookingId,
          items: addResult.items,
          hasProductList: addResult.hasProductList,
          prescriptionUrl: prescriptionUrl.trim(),
        );
        return null;
      },
    );
  }

  void _applyAddToCartResult({
    required PharmacyMedicineEntity medicine,
    required int quantity,
    required String? bookingId,
    required List<PharmacyCartItemEntity> items,
    required bool hasProductList,
    String prescriptionUrl = '',
  }) {
    final nextBookingId =
        (bookingId != null && bookingId.trim().isNotEmpty)
        ? bookingId.trim()
        : state.cartBookingId;

    if (hasProductList) {
      var nextItems = _mergePrescriptionUrls(items);
      if (prescriptionUrl.isNotEmpty) {
        nextItems = nextItems
            .map(
              (item) => item.medicine.id == medicine.id
                  ? item.copyWith(prescriptionUrl: prescriptionUrl)
                  : item,
            )
            .toList(growable: false);
      }
      emit(
        state.copyWith(
          cartBookingId: nextBookingId,
          cartItems: nextItems,
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
        prescriptionUrl: prescriptionUrl.isNotEmpty
            ? prescriptionUrl
            : cartItems[index].prescriptionUrl,
      );
    } else {
      cartItems.add(
        PharmacyCartItemEntity(
          medicine: medicine,
          quantity: quantity,
          prescriptionUrl: prescriptionUrl,
        ),
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

  void _setPrescriptionUrl(String medicineId, String url) {
    final cartItems = state.cartItems
        .map(
          (item) => item.medicine.id == medicineId
              ? item.copyWith(prescriptionUrl: url)
              : item,
        )
        .toList(growable: false);
    emit(state.copyWith(cartItems: cartItems));
  }

  List<PharmacyCartItemEntity> _mergePrescriptionUrls(
    List<PharmacyCartItemEntity> items,
  ) {
    if (state.cartItems.isEmpty) return items;
    final byId = <String, String>{
      for (final item in state.cartItems)
        if (item.prescriptionUrl.trim().isNotEmpty)
          item.medicine.id: item.prescriptionUrl.trim(),
    };
    if (byId.isEmpty) return items;
    return items
        .map((item) {
          // Prefer server `prescription_url` when present.
          if (item.prescriptionUrl.trim().isNotEmpty) return item;
          final local = byId[item.medicine.id];
          if (local == null || local.isEmpty) return item;
          return item.copyWith(prescriptionUrl: local);
        })
        .toList(growable: false);
  }

  Future<String?> increaseQuantity(String medicineId) {
    return _updateQuantity(medicineId, delta: 1);
  }

  Future<String?> decreaseQuantity(String medicineId) {
    return _updateQuantity(medicineId, delta: -1);
  }

  Future<String?> removeFromCart(String medicineId) {
    return _setCartQuantity(medicineId: medicineId, quantity: 0);
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

  Future<void> rememberPendingCardPayment(
    PharmacyCheckoutResultEntity checkout,
  ) async {
    if (!checkout.requiresCardPayment) return;
    final orderId = checkout.abandonOrderId;
    final unifiedId = checkout.unifiedOrderId ?? 0;
    if (orderId.isEmpty && unifiedId == 0) return;

    _pendingPaymentOrderId = orderId.isNotEmpty ? orderId : null;
    _pendingPaymentUnifiedOrderId = unifiedId != 0 ? unifiedId : null;

    if (orderId.isNotEmpty) {
      await appPref.setString(
        AppPrefKeys.pharmacyPendingPaymentOrderId,
        orderId,
      );
    }
    await appPref.setInt(
      AppPrefKeys.pharmacyPendingPaymentUnifiedOrderId,
      unifiedId,
    );
    log(
      'rememberPendingCardPayment orderId=$orderId unifiedOrderId=$unifiedId',
    );
  }

  Future<void> clearPendingCardPayment() async {
    _pendingPaymentOrderId = null;
    _pendingPaymentUnifiedOrderId = null;
    await appPref.remove(AppPrefKeys.pharmacyPendingPaymentOrderId);
    await appPref.remove(AppPrefKeys.pharmacyPendingPaymentUnifiedOrderId);
  }

  Future<Either<ErrorMsg, bool>> abandonPendingPaymentOrder() async {
    var orderId = _resolvePendingOrderId();
    var unifiedOrderId = _resolvePendingUnifiedOrderId();

    if (orderId.isEmpty && unifiedOrderId == 0) {
      final recovered = await _recoverPendingPaymentIdsFromBookings();
      orderId = recovered.$1;
      unifiedOrderId = recovered.$2;
    }

    log(
      'abandonPendingPaymentOrder orderId=$orderId unifiedOrderId=$unifiedOrderId',
    );

    final result = await abandonPharmacyOrderUseCase(
      AbandonPharmacyOrderParams(
        orderId: orderId,
        unifiedOrderId: unifiedOrderId,
      ),
    );
    if (isClosed) return result;
    if (result.isLeft) return result;

    await clearPendingCardPayment();
    await loadCart();
    return const Right(true);
  }

  /// Last-resort: find an in-flight pharmacy booking to abandon.
  Future<(String, int)> _recoverPendingPaymentIdsFromBookings() async {
    final result = await getPharmacyBookingsUseCase(
      const GetPharmacyBookingsParams(page: 1, limit: 20),
    );
    return result.fold(
      (_) => ('', 0),
      (page) {
        for (final booking in page.items) {
          final status = booking.status.trim().toUpperCase();
          final isPending = status.contains('PAYMENT') ||
              status.contains('PENDING') ||
              status.contains('AWAITING');
          if (!isPending) continue;

          final orderId = booking.orderId.trim().isNotEmpty
              ? booking.orderId.trim()
              : booking.orderNo.trim();
          final unified = int.tryParse(booking.orderId.trim()) ??
              int.tryParse(booking.orderNo.trim()) ??
              0;
          if (orderId.isEmpty && unified == 0) continue;

          _pendingPaymentOrderId = orderId.isNotEmpty ? orderId : null;
          _pendingPaymentUnifiedOrderId = unified != 0 ? unified : null;
          return (orderId, unified);
        }
        return ('', 0);
      },
    );
  }

  Future<Either<ErrorMsg, PharmacyCheckoutResultEntity>> checkoutOrder({
    required String address,
    required String region,
    String? paymentMethod,
    String? jazzCashNumber,
    String? deliveryInstructions,
    List<PharmacyCheckoutPrescriptionParams>? prescriptions,
  }) async {
    if (!AuthGuard.isLoggedIn(appPref)) {
      return const Left(AppStrings.pharmacyCheckoutMissingContextError);
    }

    final trimmedRegion = region.trim();
    // If address field is empty, use the selected city.
    final trimmedAddress = address.trim().isNotEmpty
        ? address.trim()
        : trimmedRegion;
    if (trimmedAddress.isEmpty) {
      return const Left(AppStrings.pharmacyCheckoutAddressRequiredError);
    }

    if (state.cartItems.isEmpty) {
      return const Left(AppStrings.pharmacyCheckoutMissingContextError);
    }

    final cityId =
        citiesRepository.cityIdForName(trimmedRegion)?.trim() ?? '';
    final resolvedPaymentMethod = (paymentMethod?.trim().isNotEmpty == true)
        ? paymentMethod!.trim().toUpperCase()
        : _paymentMethodApiValue(state.selectedPaymentMethod);
    if (cityId.isEmpty) {
      return const Left(AppStrings.pharmacyCheckoutMissingContextError);
    }

    final checkoutPrescriptions =
        prescriptions ?? _prescriptionsFromCartItems();

    final isJazzCash = resolvedPaymentMethod == 'JAZZCASH';
    final jazzCash = jazzCashNumber?.trim() ?? '';
    if (isJazzCash && jazzCash.isEmpty) {
      return const Left(AppStrings.pharmacyCheckoutMissingContextError);
    }

    final locationResult = await _resolveUserLocationId(
      address: trimmedAddress,
      cityId: cityId,
      cityName: trimmedRegion,
    );
    if (locationResult.isLeft) {
      return Left(locationResult.left);
    }

    final checkoutResult = await pharmacyCheckoutUseCase(
      PharmacyCheckoutParams(
        userLocationId: locationResult.right,
        paymentMethod: resolvedPaymentMethod,
        jazzCashNumber: isJazzCash ? jazzCash : null,
        deliveryInstructions: deliveryInstructions,
        prescriptions: checkoutPrescriptions,
      ),
    );

    await checkoutResult.fold(
      (_) async {},
      (checkout) async {
        if (checkout.requiresCardPayment) {
          await rememberPendingCardPayment(checkout);
        }
      },
    );
    return checkoutResult;
  }

  List<PharmacyCheckoutPrescriptionParams> _prescriptionsFromCartItems() {
    final list = <PharmacyCheckoutPrescriptionParams>[];
    for (final item in state.cartItems) {
      final url = item.prescriptionUrl.trim();
      if (url.isEmpty) continue;
      final productId = int.tryParse(item.medicine.id.trim());
      if (productId == null) continue;
      list.add(
        PharmacyCheckoutPrescriptionParams(productId: productId, url: url),
      );
    }
    return list;
  }

  /// Loads saved pharmacy addresses. Prefill priority: list → profile → city.
  Future<String?> loadProfileAddressesForCheckout() async {
    if (!AuthGuard.isLoggedIn(appPref)) return null;

    final result = await getPharmacyProfileAddressesUseCase();
    if (isClosed) return null;

    return result.fold(
      (_) {
        final profileAddress =
            appPref.getUserLocalModel()?.address.trim() ?? '';
        if (profileAddress.isNotEmpty) return profileAddress;
        return state.selectedCity.trim().isNotEmpty
            ? state.selectedCity.trim()
            : null;
      },
      (addresses) {
        emit(state.copyWith(cartAddresses: addresses));
        if (addresses.isNotEmpty) {
          final first = addresses.first.address.trim();
          if (first.isNotEmpty) return first;
        }
        final profileAddress =
            appPref.getUserLocalModel()?.address.trim() ?? '';
        if (profileAddress.isNotEmpty) return profileAddress;
        return state.selectedCity.trim().isNotEmpty
            ? state.selectedCity.trim()
            : null;
      },
    );
  }

  /// Returns address ID from list when checkout address matches an existing
  /// saved address; otherwise creates a new address and returns its ID.
  Future<Either<ErrorMsg, String>> _resolveUserLocationId({
    required String address,
    required String cityId,
    required String cityName,
  }) async {
    final listResult = await getPharmacyProfileAddressesUseCase();
    if (isClosed) {
      return const Left(AppStrings.pharmacyAddAddressError);
    }

    final existing = listResult.fold(
      (_) => <PharmacyCartAddressEntity>[],
      (items) => items,
    );
    emit(state.copyWith(cartAddresses: existing));

    final matched = _findMatchingSavedAddress(
      address: address,
      cityId: cityId,
      cityName: cityName,
      existing: existing,
    );
    if (matched != null) {
      return Right(matched.id.trim());
    }

    final result = await addPharmacyProfileAddressUseCase(
      AddPharmacyProfileAddressParams(
        address: address,
        region: cityName,
        line1: address,
        cityId: cityId,
        lat: '0',
        long: '0',
      ),
    );
    if (isClosed) {
      return const Left(AppStrings.pharmacyAddAddressError);
    }

    return result.fold(
      Left.new,
      (added) {
        final id = added.id?.trim() ?? '';
        final next = [
          ...state.cartAddresses,
          PharmacyCartAddressEntity(
            id: id,
            address: added.address.trim().isNotEmpty ? added.address : address,
            region: added.region.trim().isNotEmpty ? added.region : cityName,
            cityId: cityId,
          ),
        ];
        emit(state.copyWith(cartAddresses: next));
        if (id.isEmpty) {
          return const Left(AppStrings.pharmacyCheckoutMissingContextError);
        }
        return Right(id);
      },
    );
  }

  PharmacyCartAddressEntity? _findMatchingSavedAddress({
    required String address,
    required String cityId,
    required String cityName,
    required List<PharmacyCartAddressEntity> existing,
  }) {
    final normalizedAddress = _normalizeAddress(address);
    final normalizedCity = _normalizeAddress(cityName);
    final trimmedCityId = cityId.trim();

    for (final item in existing) {
      if (item.id.trim().isEmpty) continue;
      if (_normalizeAddress(item.address) != normalizedAddress) continue;

      final sameCityId = trimmedCityId.isNotEmpty &&
          item.cityId.trim().isNotEmpty &&
          item.cityId.trim() == trimmedCityId;
      final sameCityName = normalizedCity.isNotEmpty &&
          _normalizeAddress(item.region) == normalizedCity;
      // Match on line1; if city metadata exists, require city match too.
      if (item.cityId.trim().isEmpty && item.region.trim().isEmpty) {
        return item;
      }
      if (sameCityId || sameCityName) return item;
    }
    return null;
  }

  String _normalizeAddress(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  String _paymentMethodApiValue(PharmacyPaymentMethod method) {
    return switch (method) {
      PharmacyPaymentMethod.jazzCash => 'JAZZCASH',
      PharmacyPaymentMethod.debitCard => 'CARD',
      PharmacyPaymentMethod.cashOnDelivery => 'COD',
    };
  }

  Future<String?> _updateQuantity(String medicineId, {required int delta}) async {
    final items = state.cartItems;
    final index = items.indexWhere((item) => item.medicine.id == medicineId);
    if (index < 0) return null;

    final nextQty = items[index].quantity + delta;
    if (nextQty < 1) return null;

    return _setCartQuantity(medicineId: medicineId, quantity: nextQty);
  }

  /// Returns `null` on success, otherwise the error message.
  Future<String?> _setCartQuantity({
    required String medicineId,
    required int quantity,
  }) async {
    if (!AuthGuard.isLoggedIn(appPref)) return AppStrings.pharmacyLoadError;

    final result = await updatePharmacyCartQuantityUseCase(
      UpdatePharmacyCartQuantityParams(
        productId: medicineId,
        quantity: quantity.toString(),
      ),
    );
    if (isClosed) return AppStrings.pharmacyLoadError;

    return result.fold(
      (error) {
        log('updateCartQuantity failed: $error');
        return error;
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
          return null;
        }

        _applyLocalQuantityUpdate(
          medicineId: medicineId,
          quantity: quantity,
          bookingId: updateResult.bookingId,
        );
        return null;
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
