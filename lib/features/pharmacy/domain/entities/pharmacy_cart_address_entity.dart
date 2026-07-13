class PharmacyCartAddressEntity {
  const PharmacyCartAddressEntity({
    required this.id,
    required this.address,
    this.region = '',
  });

  final String id;
  final String address;
  final String region;
}
