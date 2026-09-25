import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/no_emoji_text_input_formatter.dart';

/// Checkout address card: saved-from-profile vs different address + multiline field.
///
/// Figma: Address section above Emergency Contact on Payment Details.
enum LabTestCheckoutAddressSource { savedFromProfile, different }

class LabTestCheckoutAddressCardWidget extends StatelessWidget {
  const LabTestCheckoutAddressCardWidget({
    super.key,
    required this.theme,
    required this.controller,
    required this.source,
    required this.onSourceChanged,
    this.hasError = false,
  });

  static const int maxAddressLength = 255;

  final ThemeData theme;
  final TextEditingController controller;
  final LabTestCheckoutAddressSource source;
  final ValueChanged<LabTestCheckoutAddressSource> onSourceChanged;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.clrEDEDED),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.labTestAddressLabel,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.clr061E40,
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 12.h),
            _AddressRadioRow(
              label: l10n.labTestUseSavedAddressFromProfile,
              selected: source == LabTestCheckoutAddressSource.savedFromProfile,
              onTap: () => onSourceChanged(
                LabTestCheckoutAddressSource.savedFromProfile,
              ),
            ),
            SizedBox(height: 10.h),
            _AddressRadioRow(
              label: l10n.labTestUseDifferentAddress,
              selected: source == LabTestCheckoutAddressSource.different,
              onTap: () =>
                  onSourceChanged(LabTestCheckoutAddressSource.different),
            ),
            SizedBox(height: 12.h),
            _AddressInputBox(
              theme: theme,
              controller: controller,
              hint: l10n.labTestAddressHint,
              hasError: hasError,
              readOnly:
                  source == LabTestCheckoutAddressSource.savedFromProfile,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressRadioRow extends StatelessWidget {
  const _AddressRadioRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.clr667B99,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ),
              SizedBox(width: 8.w),
              _RadioDot(selected: selected),
            ],
          ),
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.clr061E40;
    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? color : AppColors.clr9BA6A7,
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: selected
          ? Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
}

class _AddressInputBox extends StatelessWidget {
  const _AddressInputBox({
    required this.theme,
    required this.controller,
    required this.hint,
    required this.hasError,
    required this.readOnly,
  });

  final ThemeData theme;
  final TextEditingController controller;
  final String hint;
  final bool hasError;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: hasError ? AppColors.clrFFF8F8 : AppColors.clrF2F2F2,
        borderRadius: BorderRadius.circular(8.r),
        border: hasError
            ? Border.all(color: AppColors.clrBA2025, width: 1)
            : null,
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        enableInteractiveSelection: !readOnly,
        minLines: 2,
        maxLines: 4,
        keyboardType: TextInputType.streetAddress,
        textCapitalization: TextCapitalization.sentences,
        inputFormatters: NoEmojiTextInputFormatter.merge(
          [
            LengthLimitingTextInputFormatter(
              LabTestCheckoutAddressCardWidget.maxAddressLength,
            ),
          ],
          allowBasicPunctuation: true,
        ),
        style: theme.textTheme.bodyMedium?.copyWith(
          color: hasError ? AppColors.clrBA2025 : AppColors.clr061E40,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          hintText: hint,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: hasError ? AppColors.clrBA2025 : AppColors.clr667B99,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
        ),
      ),
    );
  }
}
