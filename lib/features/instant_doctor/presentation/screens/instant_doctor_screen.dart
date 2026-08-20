import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:apnaclinic/core/extensions/screen_util_extensions.dart';
import 'package:apnaclinic/core/l10n/app_localizations.dart';
import 'package:apnaclinic/core/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/instant_doctor_provider_entity.dart';
import '../../domain/enums/instant_doctor_otp_action.dart';
import '../cubit/instant_doctor_cubit.dart';
import '../instant_doctor_consultation_args.dart';
import '../models/instant_doctor_flow_outcome.dart';
import '../widgets/instant_doctor_cancel_subscription_dialog.dart';
import '../widgets/instant_doctor_otp_verification_sheet.dart';
import '../widgets/instant_doctor_provider_list_widget.dart';
import '../widgets/instant_doctor_screen_error_listener.dart';
import '../widgets/instant_doctor_subscription_success_dialog.dart';
import '../widgets/instant_doctor_top_header_widget.dart';

class InstantDoctorScreen extends StatefulWidget {
  const InstantDoctorScreen({super.key, this.showBackButton = true, this.onBack});

  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  State<InstantDoctorScreen> createState() => _InstantDoctorScreenState();
}

class _InstantDoctorScreenState extends State<InstantDoctorScreen> {
  static const double _cardOverlap = 56;
  static const double _topBannerFraction = 0.32;
  static const double _panelTopRadius = 35;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bannerHeight = MediaQuery.sizeOf(context).height * _topBannerFraction;
    final panelTop = bannerHeight - _cardOverlap.h;

    return InstantDoctorScreenErrorListener(
      child: ColoredBox(
        color: AppColors.clrF4F6F8,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: bannerHeight,
              child: InstantDoctorTopHeaderWidget(
                title: l10n.instantDoctorTitle,
                showBackButton: widget.showBackButton,
                onBack: widget.onBack,
              ),
            ),
            Positioned(
              top: panelTop,
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(_panelTopRadius.r),
                ),
                child: ColoredBox(
                  color: AppColors.clrWhite,
                  child: InstantDoctorProviderListWidget(
                    onProviderPrimaryTap: _onProviderPrimaryTap,
                    onCancelSubscription: _onCancelSubscription,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InstantDoctorCubit get _cubit => context.read<InstantDoctorCubit>();
  AppLocalizations get _l10n => AppLocalizations.of(context)!;

  Future<void> _onProviderPrimaryTap(
    InstantDoctorProviderEntity provider,
  ) async {
    final outcome = await _cubit.onProviderPrimaryTap(provider);
    if (!mounted) return;

    switch (outcome) {
      case InstantDoctorProviderTapOutcome.consultationOpened:
        await _openConsultation(provider);
        return;
      case InstantDoctorProviderTapOutcome.consultationFailed:
        _showSnackBar(
          _l10n.instantDoctorOpenAppError,
          behavior: SnackBarBehavior.floating,
        );
        return;
      case InstantDoctorProviderTapOutcome.otpFlowStarted:
        await _showOtpSheet(provider);
        if (mounted) _cubit.clearOtpFlow();
        return;
      case InstantDoctorProviderTapOutcome.otpSendFailed:
        _showOtpSendError();
        return;
    }
  }

  Future<void> _onCancelSubscription(
    InstantDoctorProviderEntity provider,
  ) async {
    final confirmed = await showInstantDoctorCancelSubscriptionDialog(context);
    if (!confirmed || !mounted) return;

    final outcome = await _cubit.onCancelSubscriptionConfirmed(provider);
    if (!mounted) return;

    switch (outcome) {
      case InstantDoctorProviderTapOutcome.otpFlowStarted:
        await _showOtpSheet(provider);
        if (mounted) _cubit.clearOtpFlow();
        return;
      case InstantDoctorProviderTapOutcome.otpSendFailed:
        _showOtpSendError();
        return;
      case InstantDoctorProviderTapOutcome.consultationOpened:
      case InstantDoctorProviderTapOutcome.consultationFailed:
        return;
    }
  }

  Future<void> _openConsultation(InstantDoctorProviderEntity provider) async {
    final url = _cubit.consultationUrl(provider);
    if (url == null) {
      _showSnackBar(
        _l10n.instantDoctorOpenAppError,
        behavior: SnackBarBehavior.floating,
      );
      return;
    }

    await _openConsultationUrl(
      url: url,
      title: provider.providerName,
      providerId: provider.providerId,
    );
  }

  Future<void> _openConsultationUrl({
    required String url,
    required String title,
    int? providerId,
  }) async {
    if (providerId != null) {
      _cubit.setOpeningProvider(providerId);
    }

    await context.pushNamed(
      AppRoutes.instantDoctorConsultation,
      extra: InstantDoctorConsultationArgs(
        url: url,
        title: title,
      ),
    );
    if (!mounted) return;

    if (providerId != null) {
      _cubit.clearOpeningProvider();
    }
    await _cubit.loadContent();
  }

  Future<void> _showOtpSheet(InstantDoctorProviderEntity provider) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: AppColors.clrWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: _cubit,
          child: InstantDoctorOtpVerificationSheet(
            provider: provider,
            onVerified: (outcome) => _onOtpVerified(
              sheetContext: sheetContext,
              provider: provider,
              outcome: outcome,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onOtpVerified({
    required BuildContext sheetContext,
    required InstantDoctorProviderEntity provider,
    required InstantDoctorOtpVerifyOutcome outcome,
  }) async {
    if (!sheetContext.mounted) return;

    final otpAction = outcome.action ?? _cubit.state.otpAction;

    if (!outcome.isSuccess) {
      final backendMessage = outcome.errorMessage?.trim();
      if (otpAction == InstantDoctorOtpAction.unsubscribe) {
        sheetContext.pop();
        if (!mounted) return;
        _cubit.clearOtpFlow();
        _showSnackBar(
          (backendMessage != null && backendMessage.isNotEmpty)
              ? backendMessage
              : _l10n.instantDoctorCancelSubscriptionFailed,
        );
        return;
      }

      // Subscribe wrong OTP: keep sheet open and show backend message under pins.
      return;
    }

    sheetContext.pop();
    if (!mounted) return;
    _cubit.clearOtpFlow();

    if (otpAction == InstantDoctorOtpAction.unsubscribe) {
      _showSnackBar(_l10n.instantDoctorCancelSubscriptionSuccess);
      await _cubit.loadContent();
      return;
    }

    await _showSubscribeSuccessDialog(provider, outcome);
  }

  Future<void> _showSubscribeSuccessDialog(
    InstantDoctorProviderEntity provider,
    InstantDoctorOtpVerifyOutcome outcome,
  ) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return InstantDoctorSubscriptionSuccessDialog(
          providerName: provider.providerName,
          onStartConsultation: () {
            dialogContext.pop();
            if (!mounted) return;

            final url =
                outcome.redirectUrl ?? _cubit.consultationUrl(provider);
            if (url == null) {
              _showSnackBar(
                _l10n.instantDoctorOpenAppError,
                behavior: SnackBarBehavior.floating,
              );
              return;
            }

            _openConsultationUrl(
              url: url,
              title: provider.providerName,
              providerId: provider.providerId,
            );
          },
        );
      },
    );
  }

  void _showOtpSendError() {
    final error = _cubit.state.otpErrorMessage;
    if (error != null && error.isNotEmpty) {
      _showSnackBar(error);
    }
  }

  void _showSnackBar(
    String message, {
    SnackBarBehavior behavior = SnackBarBehavior.fixed,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: behavior),
    );
  }
}
