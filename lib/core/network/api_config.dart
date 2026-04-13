import '../flavor/flavor_config.dart';

class ApiConfig {
  /// Get base URL from FlavorConfig based on current flavor
  static String get baseUrl => FlavorConfig.apiBaseUrl;

  /// Get current flavor for debugging/logging
  static String get currentFlavor => FlavorConfig.currentFlavor.name;
}
