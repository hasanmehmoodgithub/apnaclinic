/// Simple flavor enum with all configuration in one place
enum AppFlavor {
  development(
    name: 'Development',
    apiBaseUrl: 'https://jazzred-msa-stg.jazz.com.pk',
    appName: 'Apna Clinic(Dev)',
    enableLogging: true,
    enableDebugFeatures: true,
  ),
  staging(
    name: 'Staging',
    apiBaseUrl: 'https://jazzred-msa-stg.jazz.com.pk',
    appName: 'Apna Clinic(Staging)',
    enableLogging: true,
    enableDebugFeatures: false,
  ),
  production(
    name: 'Production',
    apiBaseUrl: 'https://app.apnaclinic.com.pk',
    appName: 'Apna Clinic',
    enableLogging: false,
    enableDebugFeatures: false,
  );


  final String name;
  final String apiBaseUrl;
  final String appName;
  final bool enableLogging;
  final bool enableDebugFeatures;

  const AppFlavor({
    required this.name,
    required this.apiBaseUrl,
    required this.appName,
    required this.enableLogging,
    required this.enableDebugFeatures,
  });
}
