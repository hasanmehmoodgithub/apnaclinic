import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_shell.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => sl<AuthCubit>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _otpFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  String _formatPhoneInput(String input) {
    var digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('0')) {
      digits = digits.substring(1);
    }
    if (digits.startsWith('92') && digits.length > 10) {
      digits = digits.substring(2);
    }
    return '+92$digits';
  }

  String get _otpCode => _otpController.text;

  void _clearOtpInputs() {
    _otpController.clear();
    _otpFocusNode.requestFocus();
  }

  void _handleBackTap(AuthState state) {
    if (!mounted) return;

    if (state.otpRequested) {
      context.read<AuthCubit>().hideOtpSection();
      return;
    }

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }

    context.go(AppRoutes.path(AppRoutes.onboarding));
  }

  Future<void> _submit(AuthState state) async {
    final l10n = AppLocalizations.of(context)!;
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<AuthCubit>();
    final phone = _formatPhoneInput(_phoneController.text.trim());

    if (!state.otpRequested) {
      final success = await cubit.requestOtp(phone);
      if (!mounted || !success) return;
      _clearOtpInputs();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.authOtpSentMessage)));
      return;
    }

    if (_otpCode.length != 4) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.authOtpValidationError)));
      return;
    }

    final success = await cubit.verifyOtp(_otpCode);
    if (!mounted || !success) return;
    context.go(AppRoutes.path(AppRoutes.profileSetup));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return AuthShell(
          onBackTap: () => _handleBackTap(state),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 22, 30, 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.authMobileNumberLabel,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF061E40),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.authLoginSubtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF98A2B3),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneController,
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
                        padding: const EdgeInsets.only(left: 16, right: 6),
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
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 15,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFF9BA6A7),
                          width: 0.9,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFF9BA6A7),
                          width: 0.9,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFE01F26),
                          width: 0.9,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFE01F26),
                          width: 0.9,
                        ),
                      ),
                    ),
                    onChanged: (_) => context.read<AuthCubit>().clearError(),
                    validator: (value) {
                      final digits = (value ?? '').replaceAll(
                        RegExp(r'\D'),
                        '',
                      );
                      final isValidPakMobile = RegExp(r'^3\d{9}$').hasMatch(
                        digits,
                      );
                      if (!isValidPakMobile) {
                        return l10n.authPhoneValidationError;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.authOtpHint,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF98A2B3),
                    ),
                  ),
                  if (!state.otpRequested && state.errorMessage != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      state.errorMessage!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFFE01F26),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  if (state.otpRequested) ...[
                    const SizedBox(height: 18),
                    Text(
                      l10n.authOtpVerificationTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 30 / 1.65,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF061E40),
                      ),
                    ),
                    const SizedBox(height: 8),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        const itemSpacing = 10.0;
                        final boxWidth = (constraints.maxWidth - 30) / 4.5;
                        final defaultPinTheme = PinTheme(
                          width: boxWidth,
                          height: 68,
                          textStyle: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF4A555F),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(
                              color: const Color(0xFF9BA6A7),
                              width: 1,
                            ),
                          ),
                        );

                        return Pinput(
                          controller: _otpController,
                          focusNode: _otpFocusNode,
                          length: 4,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          defaultPinTheme: defaultPinTheme,
                          separatorBuilder: (index) => index == 3
                              ? const SizedBox.shrink()
                              : const SizedBox(width: itemSpacing),
                          focusedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration?.copyWith(
                              border: Border.all(
                                color: const Color(0xFF0FAA9A),
                                width: 1.5,
                              ),
                            ),
                          ),
                          submittedPinTheme: defaultPinTheme,
                          onChanged: (_) =>
                              context.read<AuthCubit>().clearError(),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Align(
                      child: TextButton(
                        onPressed: state.canResendOtp
                            ? () => context.read<AuthCubit>().requestOtp(
                                _formatPhoneInput(_phoneController.text.trim()),
                              )
                            : null,
                        child: state.canResendOtp
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
                                      text: '${state.otpSecondsRemaining} Sec',
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
                    if (state.errorMessage != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        state.errorMessage!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFFE01F26),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                  const Spacer(),
                  AppButton.primary(
                    text: state.otpRequested
                        ? l10n.authProceedCta
                        : l10n.authSendOtpCta,
                    onPressed: state.isLoading ? null : () => _submit(state),
                    isLoading: state.isLoading,
                    backgroundColor: const Color(0xFF0FAA9A),
                    foregroundColor: Colors.white,
                    height: 62,
                    borderRadius: 20,
                    fontSize: 30 / 1.65,
                  ),
                  const SizedBox(height: 20),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: '${l10n.authLegalPrefix} '),
                        TextSpan(
                          text: l10n.authTermsLabel,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: ' ${l10n.authLegalConnector} '),
                        TextSpan(
                          text: l10n.authPrivacyLabel,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF667085),
                      height: 1.65,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
