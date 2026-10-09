class ProUserWebViewArgs {
  const ProUserWebViewArgs({
    required this.url,
    this.title,
  });

  final String url;
  final String? title;
}

ProUserWebViewArgs? proUserWebViewArgsFromExtra(Object? extra) {
  if (extra is ProUserWebViewArgs) return extra;
  if (extra is Map) {
    final url = (extra['url'] ?? extra['paymentUrl'] ?? '').toString().trim();
    if (url.isEmpty) return null;
    return ProUserWebViewArgs(
      url: url,
      title: extra['title']?.toString(),
    );
  }
  return null;
}
