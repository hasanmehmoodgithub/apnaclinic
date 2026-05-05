import 'package:equatable/equatable.dart';

import '../../domain/entities/lab_test_cart_item.dart';
import '../lab_test_route_args.dart';

class LabTestBookingState extends Equatable {
  const LabTestBookingState({
    required this.args,
    this.labVisit = true,
    this.partnerTab = 0,
    this.selectedVendorIndex = 0,
    this.cartItems = const [],
  });

  final LabTestBookingArgs args;
  final bool labVisit;
  final int partnerTab;
  final int selectedVendorIndex;
  final List<LabTestCartItem> cartItems;

  LabTestBookingPartnerOption? get selectedPartner {
    final list = args.partners;
    if (list.isEmpty) return null;
    final i = partnerTab.clamp(0, list.length - 1);
    return list[i];
  }

  LabTestBookingVendorOption? get selectedVendor {
    final list = args.vendors;
    if (list.isEmpty) return null;
    final i = selectedVendorIndex.clamp(0, list.length - 1);
    return list[i];
  }

  bool get isCurrentSelectionInCart {
    final v = selectedVendor;
    final p = selectedPartner;
    if (v == null || p == null) return false;
    return cartItems.any(
      (e) =>
          e.testTitle == args.testTitle &&
          e.labId == v.id &&
          e.partnerId == p.id,
    );
  }

  LabTestBookingState copyWith({
    bool? labVisit,
    int? partnerTab,
    int? selectedVendorIndex,
    List<LabTestCartItem>? cartItems,
  }) {
    return LabTestBookingState(
      args: args,
      labVisit: labVisit ?? this.labVisit,
      partnerTab: partnerTab ?? this.partnerTab,
      selectedVendorIndex:
          selectedVendorIndex ?? this.selectedVendorIndex,
      cartItems: cartItems ?? this.cartItems,
    );
  }

  @override
  List<Object?> get props =>
      [args, labVisit, partnerTab, selectedVendorIndex, cartItems];
}
