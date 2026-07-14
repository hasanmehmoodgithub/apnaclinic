import '../../../../generated/assets.dart';

class ConsultationPartnerFilterOption {
  const ConsultationPartnerFilterOption({
    required this.id,
    required this.name,
    this.logoUrl = '',
    this.logoAsset = '',
  });

  /// Tenant / partner id used as `partnerId` query param.
  final String id;
  final String name;

  /// Remote logo from doctors API (`partners[].logoUrl`).
  final String logoUrl;

  /// Local asset fallback when remote logo is missing.
  final String logoAsset;

  String get resolvedLogo =>
      logoUrl.trim().isNotEmpty ? logoUrl.trim() : logoAsset.trim();
}

class ConsultationPartnerFilterDefaults {
  ConsultationPartnerFilterDefaults._();

  /// Known partner catalog keyed by aggregator `tenantId`.
  static const List<ConsultationPartnerFilterOption> partners = [
    ConsultationPartnerFilterOption(
      id: '2',
      name: 'Oladoc',
      logoAsset: Assets.labTestOladocOgo,
    ),
    ConsultationPartnerFilterOption(
      id: '3',
      name: 'MedIQ',
      logoAsset: Assets.labTestMedIQLogo,
    ),
  ];

  static ConsultationPartnerFilterOption? knownById(String id) {
    final trimmed = id.trim();
    if (trimmed.isEmpty) return null;
    for (final partner in partners) {
      if (partner.id == trimmed) return partner;
    }
    return null;
  }

  /// Builds a filter option from doctors-list `partners[]` entry.
  static ConsultationPartnerFilterOption fromApi({
    required String tenantId,
    String? name,
    String? logoUrl,
  }) {
    final id = tenantId.trim();
    final known = knownById(id);
    final resolvedName = (name ?? '').trim().isNotEmpty
        ? name!.trim()
        : (known?.name ?? 'Partner $id');
    final remoteLogo = (logoUrl ?? '').trim();
    return ConsultationPartnerFilterOption(
      id: id,
      name: resolvedName,
      logoUrl: remoteLogo,
      logoAsset: remoteLogo.isEmpty ? (known?.logoAsset ?? '') : '',
    );
  }
}
