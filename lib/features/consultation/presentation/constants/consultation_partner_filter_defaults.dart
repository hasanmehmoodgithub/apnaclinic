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
    ConsultationPartnerFilterOption(
      id: '4',
      name: 'Bima',
    ),
    ConsultationPartnerFilterOption(
      id: '5',
      name: 'Apna Clinic',
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

  /// Builds a filter option from doctors-list `partners[]` / doctor `partner`.
  ///
  /// API shape (updated): `{ tenantId, tenant, logoUrl }` where `tenant` is a
  /// slug (`oladoc`, `mediq`, `apna-clinic`) or sometimes a UUID.
  static ConsultationPartnerFilterOption fromApi({
    required String tenantId,
    String? name,
    String? tenantSlug,
    String? logoUrl,
  }) {
    final id = tenantId.trim();
    final known = knownById(id);
    final fromSlug = displayNameFromTenantSlug(tenantSlug);
    final apiName = (name ?? '').trim();
    final resolvedName = apiName.isNotEmpty
        ? apiName
        : (fromSlug ?? known?.name ?? (id.isEmpty ? 'Partner' : 'Partner $id'));
    final remoteLogo = (logoUrl ?? '').trim();
    return ConsultationPartnerFilterOption(
      id: id,
      name: resolvedName,
      logoUrl: remoteLogo,
      logoAsset: remoteLogo.isEmpty ? (known?.logoAsset ?? '') : '',
    );
  }

  /// Turns `partners[].tenant` into a display name; ignores UUID-like values.
  static String? displayNameFromTenantSlug(String? tenant) {
    final raw = (tenant ?? '').trim();
    if (raw.isEmpty) return null;
    if (_looksLikeUuid(raw)) return null;

    switch (raw.toLowerCase()) {
      case 'oladoc':
        return 'Oladoc';
      case 'mediq':
        return 'MedIQ';
      case 'bima':
        return 'Bima';
      case 'apna-clinic':
      case 'apnaclinic':
      case 'apna_clinic':
        return 'Apna Clinic';
    }

    return raw
        .split(RegExp(r'[-_]+'))
        .where((part) => part.isNotEmpty)
        .map(
          (part) =>
              '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  static bool _looksLikeUuid(String value) {
    return RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    ).hasMatch(value);
  }
}
