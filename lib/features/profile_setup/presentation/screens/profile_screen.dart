import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../profile_setup_launch_source.dart';
import '../../../profile_setup/domain/use_cases/get_profile_setup_content_use_case.dart';
import '../../../account/domain/entities/account_item_entity.dart';
import '../../../account/domain/models/account_method.dart';
import '../../../account/domain/use_cases/delete_user_phone_use_case.dart';
import '../../../account/domain/use_cases/get_accounts_list_use_case.dart';
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
  bool _isAccountDetailsLoading = true;
  String? _accountDetailsError;
  List<AccountItemEntity> _accountDetails = const [];

  @override
  void initState() {
    super.initState();
    _appPref = sl<AppPref>();
    _loadAccountDetails();
    _refreshProfileFromApi();
  }

  Future<void> _refreshProfileFromApi() async {
    if (!_appPref.getLoginStatus()) return;
    await sl<GetProfileSetupContentUseCase>().call();
    if (mounted) setState(() {});
  }

  Future<void> _refreshAccountDataFromProfile() async {
    await _refreshProfileFromApi();
    await _loadAccountDetails();
  }

  Future<void> _loadAccountDetails() async {
    setState(() {
      _isAccountDetailsLoading = true;
      _accountDetailsError = null;
    });

    final result = await sl<GetAccountsListUseCase>().call();
    if (!mounted) return;

    result.fold(
      (error) => setState(() {
        _accountDetailsError = error;
        _isAccountDetailsLoading = false;
      }),
      (items) => setState(() {
        _accountDetails = items;
        _isAccountDetailsLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = _appPref.getLoginStatus();
    final userLocal = _appPref.getUserLocalModel();
    final firstName = userLocal?.firstName.trim() ?? '';
    final lastName = userLocal?.lastName.trim() ?? '';
    final fullName = '$firstName $lastName'.trim();
    final phone = userLocal?.phone.trim() ?? '';
    final gender = userLocal?.gender.trim() ?? '';
    final email = userLocal?.email.trim() ?? '';
    final dobIso = userLocal?.dateOfBirth.trim() ?? '';
    final dob = DateTime.tryParse(dobIso);
    final dobLabel = dob == null
        ? ''
        : '${dob.day.toString().padLeft(2, '0')} '
              '${_monthShort(dob.month)} ${dob.year}';
    final imageUrl = userLocal?.imageUrl.trim();

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
            ProfileAvatarSection(
              imageUrl: imageUrl?.isEmpty ?? true ? null : imageUrl,
            ),
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
                        accountDetails: _accountDetails,
                        isAccountDetailsLoading: _isAccountDetailsLoading,
                        accountDetailsError: _accountDetailsError,
                        onDeleteAccountDetailTap: _onDeleteAccountDetailTap,
                        onAccountTap: () async {
                          await context.push(
                            AppRoutes.path(AppRoutes.accountDetails),
                          );
                          if (mounted) await _refreshAccountDataFromProfile();
                        },
                        onEditTap: () async {
                          final updated = await context.push<bool>(
                            AppRoutes.path(AppRoutes.profileSetup),
                            extra: ProfileSetupLaunchSource.menu,
                          );
                          if (mounted && updated == true) {
                            await _refreshProfileFromApi();
                          }
                        },
                        onAddAccountTap: () async {
                          await context.push(
                            AppRoutes.path(AppRoutes.addAccount),
                          );
                          if (mounted) {
                            await _refreshAccountDataFromProfile();
                          }
                        },
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

  Future<void> _onDeleteAccountDetailTap(
    int index,
    AccountItemEntity item,
  ) async {
    if (item.isDefault) return;

    final account = AccountMethod(
      bankName: AppLocalizations.of(context)!.accountMethodJazzCash,
      accountHolderName: AppLocalizations.of(context)!.accountHolderFallback,
      accountNumber: item.number,
      isDefault: item.isDefault,
    );
    final shouldDelete = await _showRemoveAccountDialog(account);
    if (shouldDelete != true || !mounted) return;

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
      (_) => _refreshAccountDataFromProfile(),
    );
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
