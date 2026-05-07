import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../../data/account_local_store.dart';
import '../../domain/models/account_method.dart';
import '../widgets/account_added_success_dialog_widget.dart';
import '../widgets/account_app_bar_widget.dart';
import '../widgets/account_method_card_widget.dart';

class AccountDetailsScreen extends StatefulWidget {
  //
  const AccountDetailsScreen({
    super.key,
    this.initialAccountIndex,
    this.showSuccessDialog = false,
  });

  final int? initialAccountIndex;
  final bool showSuccessDialog;

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  late List<AccountMethod> _accounts;
  bool _didShowInitialSuccessDialog = false;

  @override
  void initState() {
    super.initState();
    _reloadAccounts();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted ||
          !widget.showSuccessDialog ||
          _didShowInitialSuccessDialog ||
          _accounts.isEmpty) {
        return;
      }
      _didShowInitialSuccessDialog = true;
      await _showSuccessDialog(_accounts.first);
    });
  }

  void _reloadAccounts() {
    final allAccounts = AccountLocalStore(sl<AppPref>()).getAccounts();
    final index = widget.initialAccountIndex;
    if (index != null && index >= 0 && index < allAccounts.length) {
      _accounts = [allAccounts[index]];
      return;
    }
    _accounts = allAccounts;
  }

  Future<void> _deleteAccount(int index) async {
    final store = AccountLocalStore(sl<AppPref>());
    final sourceIndex = widget.initialAccountIndex ?? index;
    await store.deleteAccount(sourceIndex);
    if (!mounted) return;
    if (widget.initialAccountIndex != null) {
      context.pop();
      return;
    }
    setState(_reloadAccounts);
  }

  Future<void> _showSuccessDialog(AccountMethod account) async {
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AccountAddedSuccessDialogWidget(
          displayBankName: _displayBankName(account.bankName, l10n),
          accountNumber: account.accountNumber,
        );
      },
    );
  }

  String _displayBankName(String bankName, AppLocalizations l10n) {
    if (bankName.trim().isEmpty) return l10n.accountMethodJazzCash;
    final normalized = bankName.replaceAll(' ', '').toLowerCase();
    if (normalized == 'jazzcash') return l10n.accountMethodJazzCash;
    return bankName;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.clrWhite,
      appBar: AccountAppBarWidget(title: l10n.accountDetailsTitle),
      body: ListView.separated(
        padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 24.h),
        itemCount: _accounts.length,
        separatorBuilder: (_, _) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final item = _accounts[index];
          return AccountMethodCardWidget(
            account: item,
            displayBankName: _displayBankName(item.bankName, l10n),
            onDeleteTap: () => _deleteAccount(index),
          );
        },
      ),
    );
  }
}
