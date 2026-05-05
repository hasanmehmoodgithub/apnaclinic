import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

/// White rounded panel wrapping the main browse content below the gradient header.
class LabTestBrowseWhitePanelWidget extends StatelessWidget {
  const LabTestBrowseWhitePanelWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 29.h, 24.w, 16.h),
          child: child,
        ),
      ),
    );
  }
}
