import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/account_item_entity.dart';
import '../../domain/models/account_method.dart';
import '../../../profile_setup/domain/use_cases/get_profile_setup_content_use_case.dart';
import '../../domain/use_cases/delete_user_phone_use_case.dart';
import '../../domain/use_cases/get_accounts_list_use_case.dart';
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

  Future<void> _loadAccounts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await sl<GetProfileSetupContentUseCase>().call();
    final result = await sl<GetAccountsListUseCase>().call();
    if (!mounted) return;

    result.fold(
      (error) => setState(() {
        _errorMessage = error;
        _isLoading = false;
      }),
      (accounts) async {
        setState(() {
          _accounts = accounts;
          _isLoading = false;
        });
        if (!widget.showSuccessDialog ||
            _didShowInitialSuccessDialog ||
            widget.addedPhone == null) {
          return;
        }
        _didShowInitialSuccessDialog = true;
        await _showSuccessDialog(widget.addedPhone!.trim());
      },
    );
  }

  Future<void> _deleteAccount(AccountItemEntity item) async {
    final result = await sl<DeleteUserPhoneUseCase>()(
      DeleteUserPhoneParams(phone: item.id),
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

  Future<void> _showSuccessDialog(String accountNumber) async {
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AccountAddedSuccessDialogWidget(
          displayBankName: l10n.accountMethodJazzCash,
          accountNumber: accountNumber,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.clrWhite,
      appBar: AccountAppBarWidget(title: l10n.accountDetailsTitle),
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
                    accountHolderName: l10n.accountHolderFallback,
                    accountNumber: item.number,
                    isDefault: item.isDefault,
                  ),
                  displayBankName: l10n.accountMethodJazzCash,
                  onDeleteTap: item.isDefault
                      ? null
                      : () => _deleteAccount(item),
                );
              },
            ),
    );
  }
}
