class PaymentWebViewArgs {
  const PaymentWebViewArgs({
    required this.paymentUrl,
    this.title,
    this.allowClose = false,
  });

  final String paymentUrl;
  final String? title;

  /// When true, shows an AppBar X; that is the only way to leave without a
  /// gateway result. System back / swipe-back does not dismiss.
  final bool allowClose;
}

PaymentWebViewArgs? paymentWebViewArgsFromExtra(Object? extra) {
  if (extra is PaymentWebViewArgs) return extra;
  if (extra is Map) {
    final url = (extra['paymentUrl'] ?? extra['url'] ?? '').toString().trim();
    if (url.isEmpty) return null;
    return PaymentWebViewArgs(
      paymentUrl: url,
      title: extra['title']?.toString(),
      allowClose: extra['allowClose'] == true,
    );
  }
  return null;
}
