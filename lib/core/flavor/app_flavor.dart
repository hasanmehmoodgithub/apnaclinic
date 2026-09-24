/// Simple flavor enum with all configuration in one place
enum AppFlavor {
  development(
    name: 'Development',
    apiBaseUrl: 'https://jazzred-msa-stg.jazz.com.pk',
    appName: 'Apna Clinic(Dev)',
    enableLogging: true,
    enableDebugFeatures: true,
    appsFlyerDevKey: 'FGDPq7rvSkF9TWvokZ65Qn',
    appsFlyerIosAppId: '6807001663',
  ),
  staging(
    name: 'Staging',
    apiBaseUrl: 'https://jazzred-msa-stg.jazz.com.pk',
    appName: 'Apna Clinic(Staging)',
    enableLogging: true,
    enableDebugFeatures: false,
    appsFlyerDevKey: 'FGDPq7rvSkF9TWvokZ65Qn',
    appsFlyerIosAppId: '6807001663',
  ),
  production(
    name: 'Production',
    apiBaseUrl: 'https://app.apnaclinic.com.pk',
    appName: 'Apna Clinic',
    enableLogging: false,
    enableDebugFeatures: false,
    appsFlyerDevKey: 'FGDPq7rvSkF9TWvokZ65Qn',
    appsFlyerIosAppId: '6807001663',
  );

  final String name;
  final String apiBaseUrl;
  final String appName;
  final bool enableLogging;
  final bool enableDebugFeatures;

  /// AppsFlyer Dev Key (Android + iOS). Empty = skip SDK start.
  final String appsFlyerDevKey;

  /// Numeric Apple App Store id. Required on iOS with [appsFlyerDevKey].
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
