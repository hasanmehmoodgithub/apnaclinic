/// Persisted pharmacy delivery city (location preference, not account data).
class PharmacyCityLocalModel {
  const PharmacyCityLocalModel({
    required this.id,
    required this.name,
    this.partner = '',
  });

  final int id;
  final String name;
  final String partner;

  factory PharmacyCityLocalModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final id = rawId is int
        ? rawId
        : int.tryParse(rawId?.toString() ?? '') ?? 0;
    return PharmacyCityLocalModel(
      id: id,
      name: (json['name'] ?? '').toString().trim(),
      partner: (json['partner'] ?? '').toString().trim(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'partner': partner,
      };

  bool get isValid => id > 0 && name.isNotEmpty;
}
