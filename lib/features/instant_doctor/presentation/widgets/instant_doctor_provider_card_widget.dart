import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../components/widgets/app_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/instant_doctor_provider_entity.dart';
import '../cubit/instant_doctor_cubit.dart';
import '../cubit/instant_doctor_state.dart';
import 'instant_doctor_provider_options_menu_widget.dart';

class InstantDoctorProviderCardWidget extends StatelessWidget {
  const InstantDoctorProviderCardWidget({
    super.key,
    required this.provider,
    required this.onPrimaryAction,
    required this.onCancelSubscription,
  });

  final InstantDoctorProviderEntity provider;
  final VoidCallback onPrimaryAction;
  final VoidCallback onCancelSubscription;

  static const double _cardRadius = 14;
  static const double _actionHeight = 50;
  static const double _actionRadius = 14;
  static const double _logoSize = 48;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocSelector<InstantDoctorCubit, InstantDoctorState, bool>(
      selector: (state) => state.isProviderBusy(provider.providerId),
      builder: (context, isLoading) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: AppColors.clrWhite,
            borderRadius: BorderRadius.circular(_cardRadius.r),
            border: Border.all(color: AppColors.clrE4E7EB, width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProviderLogo(logoUrl: provider.logoUrl),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProviderHeader(
                      provider: provider,
                      subscribedLabel: l10n.instantDoctorSubscribed,
                    ),
                    if (provider.product.benefits.isNotEmpty) ...[
                      SizedBox(height: 14.h),
                      _BenefitsSection(benefits: provider.product.benefits),
                    ],
                    SizedBox(height: 16.h),
                    if (provider.isSubscribed)
                      _SubscribedActions(
                        startConsultationLabel:
                            l10n.instantDoctorStartConsultation,
                        isLoading: isLoading,
                        onPrimaryAction: onPrimaryAction,
                        onCancelSubscription: onCancelSubscription,
                        showCancelMenu: !provider.product.isFreeWithPro,
                        actionHeight: _actionHeight,
                        actionRadius: _actionRadius,
                      )
                    else
                      AppButton.primary(
                        text: l10n.instantDoctorSubscribe,
                        isLoading: isLoading,
                        onPressed: onPrimaryAction,
                        width: double.infinity,
                        height: _actionHeight.h,
                        borderRadius: _actionRadius.r,
                        elevation: 0,
                        backgroundColor: AppColors.clr0FAA9A,
                        foregroundColor: AppColors.clrWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProviderHeader extends StatelessWidget {
  const _ProviderHeader({
    required this.provider,
    required this.subscribedLabel,
  });

  final InstantDoctorProviderEntity provider;
  final String subscribedLabel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(width: 12.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: provider.isSubscribed ? 72.w : 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.providerName,
                      style: TextStyle(
                        color: AppColors.clr061E40,
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                        height: 1.2,
                      ),
                    ),
                    if (provider.product.productTitle.trim().isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        provider.product.productTitle.trim(),
                        style: TextStyle(
                          color: AppColors.clr061E40,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                    ],
                    if (provider.product.priceDisplay.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        provider.product.priceDisplay,
                        style: TextStyle(
                          color: AppColors.clr43,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
        if (provider.isSubscribed)
          Positioned(
            top: 0,
            right: 0,
            child: _SubscribedBadge(label: subscribedLabel),
          ),
      ],
    );
  }
}

class _SubscribedBadge extends StatelessWidget {
  const _SubscribedBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.clrF3FCFB,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.clr0FAA9A,
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          height: 1,
        ),
      ),
    );
  }
}

class _BenefitsSection extends StatelessWidget {
  const _BenefitsSection({required this.benefits});

  final List<String> benefits;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        for (final benefit in benefits) _BenefitChip(label: benefit),
      ],
    );
  }
}

class _SubscribedActions extends StatelessWidget {
  const _SubscribedActions({
    required this.startConsultationLabel,
    required this.isLoading,
    required this.onPrimaryAction,
    required this.onCancelSubscription,
    required this.showCancelMenu,
    required this.actionHeight,
    required this.actionRadius,
  });

  final String startConsultationLabel;
  final bool isLoading;
  final VoidCallback onPrimaryAction;
  final VoidCallback onCancelSubscription;
  final bool showCancelMenu;
  final double actionHeight;
  final double actionRadius;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton.primary(
            text: startConsultationLabel,
            icon: Icons.phone_in_talk_rounded,
            isLoading: isLoading,
            onPressed: onPrimaryAction,
            width: double.infinity,
            height: actionHeight.h,
            borderRadius: actionRadius.r,
            elevation: 0,
            backgroundColor: AppColors.clrF3FCFB,
            foregroundColor: AppColors.clr0FAA9A,
            fontWeight: FontWeight.w700,
            fontSize: 15.sp,
          ),
        ),
        if (showCancelMenu) ...[
          SizedBox(width: 10.w),
          InstantDoctorProviderOptionsMenuWidget(
            size: actionHeight.h,
            borderRadius: actionRadius.r,
            onCancelSubscription: onCancelSubscription,
          ),
        ],
      ],
    );
  }
}

class _ProviderLogo extends StatelessWidget {
  const _ProviderLogo({required this.logoUrl});

  final String? logoUrl;

  @override
  Widget build(BuildContext context) {
    final url = logoUrl?.trim() ?? '';
    return Container(
      width: InstantDoctorProviderCardWidget._logoSize.r,
      height: InstantDoctorProviderCardWidget._logoSize.r,
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.clrE4E7EB),
      ),
      clipBehavior: Clip.antiAlias,
      child: url.isEmpty
          ? Icon(
              Icons.medical_services_outlined,
              size: 24.r,
              color: AppColors.clr6C7C92,
            )
          : CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.contain,
              placeholder: (_, _) => Center(
                child: SizedBox(
                  width: 18.r,
                  height: 18.r,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (_, _, _) => Icon(
                Icons.medical_services_outlined,
                size: 24.r,
                color: AppColors.clr6C7C92,
              ),
            ),
    );
  }
}

class _BenefitChip extends StatelessWidget {
  const _BenefitChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.clrEDEDED,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.clr061E40,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          height: 1.2,
        ),
      ),
    );
  }
}

class InstantDoctorProviderCardShimmer extends StatelessWidget {
  const InstantDoctorProviderCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        borderRadius: BorderRadius.circular(
          InstantDoctorProviderCardWidget._cardRadius.r,
        ),
        border: Border.all(color: AppColors.clrE4E7EB),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppShimmerCircle(
                diameter: InstantDoctorProviderCardWidget._logoSize.r,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppShimmerText(height: 18.h, borderRadius: 8.r),
                    SizedBox(height: 8.h),
                    AppShimmerText(
                      height: 14.h,
                      borderRadius: 6.r,
                      width: 140.w,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          AppShimmerText(height: 34.h, borderRadius: 20.r),
          SizedBox(height: 8.h),
          AppShimmerText(height: 34.h, borderRadius: 20.r, width: 220.w),
          SizedBox(height: 16.h),
          AppShimmerCard(
            width: double.infinity,
            height: InstantDoctorProviderCardWidget._actionHeight.h,
            borderRadius: InstantDoctorProviderCardWidget._actionRadius.r,
          ),
        ],
      ),
    );
  }
}
