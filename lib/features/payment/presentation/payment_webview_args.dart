class PaymentWebViewArgs {
  const PaymentWebViewArgs({
    required this.paymentUrl,
    this.title,
  });

  final String paymentUrl;
  final String? title;
}

PaymentWebViewArgs? paymentWebViewArgsFromExtra(Object? extra) {
  if (extra is PaymentWebViewArgs) return extra;
  if (extra is Map) {
    final url = (extra['paymentUrl'] ?? extra['url'] ?? '').toString().trim();
    if (url.isEmpty) return null;
    return PaymentWebViewArgs(
      paymentUrl: url,
      title: extra['title']?.toString(),
    );
  }
  return null;
}
