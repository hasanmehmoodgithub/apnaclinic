import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/lab_test_cart_item.dart';
import '../../domain/repositories/lab_test_cart_repository.dart';
import '../lab_test_route_args.dart';
import 'lab_test_booking_state.dart';

class LabTestBookingCubit extends Cubit<LabTestBookingState> {
  LabTestBookingCubit({
    required LabTestBookingArgs args,
    required LabTestCartRepository cartRepository,
  })  : _cartRepository = cartRepository,
        super(LabTestBookingState(args: args));

  final LabTestCartRepository _cartRepository;

  Future<void> hydrate() async {
    final items = await _cartRepository.readCart();
    emit(state.copyWith(cartItems: items));
  }

  Future<void> clearCart() async {
    await _cartRepository.writeCart(const <LabTestCartItem>[]);
    emit(state.copyWith(cartItems: const <LabTestCartItem>[]));
  }

  Future<void> addCurrentSelectionToCart() async {
    final vendor = state.selectedVendor;
    final partner = state.selectedPartner;
    if (vendor == null || partner == null) return;
    final line = _buildCartLine(vendor: vendor, partner: partner);
    final next = [...state.cartItems, line];
    await _cartRepository.writeCart(next);
    emit(state.copyWith(cartItems: next));
  }

  void setLabVisit(bool value) => emit(state.copyWith(labVisit: value));

  void setPartnerTab(int index) => emit(state.copyWith(partnerTab: index));

  void setVendorIndex(int index) =>
      emit(state.copyWith(selectedVendorIndex: index));

  LabTestCartItem _buildCartLine({
    required LabTestBookingVendorOption vendor,
    required LabTestBookingPartnerOption partner,
  }) {
    final a = state.args;
    return LabTestCartItem(
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
      discountedFee: a.discountedFee,
      originalFee: a.originalFee,
      discountPercent: a.discountPercent,
      discountAmount: a.discountAmount,
      discountCode: a.discountCode,
      totalAmount: a.totalAmount,
      bookingMethodIsHomeSample: !state.labVisit,
    );
  }
}
