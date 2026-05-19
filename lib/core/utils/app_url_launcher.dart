import 'package:url_launcher/url_launcher.dart';

class AppUrlLauncher {
  AppUrlLauncher._();

  static Future<void> open({required String url, LaunchMode lunchMode=LaunchMode.externalApplication}) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: lunchMode);
  }
}
