class ConsultationBookingAttachmentConfig {
  ConsultationBookingAttachmentConfig._();

  /// Maximum number of attachments allowed per consultation booking.
  static const int maxFileCount = 5;

  /// Maximum allowed size per attachment when booking a consultation.
  static const int maxFileSizeBytes = 1024 * 1024; // 1 MB
}
