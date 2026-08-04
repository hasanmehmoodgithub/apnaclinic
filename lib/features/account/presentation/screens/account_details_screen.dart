import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../../domain/entities/account_item_entity.dart';
import '../../domain/models/account_method.dart';
import '../../domain/use_cases/delete_user_phone_use_case.dart';
import '../../domain/use_cases/get_accounts_list_use_case.dart';
import '../utils/account_phone_utils.dart';
import '../widgets/account_added_success_dialog_widget.dart';
import '../widgets/account_app_bar_widget.dart';
import '../widgets/account_details_loading_shimmer_widget.dart';
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
  bool _isLoading = true;
  String? _errorMessage;
  List<AccountItemEntity> _accounts = const [];
  bool _didShowInitialSuccessDialog = false;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  String _accountHolderName(AppLocalizations l10n) {
    final user = sl<AppPref>().getUserLocalModel();
    final firstName = user?.firstName.trim() ?? '';
    final lastName = user?.lastName.trim() ?? '';
    final fullName = '$firstName $lastName'.trim();
    return fullName.isEmpty ? l10n.accountHolderFallback : fullName;
  }

  void _popWithAccountAdded() {
    if (!mounted) return;
    context.pop(true);
  }

  List<AccountItemEntity> _withAddedPhoneVisible(
    List<AccountItemEntity> accounts,
  ) {
    final added = widget.addedPhone?.trim() ?? '';
    if (added.isEmpty) return accounts;

    final matchedIndex = accounts.indexWhere(
      (item) => accountPhonesMatch(item.number, added),
    );
    if (matchedIndex >= 0) {
      if (matchedIndex == 0) return accounts;
      final matched = accounts[matchedIndex];
      return [
        matched,
        ...accounts.sublist(0, matchedIndex),
        ...accounts.sublist(matchedIndex + 1),
      ];
    }

    return [
      AccountItemEntity(id: '', number: added, isDefault: false),
      ...accounts,
    ];
  }

  Future<void> _loadAccounts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await sl<GetAccountsListUseCase>().call();
    if (!mounted) return;

    await result.fold(
      (error) async {
        setState(() {
          _errorMessage = error;
          _isLoading = false;
          // Still surface the newly added number if list fetch failed.
          final added = widget.addedPhone?.trim() ?? '';
          if (added.isNotEmpty) {
            _accounts = [
              AccountItemEntity(id: '', number: added, isDefault: false),
            ];
            _errorMessage = null;
          }
        });
        await _showSuccessDialogIfNeeded();
      },
      (accounts) async {
        setState(() {
          _accounts = _withAddedPhoneVisible(accounts);
          _isLoading = false;
        });
        await _showSuccessDialogIfNeeded();
      },
    );
  }

  Future<void> _deleteAccount(AccountItemEntity item) async {
    if (item.id.trim().isEmpty) return;

    final result = await sl<DeleteUserPhoneUseCase>()(
      DeleteUserPhoneParams(phoneId: item.id),
    );
    if (!mounted) return;

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      },
      (_) => _loadAccounts(),
    );
  }

  Future<void> _showSuccessDialogIfNeeded() async {
    if (_didShowInitialSuccessDialog ||
        !mounted ||
        !widget.showSuccessDialog) {
      return;
    }

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
          onContinue: _popWithAccountAdded,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accountHolderName = _accountHolderName(l10n);

    return Scaffold(
      backgroundColor: AppColors.clrWhite,
      appBar: AccountAppBarWidget(
        title: l10n.accountDetailsTitle,
        onBack: _popWithAccountAdded,
      ),
      body: _isLoading
          ? const AccountDetailsLoadingShimmerWidget()
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : _accounts.isEmpty
                  ? Center(
                      child: Text(
                        l10n.accountNoAccountsMessage,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.clr7A91AE,
                            ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 24.h),
                      itemCount: _accounts.length,
                      separatorBuilder: (_, _) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final item = _accounts[index];
                        return AccountMethodCardWidget(
                          account: AccountMethod(
                            bankName: l10n.accountMethodJazzCash,
                            accountHolderName: accountHolderName,
                            accountNumber: item.number,
                            isDefault: item.isDefault,
                          ),
                          displayBankName: l10n.accountMethodJazzCash,
                          onDeleteTap: item.isDefault || item.id.trim().isEmpty
                              ? null
                              : () => _deleteAccount(item),
                        );
                      },
                    ),
    );
  }
}
