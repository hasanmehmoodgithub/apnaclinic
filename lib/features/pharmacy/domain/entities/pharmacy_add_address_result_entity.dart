class PharmacyAddAddressResultEntity {
  const PharmacyAddAddressResultEntity({
    this.id,
    this.address = '',
    this.region = '',
  });

  final String? id;
  final String address;
  final String region;
}
