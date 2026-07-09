import '../../../../core/l10n/app_localizations.dart';
import '../../../account/domain/entities/account_item_entity.dart';
import '../../../account/domain/models/account_method.dart';

AccountMethod mapProfileAccountItem({
  required AppLocalizations l10n,
  required AccountItemEntity item,
  required String fullName,
}) {
  return AccountMethod(
    bankName: l10n.accountMethodJazzCash,
    accountHolderName:
        fullName.isEmpty ? l10n.accountHolderFallback : fullName,
    accountNumber: item.number,
    isDefault: item.isDefault,
  );
}
