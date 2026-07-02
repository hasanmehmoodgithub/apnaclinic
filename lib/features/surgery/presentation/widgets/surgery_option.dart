class SurgeryOption {
  const SurgeryOption({
    required this.id,
    required this.name,
    required this.price,
    required this.oldPrice,
    this.hospitalName = '',
  });

  final String id;
  final String name;
  final String price;
  final String oldPrice;
  final String hospitalName;
}
