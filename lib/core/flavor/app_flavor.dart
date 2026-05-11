/// Simple flavor enum with all configuration in one place
enum AppFlavor {
  development(
    name: 'Development',
    apiBaseUrl: 'http://apnaclinic-auth.apps.jpocp.jazz.com.pk',
    appName: 'My App (Dev)',
    enableLogging: true,
    enableDebugFeatures: true,
  ),
  staging(
    name: 'Staging',
    apiBaseUrl: 'https://staging-api.example.com/api',
    appName: 'My App (Staging)',
    enableLogging: true,
    enableDebugFeatures: false,
  ),
  production(
    name: 'Production',
    apiBaseUrl: 'https://api.example.com/api',
    appName: 'My App',
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
