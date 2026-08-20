class PaymentWebViewArgs {
  const PaymentWebViewArgs({
    required this.paymentUrl,
    this.title,
    this.allowClose = false,
  });

  final String paymentUrl;
  final String? title;

  /// When true, shows a close control and allows leaving without gateway result.
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
