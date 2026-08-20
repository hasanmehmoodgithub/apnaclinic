import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/no_emoji_text_input_formatter.dart';

/// Reusable text field widget for the entire app
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final Color? fillColor;
  final Color? borderColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final bool autofocus;
  final String? autofillHints;

  const AppTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.inputFormatters,
    this.fillColor,
    this.borderColor,
    this.borderRadius,
    this.contentPadding,
    this.autofocus = false,
    this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: obscureText ? 1 : maxLines,
      maxLength: maxLength,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      inputFormatters: NoEmojiTextInputFormatter.merge(
        inputFormatters,
        allowEmailSymbols: keyboardType == TextInputType.emailAddress,
        allowBasicPunctuation: (maxLines ?? 1) != 1,
      ),
      autofocus: autofocus,
      autofillHints: autofillHints != null ? [autofillHints!] : null,
      style: TextStyle(
        fontSize: AppSizes.textSizeM,
        color: enabled
            ? colorScheme.onSurface
            : colorScheme.onSurface.withValues(alpha: 0.6),
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: enabled
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.6),
              )
            : null,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? AppSizes.radiusM),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? AppSizes.radiusM),
          borderSide: BorderSide(
            color: borderColor ?? colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? AppSizes.radiusM),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? AppSizes.radiusM),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? AppSizes.radiusM),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? AppSizes.radiusM),
          borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
        ),
        filled: true,
        fillColor: fillColor ?? colorScheme.surface,
        contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(
              horizontal: AppSizes.paddingL,
              vertical: AppSizes.paddingL,
            ),
        counterText: maxLength != null ? '' : null,
      ),
    );
  }
}
