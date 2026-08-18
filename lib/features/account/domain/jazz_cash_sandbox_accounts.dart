import '../../../core/flavor/flavor_config.dart';
import '../../../core/utils/phone_format_utils.dart';
import 'entities/account_item_entity.dart';

/// Appends the dart-define number when `--dart-define=JAZZCASH_SANDBOX=true`
/// and `--dart-define=ACCOUNT_TEST_PHONE=...` (or `JAZZCASH_SANDBOX_PHONE`).
List<AccountItemEntity> withJazzCashSandboxAccount(
  List<AccountItemEntity> accounts,
) {
  final phone = FlavorConfig.jazzCashSandboxPhone;
  if (phone.isEmpty) return accounts;

  final local = PhoneFormatUtils.toLocalDisplay(phone);
  if (local.isEmpty) return accounts;

  final needle = _lastElevenDigits(local);
  if (needle.isEmpty) return accounts;
  if (accounts.any((item) => _lastElevenDigits(item.number) == needle)) {
    return accounts;
  }

  return [
    ...accounts,
    AccountItemEntity(id: '', number: local, isDefault: false),
  ];
}

String _lastElevenDigits(String phone) {
  final digits = phone.replaceAll(RegExp(r'\D'), '');
  if (digits.length >= 11) return digits.substring(digits.length - 11);
  return digits;
}
