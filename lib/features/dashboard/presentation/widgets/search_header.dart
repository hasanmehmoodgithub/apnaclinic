import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:apnaclinic/generated/assets.dart';
import 'package:apnaclinic/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class SearchHeader extends StatefulWidget {
  const SearchHeader({
    super.key,
    required this.userName,
    this.onSearchSubmitted,
    this.onVoiceTap,
    this.onSearchButtonTap,
  });

  final String userName;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onVoiceTap;
  final VoidCallback? onSearchButtonTap;
  @override
  State<SearchHeader> createState() => _SearchHeaderState();
}

class _SearchHeaderState extends State<SearchHeader> {
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

  /// Drops focus + closes the keyboard before we hand off to the next screen.
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.clr52A898,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              padding: EdgeInsets.fromLTRB(32.w, 18.h, 20.w, 42.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  l10n.dashboardHello(widget.userName),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.clrWhite,
                    fontWeight: FontWeight.w600,
                    fontSize: 24.sp,
                    letterSpacing: 0.15,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 24.w,
              right: 24.w,
              bottom: -24.h,
              child: Container(
                height: 54.h,
                decoration: BoxDecoration(
                  color: AppColors.clrF3F4F6,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                alignment: Alignment.center,
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onSubmitted: _handleSubmitted,
                  textInputAction: TextInputAction.search,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.clr111827,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: l10n.dashboardSearchHint,
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.clr1D4E89.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 14.h,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12.r),
                      child: Icon(
                        Icons.search_rounded,
                        color: AppColors.clr024886,
                        size: (34 / 1.35).r,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: (24 + 8).h),
      ],
    );
  }
}
