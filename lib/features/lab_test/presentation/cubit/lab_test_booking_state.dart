import 'package:equatable/equatable.dart';

import '../../domain/entities/lab_test_cart_item.dart';
import '../../domain/entities/lab_test_lab_offer_entity.dart';
import '../../domain/entities/lab_test_pricing_entity.dart';
import '../../domain/utils/lab_test_item_booking_helper.dart';
import '../lab_test_route_args.dart';

class LabTestBookingState extends Equatable {
  const LabTestBookingState({
    required this.args,
    this.labVisit = true,
    this.partnerTab = 0,
    this.selectedVendorIndex = 0,
    this.cartItems = const [],
    this.loadError,
  });

  final LabTestBookingArgs args;
  final bool labVisit;
  final int partnerTab;
  final int selectedVendorIndex;
  final List<LabTestCartItem> cartItems;
  final String? loadError;

  bool get isLoadingDetail => args.isPending && loadError == null;

  LabTestBookingPartnerOption? get selectedPartner {
    final list = args.partners;
    if (list.isEmpty) return null;
    final i = partnerTab.clamp(0, list.length - 1);
    return list[i];
  }

  List<LabTestBookingVendorOption> get filteredVendors {
    final partner = selectedPartner;
    if (partner == null) return const [];

    final vendors = LabTestItemBookingHelper.vendorsForPartnerAll(
      labOffers: args.labOffers,
      partnerId: partner.id,
    );

    return vendors
        .map(
          (v) => LabTestBookingVendorOption(
            id: v.id,
            name: v.name,
            logoUrl: v.logoUrl,
            markUrl: v.markUrl,
          ),
        )
        .toList(growable: false);
  }

  LabTestBookingVendorOption? get selectedVendor {
    final list = filteredVendors;
    if (list.isEmpty) return null;
    final i = selectedVendorIndex.clamp(0, list.length - 1);
    return list[i];
  }

  LabTestLabOfferEntity? get selectedOffer {
    final partner = selectedPartner;
    final vendor = selectedVendor;
    if (partner == null || vendor == null) return null;

    final labId = int.tryParse(vendor.id);
    if (labId == null) return null;

    return LabTestItemBookingHelper.offerForSelection(
      labOffers: args.labOffers,
      partnerId: partner.id,
      labId: labId,
      labVisit: labVisit,
    );
  }

  LabTestPricingEntity get currentPricing =>
      LabTestItemBookingHelper.pricingForOffer(selectedOffer);

  bool get isHomeSamplingUnavailable =>
      !labVisit && selectedVendor != null && selectedOffer == null;

  bool get canAddSelectionToCart =>
      !isHomeSamplingUnavailable &&
      selectedVendor != null &&
      selectedPartner != null;

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
    LabTestBookingArgs? args,
    bool? labVisit,
    int? partnerTab,
    int? selectedVendorIndex,
    List<LabTestCartItem>? cartItems,
    String? loadError,
    bool clearLoadError = false,
  }) {
    return LabTestBookingState(
      args: args ?? this.args,
      labVisit: labVisit ?? this.labVisit,
      partnerTab: partnerTab ?? this.partnerTab,
      selectedVendorIndex:
          selectedVendorIndex ?? this.selectedVendorIndex,
      cartItems: cartItems ?? this.cartItems,
      loadError: clearLoadError ? null : (loadError ?? this.loadError),
    );
  }

  @override
  List<Object?> get props => [
    args,
    labVisit,
    partnerTab,
    selectedVendorIndex,
    cartItems,
    loadError,
  ];
}
