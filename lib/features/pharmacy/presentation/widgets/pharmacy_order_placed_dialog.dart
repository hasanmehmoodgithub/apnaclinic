import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';

class PharmacyOrderPlacedDialog extends StatelessWidget {
  const PharmacyOrderPlacedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 60.r,
              height: 60.r,
              child: SvgPicture.asset('assets/icons/tick.svg'),
            ),
            SizedBox(height: 12.h),
            Text(
              l10n.pharmacyOrderPlacedTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                color: const Color(0xFF102A56),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              l10n.pharmacyOrderPlacedMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF6B7C96),
              ),
            ),
            SizedBox(height: 14.h),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => context.pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF27B3A6),
                  minimumSize: Size.fromHeight(52.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(l10n.pharmacyOrderPlacedClose),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showPharmacyOrderPlacedDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.38),
    builder: (_) => const PharmacyOrderPlacedDialog(),
  );
}
