import 'package:apnaclinic/components/shimmer/app_shimmer.dart';
import 'package:apnaclinic/components/widgets/app_button.dart';
import 'package:apnaclinic/components/widgets/apna_support_card.dart';
import 'package:apnaclinic/core/di/dependency_injection.dart';
import 'package:apnaclinic/core/enums/state_status.dart';
import 'package:apnaclinic/core/extensions/screen_util_extensions.dart';
import 'package:apnaclinic/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/customer_support_entity.dart';
import '../cubit/customer_support_cubit.dart';
import '../cubit/customer_support_state.dart';

/// Customer Support: cyan header + shield/phone hero, overlapping help body.
class CustomerSupportScreen extends StatelessWidget {
  const CustomerSupportScreen({
    super.key,
    this.showBackButton = true,
    this.onBack,
  });

  final bool showBackButton;
  final VoidCallback? onBack;

  static const String _heroAsset = 'assets/img/support/support_hero.png';

  static const Color _titleNavy = Color(0xFF0B2239);
  static const Color _headingDark = Color(0xFF111827);
  static const Color _subtitleGrey = Color(0xFF6B7280);

  static const double _topBannerFraction = 0.39;
  static const double _cardOverlap = 32;
  static const double _cardTopRadius = 32;

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
    final bannerHeight = MediaQuery.sizeOf(context).height * _topBannerFraction;

    return BlocProvider(
      create: (_) => sl<CustomerSupportCubit>(),
      child: BlocConsumer<CustomerSupportCubit, CustomerSupportState>(
        listener: (context, state) {
          if (state.loadingStateStatus == StateStatus.error &&
              state.errorMessage != null &&
              state.errorMessage!.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Column(
              children: [
                SizedBox(
                  height: bannerHeight,
                  child: _SupportTopHeader(
                    showBackButton: showBackButton,
                    onBack: onBack,
                  ),
                ),
                Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                        top: -_cardOverlap,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: _SupportBodyPanel(state: state),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SupportTopHeader extends StatelessWidget {
  const _SupportTopHeader({required this.showBackButton, required this.onBack});

  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFC8EEF2), Color(0xFFE2F5F7), Color(0xFFF0FAFB)],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(
              height: kToolbarHeight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: showBackButton
                        ? IconButton(
                            onPressed:
                                onBack ??
                                () => Navigator.of(context).maybePop(),
                            icon: const Icon(Icons.arrow_back_rounded),
                            color: CustomerSupportScreen._titleNavy,
                          )
                        : SizedBox(width: 48.w),
                  ),
                  Text(
                    'Customer Support',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: CustomerSupportScreen._titleNavy,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 1.h, 0, 30.h),
                child: Image.asset(
                  CustomerSupportScreen._heroAsset,
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportBodyPanel extends StatelessWidget {
  const _SupportBodyPanel({required this.state});

  final CustomerSupportState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const radius = BorderRadius.vertical(
      top: Radius.circular(CustomerSupportScreen._cardTopRadius),
    );

    final content = state.content;
    final helpTitle = content?.helpCentreTitle ?? 'Help Centre';
    final helpSubtitle = content?.helpCentreSubtitle ??
        'Reach out to Apna Clinic for any support.';
    final isLoading = state.loadingStateStatus == StateStatus.loading;
    final rawContacts =
        content?.contacts ?? const <CustomerSupportContactEntity>[];
    final contacts = !isLoading && rawContacts.isEmpty
        ? CustomerSupportScreen._fallbackContacts
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
            ? const _SupportPanelShimmer()
            : SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      helpTitle,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: CustomerSupportScreen._headingDark,
                      ),
                    ),
                    Text(
                      helpSubtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: CustomerSupportScreen._subtitleGrey,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    for (int i = 0; i < contacts.length; i++) ...[
                      ApnaSupportCard(
                        title: contacts[i].cardTitle,
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

class _SupportPanelShimmer extends StatelessWidget {
  const _SupportPanelShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppShimmerText(height: 18.h, borderRadius: 8.r, width: 120.w),
          SizedBox(height: 10.h),
          AppShimmerText(height: 14.h, borderRadius: 6.r),
          SizedBox(height: 6.h),
          AppShimmerText(height: 14.h, borderRadius: 6.r, width: 260.w),
          SizedBox(height: 24.h),
          for (int i = 0; i < 3; i++) ...[
            AppShimmerText(height: 96.h, borderRadius: 2.r),
            if (i != 2) SizedBox(height: 16.h),
          ],
        ],
      ),
    );
  }
}
