import 'package:flutter/material.dart';

/// Widget extensions for common widget operations
extension WidgetExtensions on Widget {
  /// Add padding to widget
  Widget padding(EdgeInsets padding) {
    return Padding(padding: padding, child: this);
  }

  /// Add padding all around
  Widget paddingAll(double value) {
    return Padding(padding: EdgeInsets.all(value), child: this);
  }

  /// Add padding symmetric
  Widget paddingSymmetric({double? horizontal, double? vertical}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal ?? 0,
        vertical: vertical ?? 0,
      ),
      child: this,
    );
  }

  /// Add padding only
  Widget paddingOnly({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: left ?? 0,
        top: top ?? 0,
        right: right ?? 0,
        bottom: bottom ?? 0,
      ),
      child: this,
    );
  }

  /// Add margin to widget
  Widget margin(EdgeInsets margin) {
    return Container(margin: margin, child: this);
  }

  /// Add margin all around
  Widget marginAll(double value) {
    return Container(margin: EdgeInsets.all(value), child: this);
  }

  /// Add margin symmetric
  Widget marginSymmetric({double? horizontal, double? vertical}) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontal ?? 0,
        vertical: vertical ?? 0,
      ),
      child: this,
    );
  }

  /// Add margin only
  Widget marginOnly({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return Container(
      margin: EdgeInsets.only(
        left: left ?? 0,
        top: top ?? 0,
        right: right ?? 0,
        bottom: bottom ?? 0,
      ),
      child: this,
    );
  }

  /// Center widget
  Widget get center => Center(child: this);

  /// Align widget
  Widget align(Alignment alignment) {
    return Align(alignment: alignment, child: this);
  }

  /// Expand widget
  Widget get expand => Expanded(child: this);

  /// Flexible widget
  Widget flexible({int flex = 1}) {
    return Flexible(flex: flex, child: this);
  }

  /// Add background color
  Widget backgroundColor(Color color) {
    return Container(color: color, child: this);
  }

  /// Add border
  Widget border({
    Color? color,
    double width = 1.0,
    BorderRadius? borderRadius,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color ?? Colors.grey, width: width),
        borderRadius: borderRadius,
      ),
      child: this,
    );
  }

  /// Add rounded corners
  Widget rounded(double radius) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: this,
    );
  }

  /// Add shadow
  Widget shadow({
    Color color = Colors.black26,
    double blurRadius = 4.0,
    Offset offset = const Offset(0, 2),
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: blurRadius,
            offset: offset,
          ),
        ],
      ),
      child: this,
    );
  }

  /// Make widget clickable
  Widget onTap(VoidCallback onTap, {bool opaque = true}) {
    return GestureDetector(
      onTap: onTap,
      behavior: opaque ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
      child: this,
    );
  }

  /// Make widget scrollable
  Widget get scrollable => SingleChildScrollView(child: this);

  /// Add opacity
  Widget opacity(double opacity) {
    return Opacity(opacity: opacity.clamp(0.0, 1.0), child: this);
  }

  /// Add visibility
  Widget visible(bool visible) {
    return Visibility(visible: visible, child: this);
  }

  /// Wrap with SizedBox
  Widget sized({double? width, double? height}) {
    return SizedBox(width: width, height: height, child: this);
  }

  /// Wrap with SizedBox.square
  Widget square(double size) {
    return SizedBox(width: size, height: size, child: this);
  }

  /// Wrap with SizedBox.expand
  Widget get sizedExpand => SizedBox.expand(child: this);

  /// Add tooltip
  Widget tooltip(String message) {
    return Tooltip(message: message, child: this);
  }

  /// Wrap with SafeArea
  Widget get safeArea => SafeArea(child: this);

  /// Wrap with Material
  Widget material({Color? color, double? elevation}) {
    return Material(
      color: color ?? Colors.transparent,
      elevation: elevation ?? 0,
      child: this,
    );
  }

  /// Wrap with InkWell
  Widget inkWell({
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    BorderRadius? borderRadius,
  }) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: borderRadius,
      child: this,
    );
  }
}
