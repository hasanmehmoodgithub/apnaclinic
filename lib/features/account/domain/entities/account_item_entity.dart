class AccountItemEntity {
  const AccountItemEntity({
    required this.id,
    required this.number,
    required this.isDefault,
  });

  final String id;
  final String number;
  final bool isDefault;
}
