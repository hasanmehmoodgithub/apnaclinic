import '../../domain/entities/consultation_doctor_detail_entity.dart';
import 'consultation_doctor_model.dart';

class ConsultationDoctorDetailModel {
  const ConsultationDoctorDetailModel({required this.detail});

  final ConsultationDoctorDetailEntity detail;

  factory ConsultationDoctorDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is! Map) {
      throw 'Doctor details not found.';
    }
    final map = Map<String, dynamic>.from(data);
    final model = ConsultationDoctorModel.fromJson(map);
    return ConsultationDoctorDetailModel(
      detail: ConsultationDoctorDetailEntity(
        id: model.id,
        publicId: model.publicId,
        displayName: model.displayName,
        specialtyName: model.specialtyName,
        yearsOfExperience: model.yearsOfExperience,
        profileImageUrl: model.profileImageUrl,
        consultationFee: model.consultationFee,
        discountPercent: model.discountPercent,
        isFree: model.isFree,
        ratingScore: model.ratingScore,
        qualifications: model.qualifications,
        education: model.education,
        bio: model.bio,
        partnerLabel: model.partnerLabel,
        partnerLogoUrl: model.partnerLogoUrl,
        hospitalId: model.hospitalId,
        partnerDoctorId: model.partnerDoctorId,
        tenantId: model.tenantId,
      ),
    );
  }

  ConsultationDoctorDetailEntity toEntity() => detail;
}
