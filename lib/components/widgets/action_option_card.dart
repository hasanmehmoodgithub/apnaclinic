import 'package:apnaclinic/core/extensions/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActionOptionCard extends StatelessWidget {
  const ActionOptionCard({
    super.key,
    required this.title,
    required this.onTap,
    required this.leading,
    this.content,
    this.curveOverlayColor = const Color(0xFFE9F9FC),
    this.curveWidthFactor = 0.7206,
    this.curveHeight = 281.37,
    this.curveLeftFactor = 0.6290,
    this.subtitle,
    this.trailing,
    this.onTrailingTap,
    this.titleStyle,
    this.subtitleStyle,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 15),
    this.height,
    this.titleSpacing = 7,
    this.radius = 4.0,
    this.trailingOverlayWidth,
    this.trailingOverlayHeight,
  });

  final String title;
  final VoidCallback onTap;
  final Widget leading;
  final Widget? content;
  final Color curveOverlayColor;
  final double curveWidthFactor;
  final double curveHeight;
  final double curveLeftFactor;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTrailingTap;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final EdgeInsetsGeometry contentPadding;
  final double? height;
  final double titleSpacing;
  final double radius;
  final double? trailingOverlayWidth;
  final double? trailingOverlayHeight;

  static const String _arrowAsset = 'assets/svg/ic_support_card_arrow.svg';
  static const Color _headingDark = Color(0xFF111827);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardHeight = height ?? 92.h;

    return Card(
      elevation: 0.010,
      shadowColor: Colors.white,
      child: SizedBox(
        height: cardHeight,
        width: double.infinity,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth;
            final curveWidth = cardWidth * curveWidthFactor;
            final resolvedCurveHeight = curveHeight.h;
            final curveLeft = cardWidth * curveLeftFactor;
            final resolvedTrailingWidth = trailingOverlayWidth ?? 44.w;
            final resolvedTrailingHeight = trailingOverlayHeight ?? 46.h;

            // Center the trailing control within the visible curved area.
            final visibleCurveStart = curveLeft.clamp(0.0, cardWidth);
            final trailingLeft =
                ((visibleCurveStart + cardWidth) / 2) -
                (resolvedTrailingWidth / 2);

            return InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              child: Ink(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(radius)),
                  border: Border.all(color: const Color(0xFFF3F4F6)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(radius)),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Positioned(
                        left: curveLeft,
                        top: -48.78.h,
                        child: IgnorePointer(
                          child: Container(
                            width: curveWidth,
                            height: resolvedCurveHeight,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: curveOverlayColor,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: contentPadding,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              leading,
                              SizedBox(width: 12.w),
                              Expanded(
                                child: content ?? _buildDefaultContent(theme),
                              ),
                              SizedBox(width: resolvedTrailingWidth),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: trailingLeft,
                        top: (cardHeight - resolvedTrailingHeight) / 2,
                        child: SizedBox(
                          width: resolvedTrailingWidth,
                          height: resolvedTrailingHeight,
                          child: trailing != null
                              ? GestureDetector(
                                  onTap: onTrailingTap,
                                  behavior: HitTestBehavior.opaque,
                                  child: Center(child: trailing!),
                                )
                              : Center(
                                  child: SvgPicture.asset(
                                    _arrowAsset,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDefaultContent(ThemeData theme) {
    if (subtitle == null) {
      return Text(
        title,
        style: titleStyle ??
            theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: _headingDark,
            ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: titleStyle ??
              theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: _headingDark,
              ),
        ),
        SizedBox(height: titleSpacing),
        Text(
          subtitle!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: subtitleStyle ??
              theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF4A4A4A),
              ),
        ),
      ],
    );
  }
}
