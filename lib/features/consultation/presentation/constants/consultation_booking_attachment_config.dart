class ConsultationBookingAttachmentConfig {
  ConsultationBookingAttachmentConfig._();

  /// Maximum number of attachments allowed per consultation booking.
  static const int maxFileCount = 5;

  /// Maximum allowed size per attachment when booking a consultation.
  static const int maxFileSizeBytes = 1024 * 1024; // 1 MB

  /// Images and PDF only — audio and other types are rejected on the upload page.
  static const Set<String> allowedExtensions = {
    'png',
    'jpg',
    'jpeg',
    'webp',
    'pdf',
  };

  static String extensionOf(String nameOrPath) {
    final value = nameOrPath.trim().toLowerCase();
    final dot = value.lastIndexOf('.');
    if (dot < 0 || dot == value.length - 1) return '';
    return value.substring(dot + 1);
  }

  static bool isAllowedFile({required String name, required String path}) {
    final fromName = extensionOf(name);
    final fromPath = extensionOf(path);
    final ext = fromName.isNotEmpty ? fromName : fromPath;
    return allowedExtensions.contains(ext);
  }
}
