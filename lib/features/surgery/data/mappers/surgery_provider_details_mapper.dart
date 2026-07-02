import '../../domain/entities/surgery_provider_details_entity.dart';
import '../models/surgery_provider_details_model.dart';

class SurgeryProviderDetailsMapper {
  static SurgeryProviderDetailsEntity toEntity(
    SurgeryProviderDetailsModel model,
  ) {
    return SurgeryProviderDetailsEntity(
      doctor: SurgeryProviderDoctorEntity(
        id: model.doctor.id,
        name: model.doctor.name,
        profileImageUrl: model.doctor.profileImageUrl,
        yearsOfExperience: model.doctor.yearsOfExperience,
        education: model.doctor.education,
        bio: model.doctor.bio,
        specialty: model.doctor.specialty,
        partnerId: model.doctor.partnerId,
        partnerName: model.doctor.partnerName,
        partnerLogoUrl: model.doctor.partnerLogoUrl,
      ),
      packages: model.packages
          .map(
            (item) => SurgeryPackageEntity(
              packageId: item.packageId,
              packageName: item.packageName,
              price: item.price,
              oldPrice: item.oldPrice,
              tatMessage: item.tatMessage,
              hospitalId: item.hospitalId,
              hospitalName: item.hospitalName,
            ),
          )
          .toList(),
    );
  }
}
