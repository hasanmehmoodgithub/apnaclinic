import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/utils/no_emoji_text_input_formatter.dart';
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

  void _submit() => onSearch?.call(controller.text);

  void _clear() {
    if (controller.text.isEmpty) return;
    controller.clear();
    onChanged?.call('');
    onClear?.call();
  }

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
          color: AppColors.clr9BA6A7,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              inputFormatters: NoEmojiTextInputFormatter.merge(null),
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
                  color: AppColors.clr667B99,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
          ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (controller.text.isNotEmpty)
                    GestureDetector(
                      onTap: _clear,
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: EdgeInsets.all(6.w),
                        child: Icon(
                          Icons.close_rounded,
                          size: 16.r,
                          color: AppColors.clr667B99,
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
              );
            },
          ),
        ],
      ),
    );
  }
}
