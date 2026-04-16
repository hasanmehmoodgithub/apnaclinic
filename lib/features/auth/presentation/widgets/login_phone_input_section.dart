import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';

class LoginPhoneInputSection extends StatelessWidget {
  const LoginPhoneInputSection({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.errorText,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.authMobileNumberLabel,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF061E40),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          l10n.authLoginSubtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: const Color(0xFF98A2B3),
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 12.h),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: '3XXXXXXXXX',
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF667085),
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 16.w, right: 6.w),
              child: Text(
                '+92',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF061E40),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            counterText: '',
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 15.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: Color(0xFF9BA6A7),
                width: 0.9,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: Color(0xFF9BA6A7),
                width: 0.9,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: Color(0xFFE01F26),
                width: 0.9,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: Color(0xFFE01F26),
                width: 0.9,
              ),
            ),
          ),
          onChanged: onChanged,
          validator: (value) {
            final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
            final isValidPakMobile = RegExp(r'^3\d{9}$').hasMatch(digits);
            if (!isValidPakMobile) {
              return l10n.authPhoneValidationError;
            }
            return null;
          },
        ),
        SizedBox(height: 4.h),
        Text(
          l10n.authOtpHint,
          style: theme.textTheme.bodySmall?.copyWith(
            color: const Color(0xFF98A2B3),
          ),
        ),
        if (errorText != null) ...[
          SizedBox(height: 6.h),
          Text(
            errorText!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFFE01F26),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
