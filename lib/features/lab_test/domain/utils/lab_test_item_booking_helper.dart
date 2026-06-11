import '../entities/lab_test_item_entity.dart';
import '../entities/lab_test_lab_offer_entity.dart';
import '../entities/lab_test_pricing_entity.dart';
import '../entities/lab_test_vendor_entity.dart';
import 'lab_test_lab_logo_resolver.dart';
import 'lab_test_price_formatter.dart';

class LabTestItemBookingHelper {
  LabTestItemBookingHelper._();

  static LabTestPricingEntity pricingForItem(LabTestItemEntity item) {
    final offer = _cheapestOffer(item.labOffers);
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
      originalFee: offer.discountPct > 0
          ? LabTestPriceFormatter.formatRs(offer.price)
          : LabTestPriceFormatter.formatRs(offer.effectivePrice),
      discountPercent: offer.discountPct,
      discountAmount: offer.discountPct > 0
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
          logoUrl: LabTestLabLogoResolver.logoUrlForLab(
            labSlug: offer.labSlug,
            labName: offer.labName,
          ),
        ),
      );
    }
    return vendorsById.values.toList(growable: false);
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
