import '../../domain/entities/account_item_entity.dart';

String normalizeAccountPhone(String phone) {
  final digits = phone.replaceAll(RegExp(r'\D'), '');
  if (digits.length >= 11) {
    return digits.substring(digits.length - 11);
  }
  return digits;
}

bool accountPhonesMatch(String left, String right) {
  final normalizedLeft = normalizeAccountPhone(left);
  final normalizedRight = normalizeAccountPhone(right);
  return normalizedLeft.isNotEmpty &&
      normalizedRight.isNotEmpty &&
      normalizedLeft == normalizedRight;
}

List<AccountItemEntity> filterAccountsForAddedPhone({
  required List<AccountItemEntity> accounts,
  required String addedPhone,
}) {
  final trimmed = addedPhone.trim();
  if (trimmed.isEmpty) return accounts;

  final matched = accounts
      .where((item) => accountPhonesMatch(item.number, trimmed))
      .toList();
  if (matched.isNotEmpty) return matched;

  return [
    AccountItemEntity(
      id: '',
      number: trimmed,
      isDefault: false,
    ),
  ];
}
