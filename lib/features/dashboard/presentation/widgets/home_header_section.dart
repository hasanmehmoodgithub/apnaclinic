import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:apnaclinic/core/l10n/app_localizations.dart';
import 'package:apnaclinic/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/widgets/apna_clinic_app_bar.dart';

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
    final searchBarHeight = 50.h;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          color: AppColors.clr52A898,
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ApnaClinicAppBar(
                  style: ApnaAppBarStyle.greenHome,
                  transparentBackground: true,
                  systemOverlayStyle: ApnaClinicAppBar.lightBarColoredStatus,
                  onMenuTap: widget.onMenuTap,
                  onNotificationTap: widget.onNotificationTap,
                  notificationCount: widget.isLoggedIn ? widget.notificationCount : 0,
                  showNotificationDot: !widget.isLoggedIn,
                  showLoginButton: !widget.isLoggedIn,
                  filledLoginButton: true,
                  onLoginTap: widget.onLoginTap,
                  onProfileTap: widget.onProfileTap,
                  profileImageUrl: widget.profileImageUrl,
                ),
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.clr52A898,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(32.r),
                          bottomRight: Radius.circular(32.r),
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(24.w, 4.h, 24.w, 46.h),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          l10n.dashboardHello(widget.userName),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: AppColors.clrWhite,
                            fontWeight: FontWeight.w700,
                            fontSize: 22.sp,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20.w,
                      right: 20.w,
                      bottom: -24.h,
                      child: Container(
                        height: searchBarHeight,
                        decoration: BoxDecoration(
                          color: AppColors.clrWhite,
                          borderRadius:
                              BorderRadius.circular(searchBarHeight / 2),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.clrBlack.withValues(alpha: 0.08),
                              blurRadius: 12.r,
                              offset: Offset(0, 4.h),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          onSubmitted: _handleSubmitted,
                          textInputAction: TextInputAction.search,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.clr111827,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: AppColors.clrWhite,
                            hintText: l10n.dashboardSearchHint,
                            hintStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.clr6B7280,
                              fontWeight: FontWeight.w400,
                              fontSize: 13.sp,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(searchBarHeight / 2),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(searchBarHeight / 2),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(searchBarHeight / 2),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 14.h,
                            ),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 6.w, right: 2.w),
                              child: Icon(
                                Icons.search_rounded,
                                color: AppColors.clr52A898,
                                size: 22.r,
                              ),
                            ),
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 44.w,
                              minHeight: searchBarHeight,
                            ),
                            suffixIcon: IconButton(
                              onPressed:
                                  widget.onVoiceTap ?? _handleSearchTap,
                              icon: SvgPicture.asset(
                                Assets.svgIcSearchMic,
                                width: 20.r,
                                height: 20.r,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.clr09,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 32.h),
      ],
    );
  }
}
