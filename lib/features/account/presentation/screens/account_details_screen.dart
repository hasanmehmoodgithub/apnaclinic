import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../components/widgets/action_option_card.dart';
import '../../../../components/widgets/app_button.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/preference/app_pref.dart';
import '../../data/account_local_store.dart';
import '../../domain/models/account_method.dart';

class AccountDetailsScreen extends StatefulWidget {
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
  static const String _jazzCashName = 'JazzCash';
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
        final theme = Theme.of(context);
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 14.w),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(26.w, 22.h, 26.w, 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 60.r,
                  height: 60.r,
                  child: SvgPicture.asset(
                    'assets/icons/tick.svg',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 18.h),
                Text(
                  'Payment Method Added Successfully',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF102A56),
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp,
                    height: 1.15,
                  ),
                ),
                SizedBox(height: 10.h),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF8A97B2),
                      fontSize: 14.sp,
                      height: 1.35,
                    ),
                    children: [
                      TextSpan(
                        text:
                            'Your ${_displayBankName(account.bankName)} account no. ',
                      ),
                      TextSpan(
                        text: account.accountNumber,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF6B7C96),
                          fontSize: 14.sp,
                          height: 1.35,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const TextSpan(text: ' has success been linked'),
                    ],
                  ),
                ),
                SizedBox(height: 22.h),
                SizedBox(
                  width: double.infinity,
                  child: AppButton.primary(
                    text: 'Continue',
                    onPressed: () => Navigator.of(context).pop(),
                    backgroundColor: const Color(0xFF40B3A7),
                    foregroundColor: Colors.white,
                    height: 60.h,
                    borderRadius: 12.r,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFC7EFEB),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF061E40)),
        ),
        title: Text(
          'Account Details',
          style: theme.textTheme.titleMedium?.copyWith(
            color: const Color(0xFF061E40),
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 24.h),
        itemCount: _accounts.length,
        separatorBuilder: (_, _) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final item = _accounts[index];
          return ActionOptionCard(
            title: _displayBankName(item.bankName),
            subtitle: item.accountHolderName,
            onTap: () {},
            onTrailingTap: item.isDefault ? null : () => _deleteAccount(index),
            height: 96.h,
            radius: 6.r,
            curveOverlayColor: const Color(0xFFE8F8FD),
            contentPadding: EdgeInsets.fromLTRB(12.w, 10.h, 10.w, 10.h),
            titleSpacing: 2,
            trailingOverlayWidth: item.isDefault ? 78.w : 40.w,
            trailingOverlayHeight: item.isDefault ? 34.h : 40.h,
            leading: Container(
              width:60.r,
              height: 60.r,
              padding: EdgeInsets.all(2.r),
              child: SvgPicture.asset(
                'assets/svg/jazzCash.svg',
                fit: BoxFit.contain,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _displayBankName(item.bankName),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF111827),
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  item.accountHolderName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF25324B),
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  item.accountNumber,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF8A97A8),
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    height: 1.1,
                  ),
                ),
              ],
            ),

          );
        },
      ),
    );
  }

  String _displayBankName(String bankName) {
    if (bankName.trim().isEmpty) return _jazzCashName;
    final normalized = bankName.replaceAll(' ', '').toLowerCase();
    if (normalized == 'jazzcash') return _jazzCashName;
    return bankName;
  }
}
