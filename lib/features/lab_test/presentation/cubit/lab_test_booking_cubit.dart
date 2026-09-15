import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/lab_test_cart_item.dart';
import '../../domain/entities/lab_test_patient_details.dart';
import '../../domain/repositories/lab_test_cart_repository.dart';
import '../../domain/use_cases/get_lab_test_detail_use_case.dart';
import '../../domain/utils/lab_test_item_booking_helper.dart';
import '../lab_test_analytics.dart';
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
    emit(
      state.copyWith(
        cartItems: items,
        patientDetails: state.patientDetails ?? _patientFromCart(items),
      ),
    );
    _applyCartSelectionPreferences();
  }

  void setPatientDetails(LabTestPatientDetails details) {
    emit(state.copyWith(patientDetails: details));
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

        final scopedOffers = LabTestItemBookingHelper.offersForLab(
          labOffers: detail.labOffers,
          labId: args.preferredLabId,
        );
        final labVisit = LabTestItemBookingHelper.resolveInitialLabVisit(
          labOffers: scopedOffers.isNotEmpty ? scopedOffers : detail.labOffers,
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
              preferredLabId: args.preferredLabId,
              preferredLabName: args.preferredLabName,
              preferredLabLogoUrl: args.preferredLabLogoUrl,
            ),
            clearLoadError: true,
            labVisit: labVisit,
            partnerTab: 0,
            selectedVendorIndex: 0,
          ),
        );
        _applyPreferredLabSelection();
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
    LabTestAnalytics.logAddToCart(
      testName: line.testTitle,
      labName: line.labDisplayName,
      partnerName: partner.name,
      sampleType: line.sampleType,
      bookingMethodIsHomeSample: line.bookingMethodIsHomeSample,
    );
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
    _applyPreferredLabSelection();
    _selectCartPartnerForCurrentMethod();
  }

  void setPartnerTab(int index) =>
      emit(state.copyWith(partnerTab: index, selectedVendorIndex: 0));

  void setVendorIndex(int index) =>
      emit(state.copyWith(selectedVendorIndex: index));

  /// Prefill booking method + partner (+ lab when available) from the cart.
  void _applyPreferredLabSelection() {
    if (state.args.isPending || !state.args.hasPreferredLab) return;
    final labId = state.args.preferredLabId!.trim();
    final partners = state.filteredPartners;
    for (var partnerIndex = 0; partnerIndex < partners.length; partnerIndex++) {
      final partner = partners[partnerIndex];
      final vendors = LabTestItemBookingHelper.vendorsForPartner(
        labOffers: state.scopedLabOffers,
        partnerId: partner.id,
        labVisit: state.labVisit,
      );
      final vendorIndex = vendors.indexWhere((v) => v.id == labId);
      if (vendorIndex < 0) continue;
      emit(
        state.copyWith(
          partnerTab: partnerIndex,
          selectedVendorIndex: vendorIndex,
        ),
      );
      return;
    }
  }

  /// Prefill booking method + partner (+ lab when available) from the cart.
  void _applyCartSelectionPreferences() {
    if (state.args.hasPreferredLab) {
      _applyPreferredLabSelection();
      return;
    }
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
      labOffers: state.scopedLabOffers,
      labVisit: state.labVisit,
    );
    final partners = state.args.partners
        .where((partner) => partnerIds.contains(partner.id))
        .toList(growable: false);
    final partnerIndex = partners.indexWhere((p) => p.id == partnerId);
    if (partnerIndex < 0) return;

    final vendors = LabTestItemBookingHelper.vendorsForPartner(
      labOffers: state.scopedLabOffers,
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
      partnerName: partner.name,
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
      patientName: state.patientDetails?.name ?? '',
      patientAge: state.patientDetails?.age ?? '',
      patientGender: state.patientDetails?.gender ?? '',
    );
  }

  LabTestPatientDetails? _patientFromCart(List<LabTestCartItem> items) {
    if (items.isEmpty) return null;
    final first = items.first;
    final name = first.patientName.trim();
    if (name.isEmpty) return null;
    return LabTestPatientDetails(
      name: name,
      age: first.patientAge,
      gender: first.patientGender == 'female' ? 'female' : 'male',
    );
  }
}
