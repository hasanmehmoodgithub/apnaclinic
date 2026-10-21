/// Prescription OCR service. Override with `--dart-define` without a code change.
class PrescriptionExtractConfig {
  PrescriptionExtractConfig._();

  static const baseUrl = String.fromEnvironment(
    'PRESCRIPTION_EXTRACT_BASE_URL',
    defaultValue: 'http://142.86.120.73:8001',
  );

  static const apiKey = String.fromEnvironment(
    'PRESCRIPTION_EXTRACT_API_KEY',
    defaultValue: 'UZyoWTmzVwu_Yr4ayDBiEZ3VIYf-_CBnKKO_ZNecjIY',
  );

  static const extractPath = '/extract';
}
