import '../../../../core/utils/phone_format_utils.dart';
import '../../../account/domain/entities/account_item_entity.dart';
import '../models/profile_setup_model.dart';

List<AccountItemEntity> mapProfilePhonesToAccountItems(
  List<ProfileUserPhoneModel> phones,
) {
  return phones
      .map(
        (phone) => AccountItemEntity(
          id: phone.id,
          number: PhoneFormatUtils.toLocalDisplay(phone.msisdn),
          isDefault: phone.primary,
        ),
      )
      .toList(growable: false);
}
