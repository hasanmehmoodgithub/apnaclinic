import '../../domain/entities/lab_test_catalog_entity.dart';
import '../../domain/entities/lab_test_item_entity.dart';
import '../../domain/entities/lab_test_lab_offer_entity.dart';
import '../../domain/entities/lab_test_pricing_entity.dart';
import '../../domain/entities/lab_test_vendor_entity.dart';
import '../../domain/utils/lab_test_item_booking_helper.dart';
import '../../domain/utils/lab_test_lab_logo_resolver.dart';
import '../../domain/utils/lab_test_partner_resolver.dart';
import '../../domain/utils/lab_test_price_formatter.dart';
import '../constants/lab_test_catalog_defaults.dart';
import '../models/lab_test_mobile_tests_response_model.dart';

class LabTestMobileTestsMapper {
  static LabTestCatalogEntity toEntity(LabTestMobileTestsResponseModel model) {
    final items = model.data.items
        .map(_toItemEntity)
        .where((item) => item.title.isNotEmpty)
        .toList(growable: false);

    return LabTestCatalogEntity(
      cities: const [],
      items: items,
      requirementLines: LabTestCatalogDefaults.requirementLines,
      partners: LabTestCatalogDefaults.partners,
      vendors: _buildVendors(items),
      pricing: _buildFallbackPricing(items),
    );
  }

  static LabTestItemEntity _toItemEntity(LabTestMobileItemModel model) {
    final labOffers = model.labs.map(_toLabOfferEntity).toList(growable: false);
    final bestOffer = _cheapestOffer(labOffers);
    final labNames = <String>{};
    for (final offer in labOffers) {
      if (offer.labName.isNotEmpty) {
        labNames.add(offer.labName);
      }
    }

    return LabTestItemEntity(
      id: model.testId.toString(),
      title: model.testName,
      sampleType: _formatSampleType(model.sampleType),
      labsSummary: labNames.join(', '),
      requirement: model.fastingRequired ? 'Fasting' : null,
      discountedFee: bestOffer == null
          ? null
          : LabTestPriceFormatter.formatRs(bestOffer.effectivePrice),
      originalFee: bestOffer == null || bestOffer.discountPct <= 0
          ? null
          : LabTestPriceFormatter.formatRs(bestOffer.price),
      labOffers: labOffers,
      description: model.description.isEmpty ? null : model.description,
      turnaroundHours: model.turnaroundHours,
    );
  }

  static LabTestLabOfferEntity _toLabOfferEntity(LabTestMobileLabModel model) {
    return LabTestLabOfferEntity(
      labId: model.labId,
      labName: model.labName,
      labSlug: model.labSlug,
      partnerId: LabTestPartnerResolver.partnerIdForLabSlug(model.labSlug),
      orderType: model.orderType,
      price: model.price,
      finalPrice: model.finalPrice ??
          (model.discountPct > 0
              ? (model.price * (100 - model.discountPct) / 100).round()
              : model.price),
      discountPct: model.discountPct,
      supportsWalkIn: model.supportsWalkIn,
      homeSamplingFee: model.homeSamplingFee,
      supportsHomeSampling: model.supportsHomeSampling,
      labLogoUrl: LabTestLabLogoResolver.logoUrlForLab(
        labSlug: model.labSlug,
        labName: model.labName,
      ),
    );
  }

  static List<LabTestVendorEntity> _buildVendors(List<LabTestItemEntity> items) {
    final vendorsById = <int, LabTestVendorEntity>{};
    for (final item in items) {
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
    }
    return vendorsById.values.toList(growable: false);
  }

  static LabTestPricingEntity? _buildFallbackPricing(List<LabTestItemEntity> items) {
    final first = items.isNotEmpty ? items.first : null;
    final offer = first == null ? null : _cheapestOffer(first.labOffers);
    if (offer == null) return null;

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

  static LabTestLabOfferEntity? _cheapestOffer(List<LabTestLabOfferEntity> offers) {
    if (offers.isEmpty) return null;
    return offers.reduce(
      (current, next) =>
          next.effectivePrice < current.effectivePrice ? next : current,
    );
  }

  static String _formatSampleType(String raw) {
    final normalized = raw.trim().toLowerCase();
    if (normalized.isEmpty) return raw;
    return normalized[0].toUpperCase() + normalized.substring(1);
  }

  static LabTestPricingEntity pricingForItem(LabTestItemEntity item) =>
      LabTestItemBookingHelper.pricingForItem(item);

  static List<LabTestVendorEntity> vendorsForItem(LabTestItemEntity item) =>
      LabTestItemBookingHelper.vendorsForItem(item);
}
