import '../../../../generated/assets.dart';

class ConsultationPartnerFilterOption {
  const ConsultationPartnerFilterOption({
    required this.id,
    required this.name,
    required this.logoAsset,
  });

  final String id;
  final String name;
  final String logoAsset;
}

class ConsultationPartnerFilterDefaults {
  ConsultationPartnerFilterDefaults._();

  static const List<ConsultationPartnerFilterOption> partners = [
    ConsultationPartnerFilterOption(
      id: '1',
      name: 'Oladoc',
      logoAsset: Assets.labTestOladocOgo,
    ),
    ConsultationPartnerFilterOption(
      id: '2',
      name: 'MedIQ',
      logoAsset: Assets.labTestMedIQLogo,
    ),
  ];
}
