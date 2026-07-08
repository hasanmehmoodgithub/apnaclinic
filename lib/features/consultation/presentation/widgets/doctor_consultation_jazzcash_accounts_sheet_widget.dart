import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';
import '../../../account/domain/models/account_method.dart';

class DoctorConsultationJazzCashAccountsSheetWidget extends StatefulWidget {
  const DoctorConsultationJazzCashAccountsSheetWidget({
    super.key,
    required this.accounts,
    required this.initialSelectedIndex,
  });

  final List<AccountMethod> accounts;
  final int initialSelectedIndex;

  @override
  State<DoctorConsultationJazzCashAccountsSheetWidget> createState() =>
      _DoctorConsultationJazzCashAccountsSheetWidgetState();
}

class _DoctorConsultationJazzCashAccountsSheetWidgetState
    extends State<DoctorConsultationJazzCashAccountsSheetWidget> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = _clampSelectedIndex(widget.initialSelectedIndex);
  }

  @override
  void didUpdateWidget(
    covariant DoctorConsultationJazzCashAccountsSheetWidget oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSelectedIndex != widget.initialSelectedIndex ||
        oldWidget.accounts.length != widget.accounts.length) {
      _selectedIndex = _clampSelectedIndex(widget.initialSelectedIndex);
    }
  }

  int _clampSelectedIndex(int index) {
    if (widget.accounts.isEmpty) return 0;
    if (index < 0 || index >= widget.accounts.length) {
      final defaultIndex =
          widget.accounts.indexWhere((account) => account.isDefault);
      return defaultIndex >= 0 ? defaultIndex : 0;
    }
    return index;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      top: false,
      child: Container(
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
            ...List.generate(widget.accounts.length, (index) {
              final account = widget.accounts[index];
              return _SavedAccountTile(
                account: account,
                isSelected: _selectedIndex == index,
                onTap: () => setState(() => _selectedIndex = index),
              );
            }),
            const _AddAccountTile(),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: FilledButton(
                onPressed: widget.accounts.isEmpty
                    ? null
                    : () => Navigator.of(context).pop(_selectedIndex),
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
                  style: textTheme.bodySmall?.copyWith(color: const Color(0xFF7B8798)),
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
  const _AddAccountTile();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () => Navigator.of(context).pop(-1),
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
