import '../../data/models/consultation_doctor_model.dart';
import '../../domain/entities/consultation_doctor_detail_entity.dart';
import '../widgets/results_doctor_item.dart';

extension ConsultationDoctorDetailMapper on ConsultationDoctorDetailEntity {
  ResultsDoctorItem toResultsDoctorItem() {
    return ConsultationDoctorModel(
      id: id,
      publicId: publicId,
      displayName: displayName,
      specialtyName: specialtyName,
      yearsOfExperience: yearsOfExperience,
      profileImageUrl: profileImageUrl,
      consultationFee: consultationFee,
      discountPercent: discountPercent,
      isFree: isFree,
      ratingScore: ratingScore,
      qualifications: qualifications,
      education: education,
      bio: bio,
      partnerLabel: partnerLabel,
      partnerLogoUrl: partnerLogoUrl,
      hospitalId: hospitalId,
      partnerDoctorId: partnerDoctorId,
      tenantId: tenantId,
    ).toResultsDoctorItem();
  }
}
