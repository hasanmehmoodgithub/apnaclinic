class PaymentProviderEntity {
  const PaymentProviderEntity({
    required this.name,
    required this.code,
    required this.iconUrl,
  });

  final String name;
  final String code;
  final String iconUrl;
}
