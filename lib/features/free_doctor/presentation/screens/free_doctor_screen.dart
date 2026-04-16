import 'package:apnaclinic/components/shimmer/app_shimmer.dart';
import 'package:apnaclinic/components/widgets/app_button.dart';
import 'package:apnaclinic/core/enums/state_status.dart';
import 'package:apnaclinic/core/extensions/context_extensions.dart';
import 'package:apnaclinic/core/extensions/screen_util_extensions.dart';
import 'package:apnaclinic/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/free_doctor_cubit.dart';
import '../cubit/free_doctor_state.dart';

class FreeDoctorScreen extends StatelessWidget {
  const FreeDoctorScreen({super.key, this.showBackButton = true, this.onBack});

  final bool showBackButton;
  final VoidCallback? onBack;

  static const String _watermarkAsset = Assets.imgPartner;
  static const Color _titleNavy = Color(0xFF0B2239);
  static const Color _primaryTeal = Color(0xFF0FAA9A);
  static const double _cardOverlap = 72;
  static const double _cardTopRadius = 32;
  static const double _topBannerFraction = 0.35;

  @override
  Widget build(BuildContext context) {
    final bannerHeight = MediaQuery.sizeOf(context).height * _topBannerFraction;
    return BlocConsumer<FreeDoctorCubit, FreeDoctorState>(
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
        return ColoredBox(
          color: const Color(0xFFF4F6F8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: bannerHeight,
                child: _FreeDoctorTopHeader(
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
                      child: _ConsultationInfoCard(state: state),
                    ),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                minimum: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                child: AppButton.primary(
                  text: 'Open Fikrfree app',
                  isLoading: state.isOpeningApp,
                  onPressed: () async {
                    final opened = await context
                        .read<FreeDoctorCubit>()
                        .openFikrfreeApp();
                    if (!opened && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Could not open FikrFree right now.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  width: double.infinity,
                  height: 52.h,
                  borderRadius: 14.r,
                  elevation: 0,
                  backgroundColor: FreeDoctorScreen._primaryTeal,
                  foregroundColor: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FreeDoctorTopHeader extends StatelessWidget {
  const _FreeDoctorTopHeader({
    required this.showBackButton,
    required this.onBack,
  });

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
          colors: [Color(0xFFB8EDE5), Color(0xFFE8F8F5), Color(0xFFF5FBFA)],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(
              height: 50.h,
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
                            color: FreeDoctorScreen._titleNavy,
                          )
                        : SizedBox(width: 48.w),
                  ),
                  Text(
                    'Free Doctor',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: FreeDoctorScreen._titleNavy,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ClipRect(
                child: Align(
                  alignment: const Alignment(0, 0.32),
                  heightFactor: 0.72,
                  widthFactor: 1,
                  child: Image.asset(
                    Assets.imgHeroFamily,
                    fit: BoxFit.fitWidth,
                      width: context.screenWidth - 80.w,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConsultationInfoCard extends StatelessWidget {
  const _ConsultationInfoCard({required this.state});

  final FreeDoctorState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const radius = BorderRadius.vertical(
      top: Radius.circular(FreeDoctorScreen._cardTopRadius),
    );

    final points =
        state.content?.descriptionPoints ??
        const [
          'This service is available exclusively for Bima m-Health subscribers.',
          'Get 24/7 access to qualified doctors for general medical support and much more.',
          'To avail the service, subscribe to BIMA m-Health via FikrFree.',
        ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F8),
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
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: Opacity(
                    opacity: 0.08,
                    child: Image.asset(
                      FreeDoctorScreen._watermarkAsset,
                      width: 260.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            if (state.loadingStateStatus == StateStatus.loading)
              const _ConsultationInfoShimmer()
            else
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(18.w, 28.h, 20.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          Assets.iconsNurse,
                          color: Color(0xff0FAA9A),
                          height: 16.h,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            state.content?.title ??
                                '24/7 Free Doctor Consultation',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: FreeDoctorScreen._titleNavy,
                              height: 1.25,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    for (int i = 0; i < points.length; i++) ...[
                      _Bullet(
                        text: points[i],
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.black,
                          height: 1.45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (i != points.length - 1) SizedBox(height: 12.h),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ConsultationInfoShimmer extends StatelessWidget {
  const _ConsultationInfoShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppShimmerCircle(diameter: 48.r),
              SizedBox(width: 14.w),
              Expanded(child: AppShimmerText(height: 20.h, borderRadius: 8.r)),
            ],
          ),
          SizedBox(height: 22.h),
          AppShimmerText(height: 14.h, borderRadius: 6.r),
          SizedBox(height: 8.h),
          AppShimmerText(height: 14.h, borderRadius: 6.r, width: 260.w),
          SizedBox(height: 18.h),
          AppShimmerText(height: 14.h, borderRadius: 6.r),
          SizedBox(height: 8.h),
          AppShimmerText(height: 14.h, borderRadius: 6.r, width: 240.w),
          SizedBox(height: 18.h),
          AppShimmerText(height: 14.h, borderRadius: 6.r),
          SizedBox(height: 8.h),
          AppShimmerText(height: 14.h, borderRadius: 6.r, width: 220.w),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text, required this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 7.h),
          child: Container(
            width: 5.r,
            height: 5.r,
            decoration: const BoxDecoration(
              color: Color(0xFF111827),
              shape: BoxShape.circle,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(child: Text(text, style: style)),
      ],
    );
  }
}
