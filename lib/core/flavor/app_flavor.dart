/// Simple flavor enum with all configuration in one place
enum AppFlavor {
  development(
    name: 'Development',
    apiBaseUrl: 'https://jazzred-msa-stg.jazz.com.pk',
    appName: 'Apna Clinic(Dev)',
    enableLogging: true,
    enableDebugFeatures: true,
    // Replace when business shares AppsFlyer credentials.
    appsFlyerDevKey: '',
    appsFlyerIosAppId: '',
  ),
  staging(
    name: 'Staging',
    apiBaseUrl: 'https://jazzred-msa-stg.jazz.com.pk',
    appName: 'Apna Clinic(Staging)',
    enableLogging: true,
    enableDebugFeatures: false,
    appsFlyerDevKey: '',
    appsFlyerIosAppId: '',
  ),
  production(
    name: 'Production',
    apiBaseUrl: 'https://jazzred-msa-stg.jazz.com.pk',
    appName: 'Apna Clinic',
    enableLogging: false,
    enableDebugFeatures: false,
    appsFlyerDevKey: '',
    appsFlyerIosAppId: '',
  );


  final String name;
  final String apiBaseUrl;
  final String appName;
  final bool enableLogging;
  final bool enableDebugFeatures;

  /// AppsFlyer Dev Key (Android + iOS). Empty = SDK skipped until configured.
  final String appsFlyerDevKey;

  /// Numeric Apple App Store id (iOS only). Required with Dev Key on iOS.
  final String appsFlyerIosAppId;

  const AppFlavor({
    required this.name,
    required this.apiBaseUrl,
    required this.appName,
    required this.enableLogging,
    required this.enableDebugFeatures,
    required this.appsFlyerDevKey,
    required this.appsFlyerIosAppId,
  });
}
