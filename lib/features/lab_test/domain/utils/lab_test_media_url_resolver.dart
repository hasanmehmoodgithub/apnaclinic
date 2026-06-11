import '../../../../generated/assets.dart';
import 'lab_test_lab_logo_resolver.dart';

class LabTestMediaUrlResolver {
  LabTestMediaUrlResolver._();

  static String resolveLabLogo(String? raw, {required String labSlug, String? labName}) {
    final local = LabTestLabLogoResolver.logoUrlForLab(
      labSlug: labSlug,
      labName: labName ?? labSlug,
    );
    if (local.isNotEmpty) return local;

    final value = raw?.trim() ?? '';
    if (value.startsWith('http')) return value;
    return '';
  }

  static String resolvePartnerLogo({
    required String partnerName,
    String? raw,
  }) {
    final value = raw?.trim() ?? '';
    if (value.startsWith('http')) return value;

    final name = partnerName.trim().toLowerCase();
    if (name.contains('mediq')) return Assets.labTestMedIQLogo;
    if (name.contains('oladoc')) return Assets.labTestOladocOgo;
    return '';
  }
}
