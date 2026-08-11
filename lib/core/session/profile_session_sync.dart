import '../../features/account/domain/entities/account_item_entity.dart';
import '../preference/app_pref.dart';

/// In-memory profile sync state for the current app launch / login session.
///
/// Profile data is persisted in [AppPref]; this guard avoids repeated GET profile
/// calls when opening [ProfileScreen] while cached prefs are still valid.
class ProfileSessionSync {
  bool _synced = false;
  List<AccountItemEntity> _accounts = const [];

  bool get isSynced => _synced;

  List<AccountItemEntity> get cachedAccounts => _accounts;

  bool shouldSkipNetworkFetch(AppPref appPref) {
    return _synced && hasCachedUserProfile(appPref);
  }

  void markSynced(List<AccountItemEntity> accounts) {
    _synced = true;
    _accounts = List<AccountItemEntity>.unmodifiable(accounts);
  }

  void invalidate() {
    _synced = false;
    _accounts = const [];
  }
}

bool hasCachedUserProfile(AppPref appPref) {
  final user = appPref.getUserLocalModel();
  if (user == null) return false;

  // Phone alone is not enough — OTP always stores msisdn before GET /users/{id}.
  return user.firstName.trim().isNotEmpty ||
      user.lastName.trim().isNotEmpty ||
      user.email.trim().isNotEmpty;
}
