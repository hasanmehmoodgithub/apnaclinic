import '../../../../core/utils/phone_format_utils.dart';
import '../../domain/entities/account_item_entity.dart';
import 'account_item_model.dart';

class UserPhoneModel {
  const UserPhoneModel({
    required this.msisdn,
    required this.jazzCashVerified,
    required this.primary,
  });

  final String msisdn;
  final bool jazzCashVerified;
  final bool primary;

  factory UserPhoneModel.fromJson(Map<String, dynamic> json) {
    return UserPhoneModel(
      msisdn: (json['msisdn'] ?? '').toString(),
      jazzCashVerified: json['jazzCashVerified'] == true,
      primary: json['primary'] == true,
    );
  }

  AccountItemModel toAccountItem() {
    return AccountItemModel(
      id: msisdn,
      number: PhoneFormatUtils.toLocalDisplay(msisdn),
      isDefault: primary,
      msisdn: msisdn,
      jazzCashVerified: jazzCashVerified,
    );
  }
}

List<UserPhoneModel> parseUserPhones(dynamic raw) {
  if (raw is! List) return const [];
  return raw
      .whereType<Map>()
      .map((item) => UserPhoneModel.fromJson(Map<String, dynamic>.from(item)))
      .where((phone) => phone.msisdn.isNotEmpty)
      .toList(growable: false);
}

List<AccountItemEntity> phonesToAccountItems(List<UserPhoneModel> phones) {
  return phones.map((phone) => phone.toAccountItem()).toList(growable: false);
}
