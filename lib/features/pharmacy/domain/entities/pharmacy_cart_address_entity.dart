class PharmacyCartAddressEntity {
  const PharmacyCartAddressEntity({
    required this.id,
    required this.address,
    this.region = '',
    this.cityId = '',
    this.isDefault = false,
  });

  final String id;
  final String address;
  final String region;
  final String cityId;
  final bool isDefault;
}
