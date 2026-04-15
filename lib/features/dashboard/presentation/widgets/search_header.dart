import 'package:apnaclinic/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

/// Solid teal header with rounded bottom + search row overlapping into the body.
class SearchHeader extends StatelessWidget {
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

  /// Design teal (header panel).
  static const Color _headerTeal = Color(0xFF52A898);

  /// Placeholder / icons — muted blue-grey & dark blue.
  static const Color _hintText = Color(0xFF1D4E89);
  static const Color _iconBlue = Color(0xFF024886);
  static const Color _fieldBg = Color(0xFFF3F4F6);


  static const double _cornerRadius = 28;
  static const double _searchHeight = 54.0;
  static const double _overlap = 24;

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
                color: _headerTeal,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(_cornerRadius),
                  bottomRight: Radius.circular(_cornerRadius),
                ),
              ),
              padding: EdgeInsets.fromLTRB(32.w, 18.h, 20.w, 42.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  'Hello, $userName',
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
              bottom: -_overlap.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: _searchHeight.h,
                      decoration: BoxDecoration(
                        color: _fieldBg,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      alignment: Alignment.center,
                      child: TextField(
                        onSubmitted: onSearchSubmitted,
                        textInputAction: TextInputAction.search,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF111827),
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Search Medicine, Doctor, Test....',
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: _hintText,
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
                              onTap: onVoiceTap,
                              borderRadius: BorderRadius.circular(22.r),
                              child: Padding(
                                padding: EdgeInsets.all(12.r),
                                child: SizedBox(
                                  width: 17.w,
                                  height: 23.h,
                                  child: SvgPicture.asset(Assets.svgIcSearchMic),
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
                    width: _searchHeight.r,
                    height: _searchHeight.r,
                    decoration: BoxDecoration(
                      color: _fieldBg,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12.r),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: onSearchButtonTap,
                        borderRadius: BorderRadius.circular(12.r),
                        child: Center(
                          child: Icon(
                            Icons.search_rounded,
                            color: _iconBlue,
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
        // Space for the part of the search row that sits below the teal block
        SizedBox(height: (_overlap + 8).h),
      ],
    );
  }
}
