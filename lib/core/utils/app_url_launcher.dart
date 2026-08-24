import 'package:url_launcher/url_launcher.dart';

class AppUrlLauncher {
  AppUrlLauncher._();

  static Future<void> open({
    required String url,
    LaunchMode lunchMode = LaunchMode.externalApplication,
  }) async {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return;
    final uri = Uri.tryParse(trimmed);
    if (uri == null || !uri.hasScheme) return;
    await launchUrl(uri, mode: lunchMode);
  }
}
