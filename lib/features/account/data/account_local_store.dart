import '../../../core/preference/app_pref.dart';
import '../domain/models/account_method.dart';

class AccountLocalStore {
  AccountLocalStore(this._appPref);

  static const String _accountsKey = 'profile_account_methods';

  final AppPref _appPref;

  List<AccountMethod> getAccounts() {
    return AccountMethod.decodeList(_appPref.getString(_accountsKey));
  }

  Future<void> saveAccounts(List<AccountMethod> accounts) async {
    await _appPref.setString(
      _accountsKey,
      AccountMethod.encodeList(accounts),
      defaultValue: '[]',
    );
  }

  Future<void> addAccount(AccountMethod method) async {
    final current = getAccounts();
    final updated = [
      ...current.map((e) => e.copyWith(isDefault: false)),
      method.copyWith(isDefault: current.isEmpty),
    ];
    await saveAccounts(updated);
  }

  Future<void> setDefaultAccount(int index) async {
    final current = getAccounts();
    if (index < 0 || index >= current.length) return;
    final updated = [
      for (var i = 0; i < current.length; i++)
        current[i].copyWith(isDefault: i == index),
    ];
    await saveAccounts(updated);
  }
}
