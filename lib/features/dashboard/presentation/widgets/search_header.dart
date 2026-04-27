import 'package:apnaclinic/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

/// Solid teal header with rounded bottom + search row overlapping into the body.
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';

class SearchHeader extends StatefulWidget {
  const SearchHeader({
    super.key,
    required this.userName,
    this.onSearchSubmitted,
    this.onVoiceTap,
    this.onSearchButtonTap,
  });

  final String userName;

  /// Called with whatever the user typed when they either:
  ///  - press enter / submit on the keyboard, OR
  ///  - tap the adjacent square search button.
  ///
  /// Navigate to the Search screen inside this callback and pass the
  /// [query] as the initial query (see [HomeScreen]).
  final ValueChanged<String>? onSearchSubmitted;

  final VoidCallback? onVoiceTap;

  /// Called when the search button is tapped with an empty field.
  /// Use this to just open the search screen without a preset query.
  final VoidCallback? onSearchButtonTap;

  static const Color _headerTeal = Color(0xFF52A898);
  static const Color _hintText = Color(0xFF1D4E89);
  static const Color _iconBlue = Color(0xFF024886);
  static const Color _fieldBg = Color(0xFFF3F4F6);

  static const double _cornerRadius = 28;
  static const double _searchHeight = 54.0;
  static const double _overlap = 24;

  @override
  State<SearchHeader> createState() => _SearchHeaderState();
}

class _SearchHeaderState extends State<SearchHeader> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSearchTap() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      widget.onSearchButtonTap?.call();
    } else {
      widget.onSearchSubmitted?.call(text);
      // Clear the home field so it doesn't stay stale when the user returns.
      _controller.clear();
    }
  }

  void _handleSubmitted(String value) {
    final text = value.trim();
    if (text.isEmpty) {
      widget.onSearchButtonTap?.call();
    } else {
      widget.onSearchSubmitted?.call(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                color: SearchHeader._headerTeal,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(SearchHeader._cornerRadius),
                  bottomRight: Radius.circular(SearchHeader._cornerRadius),
                ),
              ),
              padding: EdgeInsets.fromLTRB(32.w, 18.h, 20.w, 42.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  'Hello, ${widget.userName}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
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
              bottom: -SearchHeader._overlap.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: SearchHeader._searchHeight.h,
                      decoration: BoxDecoration(
                        color: SearchHeader._fieldBg,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      alignment: Alignment.center,
                      child: TextField(
                        controller: _controller,
                        onSubmitted: _handleSubmitted,
                        textInputAction: TextInputAction.search,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF111827),
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Search Medicine, Doctor, Test....',
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: SearchHeader._hintText,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 14.h,
                          ),
                          suffixIcon: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: widget.onVoiceTap,
                              borderRadius: BorderRadius.circular(22.r),
                              child: Padding(
                                padding: EdgeInsets.all(12.r),
                                child: SizedBox(
                                  width: 17.w,
                                  height: 23.h,
                                  child: SvgPicture.asset(
                                    Assets.svgIcSearchMic,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Container(
                    width: SearchHeader._searchHeight.r,
                    height: SearchHeader._searchHeight.r,
                    decoration: BoxDecoration(
                      color: SearchHeader._fieldBg,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12.r),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: _handleSearchTap,
                        borderRadius: BorderRadius.circular(12.r),
                        child: Center(
                          child: Icon(
                            Icons.search_rounded,
                            color: SearchHeader._iconBlue,
                            size: (34 / 1.35).r,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: (SearchHeader._overlap + 8).h),
      ],
    );
  }
}
