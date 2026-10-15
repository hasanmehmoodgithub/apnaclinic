import 'package:flutter/foundation.dart';

/// Signals login/logout so [MainNavigationShell] can remount tabs and reload data.
class AuthSessionRefresh extends ChangeNotifier {
  int _epoch = 0;
  int _profileRevision = 0;
  int _tabRequestRevision = 0;
  bool _selectHomeOnNextRefresh = false;
  bool _reloadPromotionalBannerOnNextRefresh = false;
  int? _pendingTabIndex;
  int? _pendingBookingsSubTabIndex;
  String? _pendingInstantDoctorSourceScreen;
  int _proMembershipRevision = 0;
  bool? _expectedProActive;

  int get epoch => _epoch;

  /// Increments only on [requestTabIndex]. The shell uses this so
  /// [notifyProfileUpdated] does not consume a pending tab during OTP.
  int get tabRequestRevision => _tabRequestRevision;

  /// Increments when local profile prefs change (name, image, etc.).
  /// Listeners like menu can rebuild without remounting shell tabs.
  int get profileRevision => _profileRevision;

  /// Increments after a successful Pro subscribe or unsubscribe.
  int get proMembershipRevision => _proMembershipRevision;

  /// Membership listeners should refresh until details match this value.
  bool? get expectedProActive => _expectedProActive;

  /// After OTP login: remount tabs and optionally open the Home tab.
  ///
  /// When [requestTabIndex] was set before login (e.g. Instant Doctor /
  /// Bookings), home is not forced so the pending tab can resume.
  void notifyLoggedIn({bool selectHomeTab = true}) {
    _selectHomeOnNextRefresh = _pendingTabIndex != null ? false : selectHomeTab;
    _reloadPromotionalBannerOnNextRefresh = true;
    _expectedProActive = null;
    _epoch++;
    notifyListeners();
  }

  /// After logout: remount tabs as guest and clear profile state.
  void notifyLoggedOut() {
    _selectHomeOnNextRefresh = false;
    _reloadPromotionalBannerOnNextRefresh = false;
    _pendingTabIndex = null;
    _pendingBookingsSubTabIndex = null;
    _pendingInstantDoctorSourceScreen = null;
    _expectedProActive = null;
    _epoch++;
    notifyListeners();
  }

  /// Home and menu reload Pro details after subscribe or unsubscribe.
  void notifyProMembershipChanged({required bool isActive}) {
    _expectedProActive = isActive;
    _proMembershipRevision++;
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
  ///
  /// Optional [bookingsSubTabIndex] selects Instant Doctor / Pharmacy /
  /// Doctor Consultation / Lab Tests / Surgery when opening the Bookings tab.
  void requestTabIndex(
    int index, {
    int? bookingsSubTabIndex,
    String? instantDoctorSourceScreen,
  }) {
    _pendingTabIndex = index;
    if (bookingsSubTabIndex != null) {
      _pendingBookingsSubTabIndex = bookingsSubTabIndex;
    }
    _pendingInstantDoctorSourceScreen = instantDoctorSourceScreen;
    _tabRequestRevision++;
    notifyListeners();
  }

  /// Clears a queued tab (e.g. on logout) without switching.
  void clearPendingTabIndex() {
    _pendingTabIndex = null;
    _pendingBookingsSubTabIndex = null;
    _pendingInstantDoctorSourceScreen = null;
  }

  /// Consumed by [MainNavigationShell]; returns tab index once per request.
  int? consumePendingTabIndex() {
    final value = _pendingTabIndex;
    _pendingTabIndex = null;
    return value;
  }

  String? consumePendingInstantDoctorSourceScreen() {
    final value = _pendingInstantDoctorSourceScreen;
    _pendingInstantDoctorSourceScreen = null;
    return value;
  }

  /// Consumed with the Bookings tab; Doctor=0 … Pharmacy=3.
  int? consumePendingBookingsSubTabIndex() {
    final value = _pendingBookingsSubTabIndex;
    _pendingBookingsSubTabIndex = null;
    return value;
  }
}
