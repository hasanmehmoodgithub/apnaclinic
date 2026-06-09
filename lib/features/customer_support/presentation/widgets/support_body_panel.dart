import 'package:apnaclinic/components/widgets/app_button.dart';
import 'package:apnaclinic/components/widgets/action_option_card.dart';
import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:apnaclinic/core/enums/state_status.dart';
import 'package:apnaclinic/core/extensions/screen_util_extensions.dart';
import 'package:apnaclinic/core/l10n/app_localizations.dart';
import 'package:apnaclinic/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/customer_support_entity.dart';
import '../cubit/customer_support_cubit.dart';
import '../cubit/customer_support_state.dart';
import 'support_panel_shimmer.dart';

class SupportBodyPanel extends StatelessWidget {
  const SupportBodyPanel({super.key, required this.state});

  final CustomerSupportState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    const radius = BorderRadius.vertical(top: Radius.circular(32));

    final content = state.content;
    final helpTitle = _textOrFallback(
      content?.helpCentreTitle,
      l10n.customerSupportHelpCentreTitle,
    );
    final helpSubtitle = _textOrFallback(
      content?.helpCentreSubtitle,
      l10n.customerSupportHelpCentreSubtitle,
    );
    final isLoading = state.loadingStateStatus == StateStatus.loading;
    final rawContacts =
        content?.contacts ?? const <CustomerSupportContactEntity>[];
    final contacts = !isLoading && rawContacts.isEmpty
        ? [
            CustomerSupportContactEntity(
              cardTitle: l10n.customerSupportFallbackCardTitle,
              dialogTitle: l10n.customerSupportFallbackDialogTitle,
              dialogMessage: l10n.customerSupportFallbackDialogMessage,
              dialNumber: '042111333033',
            ),
          ]
        : rawContacts;

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.clrWhite,
        borderRadius: radius,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                helpTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.clr111827,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                helpSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.clr6B7280,
                  fontSize: 13.sp,
                  height: 1.35,
                ),
              ),
              SizedBox(height: 20.h),
              if (isLoading)
                const SupportPanelShimmer(showHeader: false)
              else
                for (int i = 0; i < contacts.length; i++) ...[
                  ActionOptionCard(
                    title: contacts[i].cardTitle.isNotEmpty
                        ? contacts[i].cardTitle
                        : l10n.customerSupportFallbackCardTitle,
                    curveOverlayColor: [
                      AppColors.clrE9F4FC,
                      AppColors.clrE9EEF3,
                      AppColors.clrFCF5E9,
                      AppColors.clrF5FBFA,
                    ][i % 4],
                    height: 74.h,
                    radius: 4.r,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                    titleStyle: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.clr111827,
                      fontSize: 14.sp,
                    ),
                    leading: Container(
                      width: 55.r,
                      height: 55.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.clrWhite,
                      ),
                      child: SvgPicture.asset(
                        Assets.svgNavHomeLogo,
                        fit: BoxFit.contain,
                      ),
                    ),
                    trailing: SvgPicture.asset(
                      Assets.svgIcSupportCardArrow,
                      fit: BoxFit.contain,
                    ),
                    onTap: () => _showSupportDialog(context, contacts[i]),
                  ),
                  if (i != contacts.length - 1) SizedBox(height: 16.h),
                ],
            ],
          ),
        ),
      ),
    );
  }

  String _textOrFallback(String? value, String fallback) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isNotEmpty ? trimmed : fallback;
  }

  void _showSupportDialog(
    BuildContext context,
    CustomerSupportContactEntity contact,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final l10n = AppLocalizations.of(dialogContext)!;
        final theme = Theme.of(dialogContext);
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.clrWhite,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: AppColors.clrD6DCE2),
            ),
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60.r,
                  height: 60.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.clrD6DCE2),
                  ),
                  child: ClipOval(
                    child: Image.asset(Assets.imgPartner, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  contact.dialogTitle.isNotEmpty
                      ? contact.dialogTitle
                      : l10n.customerSupportFallbackDialogTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: AppColors.clr0E2D55,
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                  ),
                ),
                if (contact.hasPhone || contact.hasEmail) ...[
                  SizedBox(height: 12.h),
                  if (contact.hasEmail) ...[
                    if (contact.hasPhone)
                      Text(
                        contact.dialNumber,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.clr0E2D55,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                        ),
                      ),
                    if (contact.hasPhone && contact.hasEmail)
                      SizedBox(height: 2.h),
                    Text(
                      contact.email,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.clr0E2D55,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                    ),
                  ] else if (contact.hasPhone)
                    Text(
                      contact.dialNumber,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.clr0E2D55,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                      ),
                    ),
                ],
                if (contact.dialogMessage.trim().isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Text(
                    contact.dialogMessage,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.clr6C82A2,
                      height: 1.25,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
                SizedBox(height: 14.h),
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: AppButton.primary(
                    text: contact.buttonText.trim().isNotEmpty
                        ? contact.buttonText
                        : l10n.customerSupportCallNowCta,
                    onPressed: () async {
                      if (!dialogContext.mounted) return;
                      if (contact.dialNumber.trim().isEmpty) {
                        dialogContext.pop();
                        return;
                      }
                      final cubit = context.read<CustomerSupportCubit>();
                      final ok = await cubit.dialNumber(contact.dialNumber);
                      if (!dialogContext.mounted) return;
                      dialogContext.pop();
                      if (!ok && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.customerSupportDialError),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    backgroundColor: AppColors.clr40AFA2,
                    borderRadius: 12.r,
                    fontWeight: FontWeight.w700,
                    fontSize: (22 / 1.6).sp,
                    width: 318.w,
                    height: 66.h,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
