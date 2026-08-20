import '../entities/lab_test_item_entity.dart';
import '../entities/lab_test_lab_offer_entity.dart';
import '../entities/lab_test_pricing_entity.dart';
import '../entities/lab_test_vendor_entity.dart';
import 'lab_test_lab_logo_resolver.dart';
import 'lab_test_price_formatter.dart';

class LabTestItemBookingHelper {
  LabTestItemBookingHelper._();

  static const String orderTypeWalkIn = 'WALK_IN';
  static const String orderTypeHomeSampling = 'HOME_SAMPLING';

  static String orderTypeFor({required bool labVisit}) =>
      labVisit ? orderTypeWalkIn : orderTypeHomeSampling;

  static LabTestPricingEntity pricingForItem(LabTestItemEntity item) {
    return pricingForOffer(_cheapestOffer(item.labOffers));
  }

  static LabTestPricingEntity pricingForOffer(LabTestLabOfferEntity? offer) {
    if (offer == null) {
      return const LabTestPricingEntity(
        discountedFee: '',
        originalFee: '',
        discountPercent: 0,
        discountAmount: '0',
        discountCode: '',
        totalAmount: '0',
      );
    }

    return LabTestPricingEntity(
      discountedFee: LabTestPriceFormatter.formatRs(offer.effectivePrice),
      originalFee: offer.hasReducedPrice
          ? LabTestPriceFormatter.formatRs(offer.price)
          : LabTestPriceFormatter.formatRs(offer.effectivePrice),
      discountPercent: offer.hasReducedPrice ? offer.discountPct : 0,
      discountAmount: offer.hasReducedPrice
          ? (offer.price - offer.effectivePrice).toString()
          : '0',
      discountCode: '',
      totalAmount: offer.effectivePrice.toString(),
    );
  }

  static List<LabTestVendorEntity> vendorsForItem(LabTestItemEntity item) {
    final vendorsById = <int, LabTestVendorEntity>{};
    for (final offer in item.labOffers) {
      vendorsById.putIfAbsent(
        offer.labId,
        () => LabTestVendorEntity(
          id: offer.labId.toString(),
          name: offer.labName,
          logoUrl: offer.labLogoUrl.isNotEmpty
              ? offer.labLogoUrl
              : LabTestLabLogoResolver.logoUrlForLab(
                  labSlug: offer.labSlug,
                  labName: offer.labName,
                ),
        ),
      );
    }
    return vendorsById.values.toList(growable: false);
  }

  static List<LabTestVendorEntity> vendorsForPartner({
    required List<LabTestLabOfferEntity> labOffers,
    required String partnerId,
    required bool labVisit,
  }) {
    final orderType = orderTypeFor(labVisit: labVisit);
    final vendorsById = <int, LabTestVendorEntity>{};
    for (final offer in labOffers) {
      if (offer.partnerId != partnerId || offer.orderType != orderType) continue;
      vendorsById.putIfAbsent(
        offer.labId,
        () => _vendorFromOffer(offer),
      );
    }
    return vendorsById.values.toList(growable: false);
  }

  static Set<String> partnerIdsForBookingMethod({
    required List<LabTestLabOfferEntity> labOffers,
    required bool labVisit,
  }) {
    final orderType = orderTypeFor(labVisit: labVisit);
    return labOffers
        .where((offer) => offer.orderType == orderType)
        .map((offer) => offer.partnerId)
        .toSet();
  }

  static LabTestVendorEntity _vendorFromOffer(LabTestLabOfferEntity offer) {
    return LabTestVendorEntity(
      id: offer.labId.toString(),
      name: offer.labName,
      logoUrl: offer.labLogoUrl.isNotEmpty
          ? offer.labLogoUrl
          : LabTestLabLogoResolver.logoUrlForLab(
              labSlug: offer.labSlug,
              labName: offer.labName,
            ),
    );
  }

  static LabTestLabOfferEntity? offerForSelection({
    required List<LabTestLabOfferEntity> labOffers,
    required String partnerId,
    required int labId,
    required bool labVisit,
  }) {
    final orderType = orderTypeFor(labVisit: labVisit);
    for (final offer in labOffers) {
      if (offer.partnerId == partnerId &&
          offer.labId == labId &&
          offer.orderType == orderType) {
        return offer;
      }
    }
    return null;
  }

  static LabTestLabOfferEntity? _cheapestOffer(
    List<LabTestLabOfferEntity> offers,
  ) {
    if (offers.isEmpty) return null;
    return offers.reduce(
      (current, next) =>
          next.effectivePrice < current.effectivePrice ? next : current,
    );
  }
}
