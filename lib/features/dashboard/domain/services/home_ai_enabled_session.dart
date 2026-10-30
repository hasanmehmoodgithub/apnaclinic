import 'package:flutter/foundation.dart';

/// Home `data.aiEnabled` shared outside the home tab.
///
/// Updated when the home panel loads. Consultation AI card and pharmacy
/// prescription scan read this so they stay in sync with the home bot.
class HomeAiEnabledSession extends ChangeNotifier {
  bool _enabled = false;

  bool get isEnabled => _enabled;

  void setEnabled(bool value) {
    if (_enabled == value) return;
    _enabled = value;
    notifyListeners();
  }
}
