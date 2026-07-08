import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/instant_doctor_provider_entity.dart';
import '../cubit/instant_doctor_cubit.dart';
import '../cubit/instant_doctor_state.dart';
import 'instant_doctor_provider_summary_card.dart';

class InstantDoctorSubscriptionOtpSheet extends StatefulWidget {
  const InstantDoctorSubscriptionOtpSheet({
    super.key,
    required this.provider,
    required this.onVerified,
  });

  final InstantDoctorProviderEntity provider;
  final Future<void> Function(bool success) onVerified;

  @override
  State<InstantDoctorSubscriptionOtpSheet> createState() =>
      _InstantDoctorSubscriptionOtpSheetState();
}

class _InstantDoctorSubscriptionOtpSheetState
    extends State<InstantDoctorSubscriptionOtpSheet> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  String _otpValue = '';

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final itemSpacing = 10.w;
    final defaultPinTheme = PinTheme(
      width: 72.w,
      height: 64.h,
      textStyle: AppTextStyles.loginOtpDigit,
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.clrD6DCE2),
      ),
    );

    return BlocBuilder<InstantDoctorCubit, InstantDoctorState>(
      builder: (context, state) {
        final isVerifying = state.verifyOtpStatus == StateStatus.loading;
        final canContinue = _otpValue.length == 4 && !isVerifying;

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 44.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.clrD6DCE2,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
                Text(
                  l10n.authOtpVerificationTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.clr060,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.h),
                InstantDoctorProviderSummaryCard(provider: widget.provider),
                SizedBox(height: 16.h),
                Text(
                  l10n.instantDoctorOtpInstruction,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.clr6C7C92,
                    fontSize: 14.sp,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 18.h),
                Pinput(
                  controller: _otpController,
                  focusNode: _otpFocusNode,
                  length: 4,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  defaultPinTheme: defaultPinTheme,
                  separatorBuilder: (index) => index == 3
                      ? const SizedBox.shrink()
                      : SizedBox(width: itemSpacing),
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration?.copyWith(
                      border: Border.all(color: AppColors.clr0FAA9A, width: 1.5),
                    ),
                  ),
                  onChanged: (value) {
                    context.read<InstantDoctorCubit>().clearOtpError();
                    setState(() => _otpValue = value);
                  },
                ),
                SizedBox(height: 8.h),
                Align(
                  child: TextButton(
                    onPressed: state.canResendOtp && !isVerifying
                        ? () => context
                            .read<InstantDoctorCubit>()
                            .resendSubscriptionOtp()
                        : null,
                    child: state.canResendOtp
                        ? Text(
                            l10n.authResendOtp,
                            style: AppTextStyles.loginResend,
                          )
                        : Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: '${l10n.authResendOtp} '),
                                TextSpan(
                                  text:
                                      '${state.otpSecondsRemaining} ${l10n.authOtpSecondsShort}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            style: AppTextStyles.loginResend,
                          ),
                  ),
                ),
                if (state.otpErrorMessage != null &&
                    state.otpErrorMessage!.isNotEmpty) ...[
                  Text(
                    state.otpErrorMessage!,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.loginError,
                  ),
                  SizedBox(height: 8.h),
                ],
                AppButton.primary(
                  text: l10n.commonContinue,
                  isLoading: isVerifying,
                  onPressed: canContinue ? () => _verifyOtp(context) : null,
                  width: double.infinity,
                  height: 52.h,
                  borderRadius: 12.r,
                  elevation: 0,
                  backgroundColor: canContinue
                      ? AppColors.clr0FAA9A
                      : AppColors.clrD6DCE2,
                  foregroundColor:
                      canContinue ? AppColors.clrWhite : AppColors.clr6C7C92,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _verifyOtp(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    if (_otpValue.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.authOtpValidationError)),
      );
      return;
    }

    final success = await context
        .read<InstantDoctorCubit>()
        .verifySubscriptionOtp(_otpValue);
    if (!context.mounted) return;
    await widget.onVerified(success);
  }
}
