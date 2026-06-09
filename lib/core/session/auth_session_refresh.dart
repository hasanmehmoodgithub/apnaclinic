import 'package:flutter/foundation.dart';

/// Signals login/logout so [MainNavigationShell] can remount tabs and reload data.
class AuthSessionRefresh extends ChangeNotifier {
  int _epoch = 0;
  bool _selectHomeOnNextRefresh = false;
  bool _reloadPromotionalBannerOnNextRefresh = false;

  int get epoch => _epoch;

  /// After OTP login: remount tabs and optionally open the Home tab.
  void notifyLoggedIn({bool selectHomeTab = true}) {
    _selectHomeOnNextRefresh = selectHomeTab;
    _reloadPromotionalBannerOnNextRefresh = true;
    _epoch++;
    notifyListeners();
  }

  /// After logout: remount tabs as guest and clear profile state.
  void notifyLoggedOut() {
    _selectHomeOnNextRefresh = false;
    _reloadPromotionalBannerOnNextRefresh = false;
    _epoch++;
    notifyListeners();
  }

  /// Returns true once per login refresh; consumed by the shell.
  bool consumeSelectHomeTab() {
    final value = _selectHomeOnNextRefresh;
    _selectHomeOnNextRefresh = false;
    return value;
  }

  /// True only after [notifyLoggedIn]; consumed by the shell before tab remount.
  bool consumeReloadPromotionalBanner() {
    final value = _reloadPromotionalBannerOnNextRefresh;
    _reloadPromotionalBannerOnNextRefresh = false;
    return value;
  }
}
