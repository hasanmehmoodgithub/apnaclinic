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

  bool get walkInAvailable => LabTestItemBookingHelper.hasOffersForBookingMethod(
        labOffers: args.labOffers,
        labVisit: true,
      );

  bool get homeSamplingAvailable =>
      LabTestItemBookingHelper.hasOffersForBookingMethod(
        labOffers: args.labOffers,
        labVisit: false,
      );

  List<LabTestBookingPartnerOption> get filteredPartners {
    final partnerIds = LabTestItemBookingHelper.partnerIdsForBookingMethod(
      labOffers: args.labOffers,
      labVisit: labVisit,
    );
    return args.partners
        .where((partner) => partnerIds.contains(partner.id))
        .toList(growable: false);
  }

  LabTestBookingPartnerOption? get selectedPartner {
    final list = filteredPartners;
    if (list.isEmpty) return null;
    final i = partnerTab.clamp(0, list.length - 1);
    return list[i];
  }

  /// Cart has a partner, but this test only offers a different single partner.
  bool get isSolePartnerMismatchWithCart {
    if (cartItems.isEmpty) return false;
    final cartPartnerId = cartItems.first.partnerId.trim();
    if (cartPartnerId.isEmpty) return false;
    final partners = filteredPartners;
    if (partners.length != 1) return false;
    return partners.first.id != cartPartnerId;
  }

  List<LabTestBookingVendorOption> get filteredVendors {
    if (isSolePartnerMismatchWithCart) return const [];

    final partner = selectedPartner;
    if (partner == null) return const [];

    final vendors = LabTestItemBookingHelper.vendorsForPartner(
      labOffers: args.labOffers,
      partnerId: partner.id,
      labVisit: labVisit,
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

  bool get isWalkInUnavailable => labVisit && !walkInAvailable;

  bool get isHomeSamplingUnavailable =>
      !labVisit &&
      (!homeSamplingAvailable ||
          filteredPartners.isEmpty ||
          filteredVendors.isEmpty);

  bool get canAddSelectionToCart =>
      !isWalkInUnavailable &&
      !isHomeSamplingUnavailable &&
      selectedVendor != null &&
      selectedPartner != null &&
      selectedOffer != null;

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

  /// Cart already has a different lab, partner, or booking method.
  /// Add to Cart must warn before mixing (including after returning from listing).
  bool get selectionConflictsWithCart {
    if (cartItems.isEmpty) return false;
    final v = selectedVendor;
    final p = selectedPartner;
    if (v == null || p == null) return false;
    final first = cartItems.first;
    return first.labId != v.id ||
        first.partnerId != p.id ||
        first.bookingMethodIsHomeSample != !labVisit;
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
