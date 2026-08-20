import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';
import 'lab_test_figma_image.dart';

/// Search field for filtering the lab test catalog (controller owned by screen).
class LabTestBrowseSearchFieldWidget extends StatefulWidget {
  const LabTestBrowseSearchFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.onSearch,
    this.onClear,
  });

  final TextEditingController controller;
  final String hintText;

  /// Optional live typing callback (e.g. city sheet local filter).
  final ValueChanged<String>? onChanged;

  /// Called when the search icon is tapped or the keyboard submits.
  final ValueChanged<String>? onSearch;

  /// Called after the field is cleared via the cross icon.
  final VoidCallback? onClear;

  @override
  State<LabTestBrowseSearchFieldWidget> createState() =>
      _LabTestBrowseSearchFieldWidgetState();
}

class _LabTestBrowseSearchFieldWidgetState
    extends State<LabTestBrowseSearchFieldWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant LabTestBrowseSearchFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onTextChanged);
      widget.controller.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  void _submit() => widget.onSearch?.call(widget.controller.text);

  void _clear() {
    if (widget.controller.text.isEmpty) return;
    widget.controller.clear();
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasText = widget.controller.text.isNotEmpty;

    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 11.w),
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        borderRadius: BorderRadius.circular(39.988.r),
        border: Border.all(
          color: AppColors.clr9BA6A7,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              onChanged: widget.onChanged,
              onSubmitted: (_) => _submit(),
              textInputAction: TextInputAction.search,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.clr060,
                fontSize: 14.sp,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.clr667B99,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
          if (hasText)
            GestureDetector(
              onTap: _clear,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.all(6.w),
                child: Icon(
                  Icons.close_rounded,
                  size: 18.r,
                  color: AppColors.clr667B99,
                ),
              ),
            ),
          GestureDetector(
            onTap: widget.onSearch == null ? null : _submit,
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
