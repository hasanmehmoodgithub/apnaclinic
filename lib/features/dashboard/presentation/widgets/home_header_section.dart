import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:apnaclinic/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/widgets/apna_clinic_app_bar.dart';
import '../constants/dashboard_ui_config.dart';
import 'home_header_search_field.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({
    super.key,
    required this.userName,
    required this.isLoggedIn,
    required this.hasUnreadNotifications,
    this.profileImageUrl,
    this.profileImageCacheKey,
    this.onMenuTap,
    this.onNotificationTap,
    this.onLoginTap,
    this.onProfileTap,
    this.onSearchTap,
    this.onVoiceTap,
  });

  final String userName;
  final bool isLoggedIn;
  final bool hasUnreadNotifications;
  final String? profileImageUrl;
  final String? profileImageCacheKey;
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onLoginTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onVoiceTap;

  static const SystemUiOverlayStyle _headerOverlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: HomeHeaderSection._headerOverlay,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.clr0FAA9A,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(
                  DashboardUiConfig.homeHeaderBottomRadius.r,
                ),
                bottomRight: Radius.circular(
                  DashboardUiConfig.homeHeaderBottomRadius.r,
                ),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: DashboardUiConfig.homeHeaderBottomPadding.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ApnaClinicAppBar(
                      style: ApnaAppBarStyle.greenHome,
                      transparentBackground: true,
                      onMenuTap: onMenuTap,
                      onNotificationTap: onNotificationTap,
                      showNotificationDot:
                          isLoggedIn && hasUnreadNotifications,
                      showLoginButton: !isLoggedIn,
                      filledLoginButton: true,
                      onLoginTap: onLoginTap,
                      onProfileTap: onProfileTap,
                      profileImageUrl: profileImageUrl,
                      profileImageCacheKey: profileImageCacheKey,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            DashboardUiConfig.homeHeaderHorizontalPadding.w,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: DashboardUiConfig.homeHeaderGreetingTopGap.h,
                          ),
                          Text(
                            l10n.dashboardHello(userName),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: AppColors.clrWhite,
                              fontWeight: FontWeight.w700,
                              fontSize: 20.sp,
                              height: 1.2,
                              letterSpacing: 0.1,
                            ),
                          ),
                          SizedBox(
                            height:
                                DashboardUiConfig.homeHeaderGreetingSearchGap.h,
                          ),
                          HomeHeaderSearchField(
                            hintText: l10n.dashboardSearchHint,
                            onTap: onSearchTap ?? () {},
                            onVoiceTap: onVoiceTap,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: DashboardUiConfig.homeHeaderBelowSpacing.h),
        ],
      ),
    );
  }
}
