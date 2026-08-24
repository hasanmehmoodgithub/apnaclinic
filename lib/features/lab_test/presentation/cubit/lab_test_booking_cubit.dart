import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/lab_test_cart_item.dart';
import '../../domain/repositories/lab_test_cart_repository.dart';
import '../../domain/use_cases/get_lab_test_detail_use_case.dart';
import '../../domain/utils/lab_test_item_booking_helper.dart';
import '../lab_test_route_args.dart';
import 'lab_test_booking_state.dart';
import 'lab_test_cart_cubit.dart';

class LabTestBookingCubit extends Cubit<LabTestBookingState> {
  LabTestBookingCubit({
    required LabTestBookingArgs args,
    required LabTestCartRepository cartRepository,
    required LabTestCartCubit sharedCartCubit,
    required GetLabTestDetailUseCase getLabTestDetailUseCase,
  })  : _cartRepository = cartRepository,
        _sharedCartCubit = sharedCartCubit,
        _getLabTestDetailUseCase = getLabTestDetailUseCase,
        super(LabTestBookingState(args: args));

  final LabTestCartRepository _cartRepository;
  final LabTestCartCubit _sharedCartCubit;
  final GetLabTestDetailUseCase _getLabTestDetailUseCase;

  Future<void> hydrate() async {
    final items = await _cartRepository.readCart();
    _sharedCartCubit.replaceItems(items);
    emit(state.copyWith(cartItems: items));
    _applyCartSelectionPreferences();
  }

  Future<void> loadDetailIfNeeded() async {
    final args = state.args;
    if (!args.isPending || args.testId == null) return;

    final result = await _getLabTestDetailUseCase(
      GetLabTestDetailParams(testId: args.testId!, cityName: args.city),
    );

    result.fold(
      (message) => emit(state.copyWith(loadError: message)),
      (detail) {
        if (detail.partners.isEmpty || detail.labOffers.isEmpty) {
          emit(
            state.copyWith(
              loadError: 'Lab test data unavailable',
            ),
          );
          return;
        }

        final labVisit = LabTestItemBookingHelper.resolveInitialLabVisit(
          labOffers: detail.labOffers,
          preferLabVisit: state.cartItems.isEmpty
              ? null
              : !state.cartItems.first.bookingMethodIsHomeSample,
        );

        emit(
          state.copyWith(
            args: LabTestBookingArgs.fromDetail(
              detail: detail,
              city: args.city,
              requirementLines: args.requirementLines,
            ),
            clearLoadError: true,
            labVisit: labVisit,
            partnerTab: 0,
            selectedVendorIndex: 0,
          ),
        );
        _applyCartSelectionPreferences();
      },
    );
  }

  Future<void> clearCart() async {
    await _cartRepository.writeCart(const <LabTestCartItem>[]);
    _sharedCartCubit.replaceItems(const <LabTestCartItem>[]);
    emit(state.copyWith(cartItems: const <LabTestCartItem>[]));
  }

  Future<void> addCurrentSelectionToCart() async {
    if (!state.canAddSelectionToCart) return;
    if (state.selectionConflictsWithCart) return;
    final vendor = state.selectedVendor;
    final partner = state.selectedPartner;
    if (vendor == null || partner == null) return;
    final line = _buildCartLine(vendor: vendor, partner: partner);
    final next = [...state.cartItems, line];
    await _cartRepository.writeCart(next);
    _sharedCartCubit.replaceItems(next);
    emit(state.copyWith(cartItems: next));
  }

  void setLabVisit(bool value) {
    if (value && !state.walkInAvailable) return;
    if (!value && !state.homeSamplingAvailable) return;

    emit(
      state.copyWith(
        labVisit: value,
        partnerTab: 0,
        selectedVendorIndex: 0,
      ),
    );
    _selectCartPartnerForCurrentMethod();
  }

  void setPartnerTab(int index) =>
      emit(state.copyWith(partnerTab: index, selectedVendorIndex: 0));

  void setVendorIndex(int index) =>
      emit(state.copyWith(selectedVendorIndex: index));

  /// Prefill booking method + partner (+ lab when available) from the cart.
  void _applyCartSelectionPreferences() {
    if (state.cartItems.isEmpty || state.args.isPending) return;

    final first = state.cartItems.first;
    final labVisit = LabTestItemBookingHelper.resolveInitialLabVisit(
      labOffers: state.args.labOffers,
      preferLabVisit: !first.bookingMethodIsHomeSample,
    );
    emit(
      state.copyWith(
        labVisit: labVisit,
        partnerTab: 0,
        selectedVendorIndex: 0,
      ),
    );
    _selectCartPartnerForCurrentMethod();
  }

  /// Selects the cart's partner tab (and lab) if that partner exists for the
  /// current booking method on this test.
  void _selectCartPartnerForCurrentMethod() {
    if (state.cartItems.isEmpty || state.args.isPending) return;

    final first = state.cartItems.first;
    final partnerId = first.partnerId.trim();
    if (partnerId.isEmpty) return;

    final partnerIds = LabTestItemBookingHelper.partnerIdsForBookingMethod(
      labOffers: state.args.labOffers,
      labVisit: state.labVisit,
    );
    final partners = state.args.partners
        .where((partner) => partnerIds.contains(partner.id))
        .toList(growable: false);
    final partnerIndex = partners.indexWhere((p) => p.id == partnerId);
    if (partnerIndex < 0) return;

    final vendors = LabTestItemBookingHelper.vendorsForPartner(
      labOffers: state.args.labOffers,
      partnerId: partnerId,
      labVisit: state.labVisit,
    );
    final vendorIndex = vendors.indexWhere((v) => v.id == first.labId);

    emit(
      state.copyWith(
        partnerTab: partnerIndex,
        selectedVendorIndex: vendorIndex >= 0 ? vendorIndex : 0,
      ),
    );
  }

  LabTestCartItem _buildCartLine({
    required LabTestBookingVendorOption vendor,
    required LabTestBookingPartnerOption partner,
  }) {
    final a = state.args;
    final pricing = state.currentPricing;
    return LabTestCartItem(
      testId: a.testId ?? 0,
      testTitle: a.testTitle,
      city: a.city,
      labId: vendor.id,
      labDisplayName: vendor.name,
      labLogoUrl: vendor.logoUrl,
      partnerId: partner.id,
      partnerLogoUrl: partner.logoUrl,
      sampleType: a.sampleType,
      requirementLabel: a.requirementLabel,
      requirementLines: a.requirementLines,
      discountedFee: pricing.discountedFee,
      originalFee: pricing.originalFee,
      discountPercent: pricing.discountPercent,
      discountAmount: pricing.discountAmount,
      discountCode: pricing.discountCode,
      totalAmount: pricing.totalAmount,
      bookingMethodIsHomeSample: !state.labVisit,
    );
  }
}
