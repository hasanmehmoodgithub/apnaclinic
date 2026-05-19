import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

/// OTP block: visibility + timer/error scoped with [BlocSelector] for minimal rebuilds.
class LoginOtpSection extends StatelessWidget {
  const LoginOtpSection({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onResendTap,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final Future<void> Function() onResendTap;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthCubit, AuthState, bool>(
      selector: (state) => state.otpRequested,
      builder: (context, otpRequested) {
        if (!otpRequested) {
          return const SizedBox.shrink();
        }
        return _LoginOtpSectionBody(
          controller: controller,
          focusNode: focusNode,
          onResendTap: onResendTap,
        );
      },
    );
  }
}

class _LoginOtpSectionBody extends StatelessWidget {
  const _LoginOtpSectionBody({
    required this.controller,
    required this.focusNode,
    required this.onResendTap,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final Future<void> Function() onResendTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 18.h),
        Text(
          l10n.authOtpVerificationTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: (30 / 1.65).sp,
            fontWeight: FontWeight.w700,
            color: AppColors.clr060,
          ),
        ),
        SizedBox(height: 8.h),
        LayoutBuilder(
          builder: (context, constraints) {
            final pinTheme = _otpPinTheme(
              maxWidth: constraints.maxWidth,
              theme: theme,
            );
            final itemSpacing = 10.w;
            return Pinput(
              controller: controller,
              focusNode: focusNode,
              length: 4,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              defaultPinTheme: pinTheme,
              separatorBuilder: (index) => index == 3
                  ? const SizedBox.shrink()
                  : SizedBox(width: itemSpacing),
              focusedPinTheme: pinTheme.copyWith(
                decoration: pinTheme.decoration?.copyWith(
                  border: Border.all(color: AppColors.clr0FAA9A, width: 1.5),
                ),
              ),
              submittedPinTheme: pinTheme,
              onChanged: (_) => context.read<AuthCubit>().clearError(),
            );
          },
        ),
        SizedBox(height: 8.h),
        _LoginOtpResendRow(onResendTap: onResendTap),
        _LoginOtpErrorText(theme: theme),
      ],
    );
  }

  /// Fits 4 OTP boxes within [maxWidth] (Figma 82×68), scaled down on narrow screens.
  static PinTheme _otpPinTheme({
    required double maxWidth,
    required ThemeData theme,
  }) {
    const designPinWidth = 82.0;
    const designPinHeight = 68.0;
    const pinCount = 4;
    const gapCount = 3;
    final gap = 10.w;
    final maxPinWidth = 82.w;
    final available = maxWidth.isFinite && maxWidth > 0 ? maxWidth : maxPinWidth;
    final pinW = ((available - gapCount * gap) / pinCount).clamp(48.0, maxPinWidth);
    final pinH = pinW * (designPinHeight / designPinWidth);

    return PinTheme(
      width: pinW,
      height: pinH,
      textStyle: theme.textTheme.titleLarge?.copyWith(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.clr4A555F,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(9.r),
        border: Border.all(color: AppColors.clr9BA6A7, width: 1),
      ),
    );
  }
}

class _LoginOtpResendRow extends StatelessWidget {
  const _LoginOtpResendRow({required this.onResendTap});

  final Future<void> Function() onResendTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocSelector<AuthCubit, AuthState, (int, bool)>(
      selector: (state) =>
          (state.otpSecondsRemaining, state.canResendOtp),
      builder: (context, values) {
        final (otpSecondsRemaining, canResendOtp) = values;
        return Align(
          child: TextButton(
            onPressed: canResendOtp ? onResendTap : null,
            child: canResendOtp
                ? Text(
                    l10n.authResendOtp,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.clr5D758F,
                    ),
                  )
                : Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: '${l10n.authResendOtp} '),
                        TextSpan(
                          text:
                              '$otpSecondsRemaining ${l10n.authOtpSecondsShort}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.clr5D758F,
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _LoginOtpErrorText extends StatelessWidget {
  const _LoginOtpErrorText({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthCubit, AuthState, String?>(
      selector: (state) => state.errorMessage,
      builder: (context, errorMessage) {
        if (errorMessage == null) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: EdgeInsets.only(top: 6.h),
          child: Text(
            errorMessage,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.clrE01F26,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }
}
