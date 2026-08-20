import '../../../../generated/assets.dart';

/// Resolves lab/partner media URLs.
///
/// Lab logos use the API HTTP URL only (no remapping another lab's bundled
/// asset). Missing/unusable lab logos return empty so the UI shows a placeholder.
class LabTestMediaUrlResolver {
  LabTestMediaUrlResolver._();

  static String resolveLabLogo(
    String? raw, {
    String labSlug = '',
    String? labName,
  }) {
    // labSlug / labName kept for call-site compatibility; logos come from API only.
    final _ = (labSlug, labName);
    final value = raw?.trim() ?? '';
    return _isUsableHttpUrl(value) ? value : '';
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
