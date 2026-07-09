import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../../domain/models/account_method.dart';
import '../widgets/account_added_success_dialog_widget.dart';
import '../widgets/account_app_bar_widget.dart';
import '../widgets/account_method_card_widget.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({
    super.key,
    this.showSuccessDialog = false,
    this.addedPhone,
  });

  final bool showSuccessDialog;
  final String? addedPhone;

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  bool _didShowInitialSuccessDialog = false;

  @override
  void initState() {
    super.initState();
    if (widget.showSuccessDialog && widget.addedPhone != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSuccessDialogIfNeeded();
      });
    }
  }

  String _accountHolderName(AppLocalizations l10n) {
    final user = sl<AppPref>().getUserLocalModel();
    final firstName = user?.firstName.trim() ?? '';
    final lastName = user?.lastName.trim() ?? '';
    final fullName = '$firstName $lastName'.trim();
    return fullName.isEmpty ? l10n.accountHolderFallback : fullName;
  }

  Future<void> _showSuccessDialogIfNeeded() async {
    if (_didShowInitialSuccessDialog || !mounted) return;

    final accountNumber = widget.addedPhone?.trim();
    if (accountNumber == null || accountNumber.isEmpty) return;

    _didShowInitialSuccessDialog = true;
    final l10n = AppLocalizations.of(context)!;

    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (context) {
        return AccountAddedSuccessDialogWidget(
          displayBankName: l10n.accountMethodJazzCash,
          accountNumber: accountNumber,
          accountHolderName: _accountHolderName(l10n),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accountHolderName = _accountHolderName(l10n);
    final accountNumber = widget.addedPhone?.trim() ?? '';

    return Scaffold(
      backgroundColor: AppColors.clrWhite,
      appBar: AccountAppBarWidget(title: l10n.accountDetailsTitle),
      body: accountNumber.isEmpty
          ? Center(
              child: Text(
                l10n.accountNoAccountsMessage,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.clr7A91AE,
                ),
              ),
            )
          : ListView(
              padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 24.h),
              children: [
                AccountMethodCardWidget(
                  account: AccountMethod(
                    bankName: l10n.accountMethodJazzCash,
                    accountHolderName: accountHolderName,
                    accountNumber: accountNumber,
                    isDefault: false,
                  ),
                  displayBankName: l10n.accountMethodJazzCash,
                  onDeleteTap: null,
                ),
              ],
            ),
    );
  }
}
