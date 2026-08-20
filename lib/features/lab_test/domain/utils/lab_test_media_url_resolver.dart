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
    if (value.startsWith('http')) {
      final host = Uri.tryParse(value)?.host.toLowerCase() ?? '';
      if (host.isNotEmpty && host != 'localhost' && host != '127.0.0.1') {
        return value;
      }
    }
    return '';
  }

  static String resolvePartnerLogo({
    required String partnerName,
    String? raw,
  }) {
    final value = raw?.trim() ?? '';
    if (_isUsableHttpUrl(value)) return value;

    final name = partnerName.trim().toLowerCase();
    if (name.contains('mediq')) return Assets.labTestMedIQLogo;
    if (name.contains('oladoc')) return Assets.labTestOladocOgo;
    return '';
  }

  static bool _isUsableHttpUrl(String value) {
    if (!value.startsWith('http')) return false;
    final host = Uri.tryParse(value)?.host.toLowerCase() ?? '';
    return host.isNotEmpty && host != 'localhost' && host != '127.0.0.1';
  }
}
