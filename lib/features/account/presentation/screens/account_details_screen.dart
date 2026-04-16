import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (context) {
        final theme = Theme.of(context);
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(22.w, 24.h, 22.w, 18.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56.r,
                  height: 56.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE7F8EE),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: const Color(0xFF6DD67C),
                    size: 34.r,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Payment Method Added Successfully',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF25324B),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Your ${account.bankName} account no. ${account.accountNumber} - ${account.accountHolderName} has success been linked',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF7B8794),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 18.h),
                AppButton.primary(
                  text: 'Continue',
                  onPressed: () => Navigator.of(context).pop(),
                  backgroundColor: const Color(0xFF45B7AC),
                  foregroundColor: Colors.white,
                  height: 48.h,
                  borderRadius: 10.r,
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
          return Container(
            padding: EdgeInsets.fromLTRB(12.w, 10.h, 10.w, 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 14.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF5D8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: const Color(0xFFCA8A04),
                    size: 22.r,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.bankName,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: const Color(0xFF111827),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        item.accountHolderName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF374151),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        item.accountNumber,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.isDefault) ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: const Color(0xFFD1D5DB),
                          ),
                        ),
                        child: Text(
                          'Default',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: const Color(0xFF6B7280),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                    ],
                    InkWell(
                      onTap: () => _deleteAccount(index),
                      borderRadius: BorderRadius.circular(14.r),
                      child: Container(
                        width: 32.r,
                        height: 32.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFD1D5DB),
                          ),
                        ),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: const Color(0xFF6B7280),
                          size: 18.r,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
