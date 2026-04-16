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

  Future<int> addAccount(AccountMethod method) async {
    final current = getAccounts();
    final updated = [
      ...current,
      method.copyWith(isDefault: current.isEmpty),
    ];
    await saveAccounts(updated);
    return updated.length - 1;
  }

  Future<void> deleteAccount(int index) async {
    final current = getAccounts();
    if (index < 0 || index >= current.length) return;
    final updated = [...current]..removeAt(index);
    if (updated.isNotEmpty && !updated.any((e) => e.isDefault)) {
      updated[0] = updated[0].copyWith(isDefault: true);
    }
    await saveAccounts(updated);
  }
}
