import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../generated/assets.dart';
import '../../../account/data/models/account_item_model.dart';
import '../../../account/domain/models/account_method.dart';
import '../../../account/domain/use_cases/get_accounts_list_use_case.dart';
import '../../../account/presentation/add_account_launch_source.dart';
import '../../../account/presentation/utils/account_phone_utils.dart';
import '../models/doctor_consultation_jazzcash_sheet_result.dart';

class DoctorConsultationJazzCashAccountsSheetWidget extends StatefulWidget {
  const DoctorConsultationJazzCashAccountsSheetWidget({super.key});

  @override
  State<DoctorConsultationJazzCashAccountsSheetWidget> createState() =>
      _DoctorConsultationJazzCashAccountsSheetWidgetState();
}

class _DoctorConsultationJazzCashAccountsSheetWidgetState
    extends State<DoctorConsultationJazzCashAccountsSheetWidget> {
  bool _isLoading = true;
  String? _errorMessage;
  List<AccountMethod> _accounts = const [];
  List<String> _accountMsisdns = const [];
  int _selectedIndex = 0;
  bool _didRequestLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didRequestLoad) return;
    _didRequestLoad = true;
    _loadAccounts();
  }

  Future<void> _loadAccounts({String? selectPhone}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final l10n = AppLocalizations.of(context)!;
    final result = await sl<GetAccountsListUseCase>().call();
    if (!mounted) return;

    result.fold(
      (error) => setState(() {
        _isLoading = false;
        _errorMessage = error;
        _accounts = const [];
        _accountMsisdns = const [];
        _selectedIndex = 0;
      }),
      (items) {
        final accounts = <AccountMethod>[];
        final msisdns = <String>[];

        for (final item in items) {
          final msisdn = _resolveMsisdn(item);
          if (msisdn.isEmpty) continue;

          accounts.add(
            AccountMethod(
              bankName: l10n.accountMethodJazzCash,
              accountHolderName: l10n.accountHolderFallback,
              accountNumber: item.number.isNotEmpty ? item.number : msisdn,
              isDefault: item.isDefault,
            ),
          );
          msisdns.add(msisdn);
        }

        var selectedIndex = -1;
        final trimmedSelectPhone = selectPhone?.trim();
        if (trimmedSelectPhone != null && trimmedSelectPhone.isNotEmpty) {
          selectedIndex = msisdns.indexWhere(
            (msisdn) => accountPhonesMatch(msisdn, trimmedSelectPhone),
          );
        }
        if (selectedIndex < 0) {
          selectedIndex = accounts.indexWhere((item) => item.isDefault);
        }
        if (selectedIndex < 0 && accounts.isNotEmpty) selectedIndex = 0;

        setState(() {
          _isLoading = false;
          _accounts = accounts;
          _accountMsisdns = msisdns;
          _selectedIndex = selectedIndex;
        });
      },
    );
  }

  Future<void> _openAddAccount() async {
    final addedPhone = await context.push<String>(
      AppRoutes.path(AppRoutes.addAccount),
      extra: AddAccountLaunchSource.consultationCheckout,
    );
    if (!mounted) return;
    final trimmedPhone = addedPhone?.trim();
    if (trimmedPhone == null || trimmedPhone.isEmpty) return;
    await _loadAccounts(selectPhone: trimmedPhone);
  }

  String _resolveMsisdn(dynamic item) {
    if (item is AccountItemModel && item.msisdn.trim().isNotEmpty) {
      return item.msisdn.trim();
    }
    return item.number.toString().trim();
  }

  void _onProceed() {
    if (_accounts.isEmpty ||
        _selectedIndex < 0 ||
        _selectedIndex >= _accounts.length) {
      return;
    }

    Navigator.of(context).pop(
      DoctorConsultationJazzCashSheetResult.account(
        msisdn: _accountMsisdns[_selectedIndex],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD3D9),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 14.h),
            _JazzCashTopTile(textTheme: textTheme),
            SizedBox(height: 14.h),
            Text(
              l10n.consultationSelectAccountTitle,
              style: textTheme.titleMedium?.copyWith(
                color: const Color(0xFF061E40),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10.h),
            Flexible(child: _buildBody(l10n)),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: FilledButton(
                onPressed: _accounts.isEmpty || _isLoading ? null : _onProceed,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1FAFA3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(l10n.consultationProceedCta),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 28.h),
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (_errorMessage != null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 12.h),
            TextButton(
              onPressed: _loadAccounts,
              child: Text(l10n.commonRetry),
            ),
          ],
        ),
      );
    }

    return ListView(
      shrinkWrap: true,
      children: [
        ...List.generate(_accounts.length, (index) {
          final account = _accounts[index];
          return _SavedAccountTile(
            account: account,
            isSelected: _selectedIndex == index,
            onTap: () => setState(() => _selectedIndex = index),
          );
        }),
        _AddAccountTile(onTap: _openAddAccount),
      ],
    );
  }
}

class _JazzCashTopTile extends StatelessWidget {
  const _JazzCashTopTile({required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE7EBF0)),
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.h,
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(8.r),
            child: SvgPicture.asset(Assets.iconsJazzCash),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.accountMethodJazzCash,
                  style: textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF061E40),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  l10n.consultationJazzCashChargeDescription,
                  style: textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF7B8798),
                  ),
                ),
              ],
            ),
          ),
          const _SelectionCircle(isSelected: true),
        ],
      ),
    );
  }
}

class _SavedAccountTile extends StatelessWidget {
  const _SavedAccountTile({
    required this.account,
    required this.isSelected,
    required this.onTap,
  });

  final AccountMethod account;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.bankName.trim().isEmpty
                        ? AppLocalizations.of(context)!.accountMethodJazzCash
                        : account.bankName,
                    style: textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF6A7688),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    account.accountNumber,
                    style: textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF26374A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            _SelectionCircle(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

class _AddAccountTile extends StatelessWidget {
  const _AddAccountTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                l10n.accountAddTitle,
                style: textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF6A7688),
                ),
              ),
            ),
            Container(
              width: 34.w,
              height: 34.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD9E0E8)),
              ),
              child: Icon(Icons.add, size: 20.r, color: const Color(0xFF26374A)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionCircle extends StatelessWidget {
  const _SelectionCircle({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22.w,
      height: 22.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFB8C0CC),
          width: 1.2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 10.w,
                height: 10.h,
                decoration: const BoxDecoration(
                  color: Color(0xFF0E3D66),
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}
