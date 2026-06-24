import 'package:flutter/material.dart';

import '../extensions/screen_util_extensions.dart';

class AppScaffoldGradient extends StatelessWidget {
  const AppScaffoldGradient({
    super.key,
    required this.child,
    this.appBar,
    this.colors = const [
      Color(0xFFD5FFFB),
      Color(0xFFE0E6FF),
    ],
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.useSafeArea = true,
    this.safeAreaBottom = false,
  });

  final Widget child;
  final PreferredSizeWidget? appBar;
  final List<Color> colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final bool useSafeArea;

  /// When false (default), the gradient may show under the home indicator unless
  /// a full-height [AppScaffoldGradientPanel] covers the bottom.
  final bool safeAreaBottom;

  @override
  Widget build(BuildContext context) {
    final content = useSafeArea
        ? SafeArea(
            top: true,
            bottom: safeAreaBottom,
            child: child,
          )
        : child;
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            colors: colors,
          ),
        ),
        child: content,
      ),
    );
  }
}

/// Full-height rounded panel below a gradient header. Extends to the physical
/// bottom edge; applies only the bottom safe inset to [child].
class AppScaffoldGradientPanel extends StatelessWidget {
  const AppScaffoldGradientPanel({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.topBorderRadius,
  });

  final Widget child;
  final Color color;
  final double? topBorderRadius;

  @override
  Widget build(BuildContext context) {
    final radius = topBorderRadius ?? 42.r;
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
        ),
        child: SafeArea(top: false, child: child),
      ),
    );
  }
}
