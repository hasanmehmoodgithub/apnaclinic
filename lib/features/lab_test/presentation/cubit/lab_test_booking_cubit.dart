import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/lab_test_cart_item.dart';
import '../../domain/repositories/lab_test_cart_repository.dart';
import '../../domain/use_cases/get_lab_test_detail_use_case.dart';
import '../lab_test_route_args.dart';
import 'lab_test_booking_state.dart';

class LabTestBookingCubit extends Cubit<LabTestBookingState> {
  LabTestBookingCubit({
    required LabTestBookingArgs args,
    required LabTestCartRepository cartRepository,
    required GetLabTestDetailUseCase getLabTestDetailUseCase,
  })  : _cartRepository = cartRepository,
        _getLabTestDetailUseCase = getLabTestDetailUseCase,
        super(LabTestBookingState(args: args));

  final LabTestCartRepository _cartRepository;
  final GetLabTestDetailUseCase _getLabTestDetailUseCase;

  Future<void> hydrate() async {
    final items = await _cartRepository.readCart();
    emit(state.copyWith(cartItems: items));
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

        emit(
          state.copyWith(
            args: LabTestBookingArgs.fromDetail(
              detail: detail,
              city: args.city,
              requirementLines: args.requirementLines,
            ),
            clearLoadError: true,
            partnerTab: 0,
            selectedVendorIndex: 0,
          ),
        );
      },
    );
  }

  Future<void> clearCart() async {
    await _cartRepository.writeCart(const <LabTestCartItem>[]);
    emit(state.copyWith(cartItems: const <LabTestCartItem>[]));
  }

  Future<void> addCurrentSelectionToCart() async {
    if (!state.canAddSelectionToCart) return;
    final vendor = state.selectedVendor;
    final partner = state.selectedPartner;
    if (vendor == null || partner == null) return;
    final line = _buildCartLine(vendor: vendor, partner: partner);
    final next = [...state.cartItems, line];
    await _cartRepository.writeCart(next);
    emit(state.copyWith(cartItems: next));
  }

  void setLabVisit(bool value) => emit(
        state.copyWith(
          labVisit: value,
          partnerTab: 0,
          selectedVendorIndex: 0,
        ),
      );

  void setPartnerTab(int index) =>
      emit(state.copyWith(partnerTab: index, selectedVendorIndex: 0));

  void setVendorIndex(int index) =>
      emit(state.copyWith(selectedVendorIndex: index));

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
