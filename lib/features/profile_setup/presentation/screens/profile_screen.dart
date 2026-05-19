import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../account/domain/entities/account_item_entity.dart';
import '../../../account/domain/use_cases/get_accounts_list_use_case.dart';
import '../../../account/data/account_local_store.dart';
import '../../../account/domain/models/account_method.dart';
import '../widgets/guest_profile_content.dart';
import '../widgets/logged_in_profile_content.dart';
import '../widgets/profile_avatar_section.dart';
import '../widgets/profile_header_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.showBackButton = true, this.onBack});

  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AppPref _appPref;
  late final AccountLocalStore _accountStore;
  bool _isAccountDetailsLoading = true;
  String? _accountDetailsError;
  List<AccountItemEntity> _accountDetails = const [];

  @override
  void initState() {
    super.initState();
    _appPref = sl<AppPref>();
    _accountStore = AccountLocalStore(_appPref);
    _loadAccountDetails();
  }

  Future<void> _loadAccountDetails() async {
    try {
      final items = await sl<GetAccountsListUseCase>().call();
      if (!mounted) return;
      setState(() {
        _accountDetails = items;
        _isAccountDetailsLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _accountDetailsError = e.toString();
        _isAccountDetailsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = _appPref.getLoginStatus();
    final userLocal = _appPref.getUserLocalModel();
    final firstName = userLocal?.firstName.trim() ?? '';
    final lastName = userLocal?.lastName.trim() ?? '';
    final fullName = '$firstName $lastName'.trim();
    final phone = userLocal?.phone.trim() ?? '';
    final accounts = _accountStore.getAccounts();
    final gender = userLocal?.gender.trim() ?? '';
    final email = userLocal?.email.trim() ?? '';
    final dobIso = userLocal?.dateOfBirth.trim() ?? '';
    final dob = DateTime.tryParse(dobIso);
    final dobLabel = dob == null
        ? ''
        : '${dob.day.toString().padLeft(2, '0')} '
              '${_monthShort(dob.month)} ${dob.year}';

    return Scaffold(
      backgroundColor: AppColors.clrC7EFEB,
      body: SafeArea(
        child: Column(
          children: [
            ProfileHeaderBar(
              showBackButton: widget.showBackButton,
              onBack: widget.onBack ?? () => context.pop(),
            ),
            SizedBox(height: 10.h),
            const ProfileAvatarSection(),
            SizedBox(height: 20.h),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.clrWhite,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(42.r),
                  ),
                ),
                child: isLoggedIn
                    ? LoggedInProfileContent(
                        fullName: fullName,
                        phone: phone,
                        gender: gender.isEmpty ? '--' : gender,
                        dob: dobLabel.isEmpty ? '--' : dobLabel,
                        email: email.isEmpty ? '--' : email,
                        accounts: accounts,
                        accountDetails: _accountDetails,
                        isAccountDetailsLoading: _isAccountDetailsLoading,
                        accountDetailsError: _accountDetailsError,
                        onDeleteAccountDetailTap: _onDeleteAccountDetailTap,
                        onAccountTap: () => context.push(
                          AppRoutes.path(AppRoutes.accountDetails),
                        ),
                        onEditTap: () async {
                          final updated = await context.push<bool>(
                            AppRoutes.path(AppRoutes.profileSetup),
                          );
                          if (mounted && updated == true) {
                            setState(() {});
                          }
                        },
                        onAddAccountTap: () async {
                          await context.push(
                            AppRoutes.path(AppRoutes.addAccount),
                          );
                          if (mounted) setState(() {});
                        },
                        onDeleteAccountTap: _onDeleteAccountTap,
                      )
                    : GuestProfileContent(
                        onLoginTap: () =>
                            context.push(AppRoutes.path(AppRoutes.authLogin)),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onDeleteAccountTap(int index, AccountMethod account) async {
    final shouldDelete = await _showRemoveAccountDialog(account);
    if (shouldDelete != true || !mounted) return;
    await _accountStore.deleteAccount(index);
    if (mounted) {
      setState(() {});
    }
  }

  void _onDeleteAccountDetailTap(int index, AccountItemEntity item) {
    if (item.isDefault) return;
    setState(() {
      _accountDetails = [..._accountDetails]..removeAt(index);
    });
  }

  Future<bool?> _showRemoveAccountDialog(AccountMethod account) {
    final theme = Theme.of(context);
    return showDialog<bool>(
      context: context,
      barrierColor: AppColors.clrBlack.withValues(alpha: 0.35),
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
          backgroundColor: AppColors.clrWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 22.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 58.r,
                  height: 58.r,
                  decoration: const BoxDecoration(
                    color: AppColors.clrC9252C,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.clrWhite,
                    size: 30.r,
                  ),
                ),
                SizedBox(height: 18.h),
                Text(
                  l10n.profileRemoveAccountTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.clr102A56,
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  l10n.profileRemoveAccountMessage(
                    account.bankName,
                    account.accountNumber,
                  ),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.clr6C7EA0,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 22.h),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56.h,
                        child: FilledButton(
                          onPressed: () => context.pop(true),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.clrC9252C,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            l10n.profileRemoveCta,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: AppColors.clrWhite,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: SizedBox(
                        height: 56.h,
                        child: OutlinedButton(
                          onPressed: () => context.pop(false),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.clrB7C0CC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            l10n.profileCancelCta,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: AppColors.clr4B5668,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

String _monthShort(int month) {
  const names = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return names[(month - 1).clamp(0, 11)];
}
