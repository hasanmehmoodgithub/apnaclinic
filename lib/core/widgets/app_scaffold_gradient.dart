import 'package:flutter/material.dart';

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
  });

  final Widget child;
  final PreferredSizeWidget? appBar;
  final List<Color> colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final bool useSafeArea;

  @override
  Widget build(BuildContext context) {
    final content = useSafeArea ? SafeArea(child: child) : child;
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
