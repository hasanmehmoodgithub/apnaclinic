import '../../../../generated/assets.dart';
import '../../domain/entities/lab_test_partner_entity.dart';

class LabTestCatalogDefaults {
  LabTestCatalogDefaults._();

  static const List<String> requirementLines = [
    'Fast for 9-12 Hours before Appointment time',
    'Avoid Strenuous Physical Activity the day of the appointment',
    'Ensure that you are NOT taking any antibiotic medication course',
  ];

  static const List<LabTestPartnerEntity> partners = [
    LabTestPartnerEntity(
      id: 'mediq',
      name: 'MedIQ',
      logoUrl: Assets.labTestMedIQLogo,
    ),
    LabTestPartnerEntity(
      id: 'oladoc',
      name: 'Oladoc',
      logoUrl: Assets.labTestOladocOgo,
    ),
  ];
}
