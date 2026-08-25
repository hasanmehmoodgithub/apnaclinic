enum InvoiceModuleType {
  consultation,
  lab,
  surgery,
  pharmacy;

  /// Path segment for `GET /mobile/invoice/{moduleType}/{orderId}`.
  String get apiValue => switch (this) {
    InvoiceModuleType.consultation => 'CONSULTATION',
    InvoiceModuleType.lab => 'LAB',
    InvoiceModuleType.surgery => 'SURGERY',
    InvoiceModuleType.pharmacy => 'PHARMACY',
  };
}
