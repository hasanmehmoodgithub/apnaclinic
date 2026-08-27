import '../../../../core/flavor/flavor_config.dart';
import '../../../../generated/assets.dart';

/// Resolves lab/partner media URLs.
///
/// Lab logos use the API value only (no remapping another lab's bundled
/// asset). Missing/unusable lab logos return empty so the UI shows a
/// placeholder. HTTP is upgraded to HTTPS because the app blocks cleartext.
class LabTestMediaUrlResolver {
  LabTestMediaUrlResolver._();

  static const _mediaFolder = 'acs-media';

  static String resolveLabLogo(
    String? raw, {
    String labSlug = '',
    String? labName,
  }) {
    // labSlug / labName kept for call-site compatibility; logos come from API only.
    final _ = (labSlug, labName);
    return _normalizeMediaUrl(raw);
  }

  static String resolvePartnerLogo({
    required String partnerName,
    String? raw,
  }) {
    final resolved = _normalizeMediaUrl(raw);
    if (resolved.isNotEmpty) return resolved;

    final name = partnerName.trim().toLowerCase();
    if (name.contains('mediq')) return Assets.labTestMedIQLogo;
    if (name.contains('oladoc')) return Assets.labTestOladocOgo;
    return '';
  }

  /// Accepts a full `http(s)` URL or a relative media key such as
  /// `apna-clinic/{id}.webp`. Localhost and empty values are ignored.
  static String _normalizeMediaUrl(String? raw) {
    final value = raw?.trim() ?? '';
    if (value.isEmpty) return '';
    if (value.startsWith('assets/')) return value;

    final lower = value.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      final uri = Uri.tryParse(value);
      if (uri == null || uri.host.isEmpty) return '';
      final host = uri.host.toLowerCase();
      if (host == 'localhost' || host == '127.0.0.1') return '';
      if (uri.scheme.toLowerCase() == 'http') {
        return uri.replace(scheme: 'https').toString();
      }
      return value;
    }

    final path = value.replaceFirst(RegExp(r'^/+'), '');
    if (path.isEmpty) return '';

    final base = _apiBase;
    if (path.startsWith('$_mediaFolder/')) {
      return '$base/$path';
    }
    return '$base/$_mediaFolder/$path';
  }

  static String get _apiBase {
    final base = FlavorConfig.apiBaseUrl.trim();
    return base.endsWith('/') ? base.substring(0, base.length - 1) : base;
  }
}
