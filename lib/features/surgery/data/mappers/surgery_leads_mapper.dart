import '../../domain/entities/surgery_lead_entity.dart';
import '../models/surgery_lead_model.dart';

class SurgeryLeadsMapper {
  SurgeryLeadsMapper._();

  static SurgeryLeadEntity toEntity(SurgeryLeadModel model) {
    return SurgeryLeadEntity(
      leadId: model.leadId,
      surgeryId: model.surgeryId,
      surgeryType: model.surgeryType,
      subSurgeryType: model.subSurgeryType,
      providerId: model.providerId,
      providerName: model.providerName,
      providerLogoUrl: model.providerLogoUrl,
      doctorId: model.doctorId,
      doctorName: model.doctorName,
      specialty: model.specialty,
      education: model.education,
      hospitalName: model.hospitalName,
      status: model.status,
      paymentAllowed: model.paymentAllowed,
      leadCreatedDate: model.leadCreatedDate,
      leadCreatedTime: model.leadCreatedTime,
      leadCreatedAt: model.leadCreatedAt,
      confirmedDate: model.confirmedDate,
      scheduledDate: model.scheduledDate,
      patientName: model.patientName,
      age: model.age,
      gender: model.gender,
      phone: model.phone,
      emergencyPhone: model.emergencyPhone,
      fee: model.fee,
      discount: model.discount,
      total: model.total,
      currency: model.currency,
    );
  }

  static SurgeryLeadsPageEntity toPageEntity(SurgeryLeadsPageModel model) {
    return SurgeryLeadsPageEntity(
      items: model.items.map(toEntity).toList(growable: false),
      page: model.page,
      limit: model.limit,
      total: model.total,
      totalPages: model.totalPages,
    );
  }
}
