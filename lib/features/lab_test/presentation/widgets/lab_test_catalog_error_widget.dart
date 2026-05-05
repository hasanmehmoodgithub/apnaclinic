import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

/// Catalog failed to load; prefers server message when present.
class LabTestCatalogErrorWidget extends StatelessWidget {
  const LabTestCatalogErrorWidget({
    super.key,
    required this.fallbackMessage,
    this.detailMessage,
  });

  final String fallbackMessage;
  final String? detailMessage;

  @override
  Widget build(BuildContext context) {
    final text = (detailMessage != null && detailMessage!.trim().isNotEmpty)
        ? detailMessage!.trim()
        : fallbackMessage;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
