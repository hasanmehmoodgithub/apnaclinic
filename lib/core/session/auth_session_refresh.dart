import 'package:flutter/foundation.dart';

/// Signals login/logout so [MainNavigationShell] can remount tabs and reload data.
class AuthSessionRefresh extends ChangeNotifier {
  int _epoch = 0;
  int _profileRevision = 0;
  bool _selectHomeOnNextRefresh = false;
  bool _reloadPromotionalBannerOnNextRefresh = false;
  int? _pendingTabIndex;

  int get epoch => _epoch;

  /// Increments when local profile prefs change (name, image, etc.).
  /// Listeners like menu can rebuild without remounting shell tabs.
  int get profileRevision => _profileRevision;

  /// After OTP login: remount tabs and optionally open the Home tab.
  ///
  /// When [requestTabIndex] was set before login (e.g. Instant Doctor /
  /// Bookings), home is not forced so the pending tab can resume.
  void notifyLoggedIn({bool selectHomeTab = true}) {
    _selectHomeOnNextRefresh =
        _pendingTabIndex != null ? false : selectHomeTab;
    _reloadPromotionalBannerOnNextRefresh = true;
    _epoch++;
    notifyListeners();
  }

  /// After logout: remount tabs as guest and clear profile state.
  void notifyLoggedOut() {
    _selectHomeOnNextRefresh = false;
    _reloadPromotionalBannerOnNextRefresh = false;
    _pendingTabIndex = null;
    _epoch++;
    notifyListeners();
  }

  /// Call after persisting profile fields so open surfaces (menu, header) refresh.
  void notifyProfileUpdated() {
    _profileRevision++;
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

  /// Switch bottom nav tab after menu (or other overlay) closes.
  ///
  /// Safe to call before login: the shell only consumes this after the user
  /// is logged in (so Instant Doctor / Bookings can resume post-OTP).
  void requestTabIndex(int index) {
    _pendingTabIndex = index;
    notifyListeners();
  }

  /// Clears a queued tab (e.g. on logout) without switching.
  void clearPendingTabIndex() {
    _pendingTabIndex = null;
  }

  /// Consumed by [MainNavigationShell]; returns tab index once per request.
  int? consumePendingTabIndex() {
    final value = _pendingTabIndex;
    _pendingTabIndex = null;
    return value;
  }
}
