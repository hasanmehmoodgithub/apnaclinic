import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

/// Shown when the lab test cart has no lines.
class LabTestCartEmptyWidget extends StatelessWidget {
  const LabTestCartEmptyWidget({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF667B99),
          fontSize: 14.sp,
        ),
      ),
    );
  }
}
