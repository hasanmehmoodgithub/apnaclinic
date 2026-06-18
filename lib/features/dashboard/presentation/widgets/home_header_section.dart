import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:apnaclinic/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/widgets/apna_clinic_app_bar.dart';
import '../constants/dashboard_ui_config.dart';
import 'home_header_search_field.dart';

class HomeHeaderSection extends StatefulWidget {
  const HomeHeaderSection({
    super.key,
    required this.userName,
    required this.isLoggedIn,
    required this.notificationCount,
    this.profileImageUrl,
    this.onMenuTap,
    this.onNotificationTap,
    this.onLoginTap,
    this.onProfileTap,
    this.onSearchSubmitted,
    this.onVoiceTap,
    this.onSearchButtonTap,
  });

  final String userName;
  final bool isLoggedIn;
  final int notificationCount;
  final String? profileImageUrl;
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onLoginTap;
  final VoidCallback? onProfileTap;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onVoiceTap;
  final VoidCallback? onSearchButtonTap;

  static const SystemUiOverlayStyle _headerOverlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );

  @override
  State<HomeHeaderSection> createState() => _HomeHeaderSectionState();
}

class _HomeHeaderSectionState extends State<HomeHeaderSection> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    _focusNode.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _handleSearchTap() {
    final text = _controller.text.trim();
    _dismissKeyboard();
    if (text.isEmpty) {
      widget.onSearchButtonTap?.call();
    } else {
      widget.onSearchSubmitted?.call(text);
      _controller.clear();
    }
  }

  void _handleSubmitted(String value) {
    final text = value.trim();
    _dismissKeyboard();
    if (text.isEmpty) {
      widget.onSearchButtonTap?.call();
    } else {
      widget.onSearchSubmitted?.call(text);
      _controller.clear();
    }
  }

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
                      onMenuTap: widget.onMenuTap,
                      onNotificationTap: widget.onNotificationTap,
                      notificationCount:
                          widget.isLoggedIn ? widget.notificationCount : 0,
                      showNotificationDot: !widget.isLoggedIn,
                      showLoginButton: !widget.isLoggedIn,
                      filledLoginButton: true,
                      onLoginTap: widget.onLoginTap,
                      onProfileTap: widget.onProfileTap,
                      profileImageUrl: widget.profileImageUrl,
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
                            l10n.dashboardHello(widget.userName),
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
                            controller: _controller,
                            focusNode: _focusNode,
                            hintText: l10n.dashboardSearchHint,
                            onSubmitted: _handleSubmitted,
                            onVoiceTap: widget.onVoiceTap,
                            onSearchTap: _handleSearchTap,
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
