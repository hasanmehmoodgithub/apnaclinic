import 'package:flutter/widgets.dart';

/// Centralized responsive sizing service based on the design canvas.
class ResponsiveConfigService {
  final double designWidth;
  final double designHeight;

  const ResponsiveConfigService({
    this.designWidth = 430,
    this.designHeight = 932,
  });

  double w(BuildContext context, double value) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return (screenWidth / designWidth) * value;
  }

  double h(BuildContext context, double value) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    return (screenHeight / designHeight) * value;
  }

  double r(BuildContext context, double value) {
    final widthScale = MediaQuery.sizeOf(context).width / designWidth;
    final heightScale = MediaQuery.sizeOf(context).height / designHeight;
    final scale = widthScale < heightScale ? widthScale : heightScale;
    return value * scale;
  }

  double sp(BuildContext context, double value) => r(context, value);
}
