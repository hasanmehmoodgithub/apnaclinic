import 'package:apnaclinic/components/widgets/app_button.dart';
import 'package:apnaclinic/components/widgets/action_option_card.dart';
import 'package:apnaclinic/core/enums/state_status.dart';
import 'package:apnaclinic/core/extensions/screen_util_extensions.dart';
import 'package:apnaclinic/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/entities/customer_support_entity.dart';
import '../cubit/customer_support_cubit.dart';
import '../cubit/customer_support_state.dart';
import 'support_panel_shimmer.dart';

class SupportBodyPanel extends StatelessWidget {
  const SupportBodyPanel({super.key, required this.state});

  final CustomerSupportState state;

  static const Color _headingDark = Color(0xFF111827);
  static const Color _subtitleGrey = Color(0xFF6B7280);
  static const double _cardTopRadius = 32;
  static const List<Color> _curveOverlayColors = [
    Color(0xFFE9F9FC),
    Color(0xFFEFF3FF),
    Color(0xFFFFF1E8),
    Color(0xFFF4EDFF),
  ];
  static const List<CustomerSupportContactEntity> _fallbackContacts = [
    CustomerSupportContactEntity(
      cardTitle: 'Apna Clinic Support',
      dialogTitle: 'Customer Support',
      dialogMessage:
          'Or further support please contact us 24/7 on\n042-111-333-033.',
      dialNumber: '042111333033',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const radius = BorderRadius.vertical(
      top: Radius.circular(_cardTopRadius),
    );

    final content = state.content;
    final helpTitle = content?.helpCentreTitle ?? 'Help Centre';
    final helpSubtitle = content?.helpCentreSubtitle ??
        'Reach out to Apna Clinic for any support.';
    final isLoading = state.loadingStateStatus == StateStatus.loading;
    final rawContacts =
        content?.contacts ?? const <CustomerSupportContactEntity>[];
    final contacts = !isLoading && rawContacts.isEmpty
        ? _fallbackContacts
        : rawContacts;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 24.r,
            offset: Offset(0, -6.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: isLoading
            ? const SupportPanelShimmer()
            : SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      helpTitle,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: _headingDark,
                      ),
                    ),
                    Text(
                      helpSubtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _subtitleGrey,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    for (int i = 0; i < contacts.length; i++) ...[
                      ActionOptionCard(
                        title: contacts[i].cardTitle,
                        curveOverlayColor:
                            _curveOverlayColors[i % _curveOverlayColors.length],
                        leading: SizedBox(
                          width: 60.r,
                          height: 60.r,
                          child: SvgPicture.asset(
                            Assets.svgNavHomeLogo,
                            fit: BoxFit.contain,
                          ),
                        ),
                        onTap: () => _showSupportDialog(
                          context,
                          contacts[i],
                        ),
                      ),
                      if (i != contacts.length - 1) SizedBox(height: 16.h),
                    ],
                  ],
                ),
              ),
      ),
    );
  }

  void _showSupportDialog(
    BuildContext context,
    CustomerSupportContactEntity contact,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: const Color(0xFFD6DEE6)),
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
                    border: Border.all(
                      color: const Color(0xFFD6D9DE),
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      Assets.imgPartner,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  contact.dialogTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: const Color(0xFF0E2D55),
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  contact.dialogMessage,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF6C82A2),
                    height: 1.25,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 14.h),
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: AppButton.primary(
                    text: 'Call Now',
                    onPressed: () async {
                      if (!dialogContext.mounted) return;
                      if (contact.dialNumber.trim().isEmpty) {
                        Navigator.of(dialogContext).pop();
                        return;
                      }
                      final cubit = context.read<CustomerSupportCubit>();
                      final ok = await cubit.dialNumber(contact.dialNumber);
                      if (!dialogContext.mounted) return;
                      Navigator.of(dialogContext).pop();
                      if (!ok && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Could not start the call.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    backgroundColor: const Color(0xFF40AFA2),
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
