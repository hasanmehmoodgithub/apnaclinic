import '../../domain/entities/account_item_entity.dart';

class AccountItemModel extends AccountItemEntity {
  const AccountItemModel({
    required super.id,
    required super.number,
    required super.isDefault,
    this.msisdn = '',
    this.jazzCashVerified = false,
  });

  final String msisdn;
  final bool jazzCashVerified;

  factory AccountItemModel.fromJson(Map<String, dynamic> json) {
    return AccountItemModel(
      id: (json['id'] ?? '').toString(),
      number: (json['number'] ?? '').toString(),
      isDefault: json['isDefault'] == true,
      msisdn: (json['msisdn'] ?? '').toString(),
      jazzCashVerified: json['jazzCashVerified'] == true,
    );
  }
}
