import '../../domain/entities/account_item_entity.dart';

class AccountItemModel extends AccountItemEntity {
  const AccountItemModel({
    required super.id,
    required super.number,
    required super.isDefault,
  });

  factory AccountItemModel.fromJson(Map<String, dynamic> json) {
    return AccountItemModel(
      id: (json['id'] ?? '').toString(),
      number: (json['number'] ?? '').toString(),
      isDefault: json['isDefault'] == true,
    );
  }
}
