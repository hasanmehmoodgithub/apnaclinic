import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_shell.dart';
import '../widgets/login_legal_text.dart';
import '../widgets/login_otp_section.dart';
import '../widgets/login_phone_input_section.dart';

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

  String _normalizeLocalPhone(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('92') && digits.length > 10) {
      return digits.substring(2);
    }
    if (digits.startsWith('0') && digits.length > 10) {
      return digits.substring(1);
    }
    return digits;
  }

  void _handlePhoneChanged(AuthState state, String value) {
    context.read<AuthCubit>().clearError();

    if (!state.otpRequested) return;
    final currentDraftPhone = _normalizeLocalPhone(value);
    final requestedPhone = _normalizeLocalPhone(state.phoneNumber);

    if (currentDraftPhone == requestedPhone) return;
    context.read<AuthCubit>().hideOtpSection();
    _clearOtpInputs();
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

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return AuthShell(
          onBackTap: () => _handleBackTap(state),
          child: Padding(
            padding: EdgeInsets.fromLTRB(30.w, 22.h, 30.w, 20.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginPhoneInputSection(
                    controller: _phoneController,
                    onChanged: (value) => _handlePhoneChanged(state, value),
                    errorText: !state.otpRequested ? state.errorMessage : null,
                  ),
                  if (state.otpRequested) ...[
                    LoginOtpSection(
                      controller: _otpController,
                      focusNode: _otpFocusNode,
                      otpSecondsRemaining: state.otpSecondsRemaining,
                      canResendOtp: state.canResendOtp,
                      onResendTap: () => context.read<AuthCubit>().requestOtp(
                            _formatPhoneInput(_phoneController.text.trim()),
                          ),
                      onOtpChanged: (_) => context.read<AuthCubit>().clearError(),
                      errorText: state.errorMessage,
                    ),
                  ],
                  const Spacer(),
                  AppButton.primary(
                    text: state.otpRequested
                        ? 'Verify'
                        : l10n.authSendOtpCta,
                    onPressed: state.isLoading ? null : () => _submit(state),
                    isLoading: state.isLoading,
                    backgroundColor: const Color(0xFF0FAA9A),
                    foregroundColor: Colors.white,
                    height: 62.h,
                    borderRadius: 20.r,
                    fontSize: (30 / 1.65).sp,
                  ),
                  SizedBox(height: 20.h),
                  const LoginLegalText(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
