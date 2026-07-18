import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';
import 'lab_test_figma_image.dart';

/// Search field for filtering the lab test catalog (controller owned by screen).
class LabTestBrowseSearchFieldWidget extends StatelessWidget {
  const LabTestBrowseSearchFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.onSearch,
  });

  final TextEditingController controller;
  final String hintText;

  /// Optional live typing callback (e.g. city sheet local filter).
  final ValueChanged<String>? onChanged;

  /// Called when the search icon is tapped or the keyboard submits.
  final ValueChanged<String>? onSearch;

  void _submit() => onSearch?.call(controller.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 11.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(39.988.r),
        border: Border.all(
          color: const Color(0xFF9BA6A7),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: (_) => _submit(),
              textInputAction: TextInputAction.search,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF061E40),
                fontSize: 14.sp,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF667B99),
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onSearch == null ? null : _submit,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.all(6.w),
              child: LabTestFigmaImage(
                url: Assets.labTestSearchGlyphSmall,
                width: 13,
                height: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
