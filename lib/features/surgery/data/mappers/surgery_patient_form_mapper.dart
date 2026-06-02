import '../../domain/entities/surgery_patient_form_entity.dart';
import '../models/surgery_patient_form_model.dart';

class SurgeryPatientFormMapper {
  static SurgeryPatientFormEntity toEntity(SurgeryPatientFormModel model) {
    return SurgeryPatientFormEntity(
      doctorId: model.doctorId,
      patientPrefill: SurgeryPatientPrefillEntity(
        patientName: model.patientPrefill.patientName,
        age: model.patientPrefill.age,
        contactNumber: model.patientPrefill.contactNumber,
        emergencyContact: model.patientPrefill.emergencyContact,
      ),
      surgeryOptions: model.surgeryOptions
          .map(
            (option) => SurgeryOptionEntity(
              id: option.id,
              name: option.name,
              price: option.price,
              oldPrice: option.oldPrice,
            ),
          )
          .toList(),
    );
  }
}
