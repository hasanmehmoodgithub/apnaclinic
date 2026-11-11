import 'package:flutter/foundation.dart';

/// Home Pro promo image (`data.bannerUrl`) shared with Menu.
///
/// Updated when the home panel loads so Menu can reuse the same artwork.
class HomeProBannerSession extends ChangeNotifier {
  String _bannerUrl = '';

  String get bannerUrl => _bannerUrl;

  void setBannerUrl(String? value) {
    final next = value?.trim() ?? '';
    if (_bannerUrl == next) return;
    _bannerUrl = next;
    notifyListeners();
  }
}
