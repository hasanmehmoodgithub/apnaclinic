import 'package:equatable/equatable.dart';

import '../../domain/entities/lab_test_cart_item.dart';
import '../../domain/entities/lab_test_lab_offer_entity.dart';
import '../../domain/entities/lab_test_patient_details.dart';
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
    this.patientDetails,
  });

  final LabTestBookingArgs args;
  final bool labVisit;
  final int partnerTab;
  final int selectedVendorIndex;
  final List<LabTestCartItem> cartItems;
  final String? loadError;
  final LabTestPatientDetails? patientDetails;

  bool get isLoadingDetail => args.isPending && loadError == null;

  bool get walkInAvailable => LabTestItemBookingHelper.hasOffersForBookingMethod(
        labOffers: scopedLabOffers,
        labVisit: true,
      );

  bool get homeSamplingAvailable =>
      LabTestItemBookingHelper.hasOffersForBookingMethod(
        labOffers: scopedLabOffers,
        labVisit: false,
      );

  List<LabTestLabOfferEntity> get scopedLabOffers =>
      LabTestItemBookingHelper.offersForLab(
        labOffers: args.labOffers,
        labId: args.preferredLabId,
      );

  List<LabTestBookingPartnerOption> get filteredPartners {
    final partnerIds = LabTestItemBookingHelper.partnerIdsForBookingMethod(
      labOffers: scopedLabOffers,
      labVisit: labVisit,
    );
    return args.partners
        .where((partner) => partnerIds.contains(partner.id))
        .toList(growable: false);
  }

  LabTestBookingPartnerOption? get selectedPartner {
    final list = filteredPartners;
    if (list.isNotEmpty) {
      final i = partnerTab.clamp(0, list.length - 1);
      return list[i];
    }
    if (!args.hasPreferredLab || scopedLabOffers.isEmpty) return null;
    final partnerId = scopedLabOffers.first.partnerId;
    for (final partner in args.partners) {
      if (partner.id == partnerId) return partner;
    }
    return null;
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
      labOffers: scopedLabOffers,
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
    if (list.isNotEmpty) {
      final i = selectedVendorIndex.clamp(0, list.length - 1);
      return list[i];
    }
    if (!args.hasPreferredLab) return null;
    return LabTestBookingVendorOption(
      id: args.preferredLabId!.trim(),
      name: (args.preferredLabName ?? '').trim(),
      logoUrl: args.preferredLabLogoUrl ?? '',
    );
  }

  LabTestLabOfferEntity? get selectedOffer {
    final partner = selectedPartner;
    final vendor = selectedVendor;
    if (partner == null || vendor == null) return null;

    final labId = int.tryParse(vendor.id);
    if (labId == null) return null;

    return LabTestItemBookingHelper.offerForSelection(
      labOffers: scopedLabOffers,
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
    LabTestPatientDetails? patientDetails,
  }) {
    return LabTestBookingState(
      args: args ?? this.args,
      labVisit: labVisit ?? this.labVisit,
      partnerTab: partnerTab ?? this.partnerTab,
      selectedVendorIndex:
          selectedVendorIndex ?? this.selectedVendorIndex,
      cartItems: cartItems ?? this.cartItems,
      loadError: clearLoadError ? null : (loadError ?? this.loadError),
      patientDetails: patientDetails ?? this.patientDetails,
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
    patientDetails,
  ];
}
