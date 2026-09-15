import '../../domain/entities/lab_test_vendor_entity.dart';
import '../../domain/utils/lab_test_media_url_resolver.dart';
import '../models/lab_list_response_model.dart';

class LabListMapper {
  LabListMapper._();

  static List<LabTestVendorEntity> toVendors(LabListResponseModel model) {
    return model.labs
        .map(
          (lab) => LabTestVendorEntity(
            id: lab.id,
            name: lab.name,
            logoUrl: LabTestMediaUrlResolver.resolveLabLogo(
              lab.logoUrl,
              labSlug: lab.slug,
              labName: lab.name,
            ),
            publicId: lab.publicId.isEmpty ? null : lab.publicId,
            slug: lab.slug,
            supportsHomeSampling: lab.supportsHomeSampling,
            supportsWalkIn: lab.supportsWalkIn,
            homeSamplingFee: lab.homeSamplingFee,
            rating: lab.rating,
            estimatedReportHours: lab.estimatedReportHours,
          ),
        )
        .toList(growable: false);
  }
}
