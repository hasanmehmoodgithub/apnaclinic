import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';

class LoginOtpSection extends StatelessWidget {
  const LoginOtpSection({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.otpSecondsRemaining,
    required this.canResendOtp,
    required this.onResendTap,
    required this.onOtpChanged,
    required this.errorText,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final int otpSecondsRemaining;
  final bool canResendOtp;
  final VoidCallback onResendTap;
  final ValueChanged<String> onOtpChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final itemSpacing = 10.w;
    final defaultPinTheme = PinTheme(
      width: 82.w,
      height: 68.h,
      textStyle: theme.textTheme.titleLarge?.copyWith(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF4A555F),
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(9.r),
        border: Border.all(
          color: const Color(0xFF9BA6A7),
          width: 1,
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 18.h),
        Text(
          l10n.authOtpVerificationTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: (30 / 1.65).sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF061E40),
          ),
        ),
        const SizedBox(height: 8),
        Pinput(
          controller: controller,
          focusNode: focusNode,
          length: 4,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          defaultPinTheme: defaultPinTheme,
          separatorBuilder: (index) =>
              index == 3 ? const SizedBox.shrink() : SizedBox(width: itemSpacing),
          focusedPinTheme: defaultPinTheme.copyWith(
            decoration: defaultPinTheme.decoration?.copyWith(
              border: Border.all(
                color: const Color(0xFF0FAA9A),
                width: 1.5,
              ),
            ),
          ),
          submittedPinTheme: defaultPinTheme,
          onChanged: onOtpChanged,
        ),
        SizedBox(height: 8.h),
        Align(
          child: TextButton(
            onPressed: canResendOtp ? onResendTap : null,
            child: canResendOtp
                ? Text(
                    l10n.authResendOtp,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF5D758F),
                    ),
                  )
                : Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: '${l10n.authResendOtp} '),
                        TextSpan(
                          text: '$otpSecondsRemaining Sec',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF5D758F),
                    ),
                  ),
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
