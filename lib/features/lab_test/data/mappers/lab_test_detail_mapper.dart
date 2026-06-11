import '../../domain/entities/lab_test_detail_entity.dart';
import '../../domain/entities/lab_test_lab_offer_entity.dart';
import '../../domain/entities/lab_test_partner_entity.dart';
import '../../domain/utils/lab_test_media_url_resolver.dart';
import '../models/lab_test_detail_response_model.dart';

class LabTestDetailMapper {
  static LabTestDetailEntity toEntity(LabTestDetailResponseModel model) {
    final data = model.data;
    final partners = data.partners
        .map(
          (partner) => LabTestPartnerEntity(
            id: partner.partnerId.toString(),
            name: partner.partnerName,
            logoUrl: LabTestMediaUrlResolver.resolvePartnerLogo(
              partnerName: partner.partnerName,
              raw: partner.partnerLogoUrl,
            ),
          ),
        )
        .toList(growable: false);

    final labOffers = <LabTestLabOfferEntity>[];
    for (final partner in data.partners) {
      final partnerId = partner.partnerId.toString();
      for (final lab in partner.labs) {
        for (final entry in lab.pricing.entries) {
          labOffers.add(
            LabTestLabOfferEntity(
              labId: lab.labId,
              labName: lab.labName,
              labSlug: lab.labSlug,
              partnerId: partnerId,
              orderType: entry.key,
              price: entry.value.price,
              finalPrice: entry.value.finalPrice,
              discountPct: entry.value.discountPct,
              supportsWalkIn: lab.supportsWalkIn,
              homeSamplingFee: _parseFee(lab.homeSamplingFee),
              supportsHomeSampling: lab.supportsHomeSampling,
              labLogoUrl: LabTestMediaUrlResolver.resolveLabLogo(
                lab.logoUrl,
                labSlug: lab.labSlug,
                labName: lab.labName,
              ),
            ),
          );
        }
      }
    }

    return LabTestDetailEntity(
      id: data.id,
      name: data.name,
      description: data.description,
      sampleType: _formatSampleType(data.sampleType),
      fastingRequired: data.fastingRequired,
      turnaroundHours: data.turnaroundHours,
      partners: partners,
      labOffers: labOffers,
    );
  }

  static int _parseFee(String raw) {
    final parsed = double.tryParse(raw);
    return parsed?.round() ?? 0;
  }

  static String _formatSampleType(String raw) {
    final normalized = raw.trim().toLowerCase();
    if (normalized.isEmpty) return raw;
    return normalized[0].toUpperCase() + normalized.substring(1);
  }
}
