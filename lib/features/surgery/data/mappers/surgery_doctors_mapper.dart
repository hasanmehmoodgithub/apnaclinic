import '../../domain/entities/surgery_doctor_entity.dart';
import '../models/surgery_doctor_model.dart';

class SurgeryDoctorsMapper {
  static SurgeryDoctorsEntity toEntity(SurgeryDoctorsResponseModel model) {
    return SurgeryDoctorsEntity(
      procedureName: model.procedureName,
      city: model.city,
      hospitals: model.hospitals,
      specialties: model.specialties,
      doctors: model.doctors.map(_doctorToEntity).toList(),
    );
  }

  static SurgeryDoctorEntity _doctorToEntity(SurgeryDoctorModel model) {
    return SurgeryDoctorEntity(
      id: model.id,
      doctorName: model.doctorName,
      speciality: model.speciality,
      experience: model.experience,
      qualifications: model.qualifications,
      hospitalName: model.hospitalName,
      procedureName: model.procedureName,
      price: model.price,
      oldPrice: model.oldPrice,
      imageUrl: model.imageUrl,
      partnerLogoUrl: model.partnerLogoUrl,
    );
  }
}
