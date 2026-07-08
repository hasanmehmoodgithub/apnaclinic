import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:apnaclinic/core/enums/state_status.dart';
import 'package:apnaclinic/core/extensions/screen_util_extensions.dart';
import 'package:apnaclinic/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/instant_doctor_product_entity.dart';
import '../../domain/entities/instant_doctor_provider_entity.dart';
import '../cubit/instant_doctor_cubit.dart';
import '../cubit/instant_doctor_state.dart';
import '../widgets/instant_doctor_cancel_subscription_dialog.dart';
import '../widgets/instant_doctor_providers_list_widget.dart';
import '../widgets/instant_doctor_subscription_failure_dialog.dart';
import '../widgets/instant_doctor_subscription_otp_sheet.dart';
import '../widgets/instant_doctor_subscription_success_dialog.dart';
import '../widgets/instant_doctor_top_header_widget.dart';

class InstantDoctorScreen extends StatefulWidget {
  const InstantDoctorScreen({super.key, this.showBackButton = true, this.onBack});

  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  State<InstantDoctorScreen> createState() => _InstantDoctorScreenState();
}

class _InstantDoctorScreenState extends State<InstantDoctorScreen>
    with WidgetsBindingObserver {
  static const double _cardOverlap = 56;
  static const double _topBannerFraction = 0.32;
  static const double _panelTopRadius =35;
  bool _reloadOnResume = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);


  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _reloadOnResume) {
      _reloadOnResume = false;
      context.read<InstantDoctorCubit>().loadContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bannerHeight = MediaQuery.sizeOf(context).height * _topBannerFraction;

    return BlocConsumer<InstantDoctorCubit, InstantDoctorState>(
      listener: (context, state) {
        final errorMessage = state.errorMessage;
        if (state.loadingStateStatus == StateStatus.error &&
            errorMessage != null &&
            errorMessage.isNotEmpty) {
          _showSnackBar(errorMessage);
        }
      },
      builder: (context, state) {
        final panelTop = bannerHeight - _cardOverlap.h;

        return ColoredBox(
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
                    child: InstantDoctorProvidersListWidget(
                      state: state,
                      onProviderAction: _onProviderAction,
                      onCancelSubscription: _onCancelSubscription,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  InstantDoctorCubit get _cubit => context.read<InstantDoctorCubit>();
  AppLocalizations get _l10n => AppLocalizations.of(context)!;

  Future<void> _onProviderAction(InstantDoctorProviderEntity provider) async {
    if (provider.isSubscribed) {
      await _openProviderPage(provider);
      return;
    }

    final sent = await _cubit.startSubscription(provider);
    if (!mounted) return;

    if (!sent) {
      final error = _cubit.state.otpErrorMessage;
      if (error != null && error.isNotEmpty) {
        _showSnackBar(error);
      }
      return;
    }

    await _showOtpSheet(provider);
    if (mounted) {
      _cubit.clearOtpFlow();
    }
  }

  Future<void> _onCancelSubscription(InstantDoctorProviderEntity provider) async {
    final confirmed = await showInstantDoctorCancelSubscriptionDialog(
      context,
      providerName: provider.providerName,
    );
    if (!confirmed || !mounted) return;

    final success = await _cubit.cancelSubscription(provider);
    if (!mounted) return;

    if (success) {
      await _cubit.loadContent();
      if (!mounted) return;
      _showSnackBar(_l10n.instantDoctorCancelSubscriptionSuccess);
      return;
    }

    _showSnackBar(_l10n.instantDoctorCancelSubscriptionFailed);
  }

  Future<void> _showOtpSheet(InstantDoctorProviderEntity provider) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.clrWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: _cubit,
          child: InstantDoctorSubscriptionOtpSheet(
            provider: provider,
            onVerified: (success) async {
              if (!sheetContext.mounted) return;
              Navigator.of(sheetContext).pop();
              if (!mounted) return;

              _cubit.clearOtpFlow();
              if (success) {
                await _showSubscriptionSuccessDialog(provider);
              } else {
                await _showSubscriptionFailureDialog();
              }
            },
          ),
        );
      },
    );
  }

  Future<void> _showSubscriptionSuccessDialog(
    InstantDoctorProviderEntity provider,
  ) async {
    await _cubit.loadContent();
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return InstantDoctorSubscriptionSuccessDialog(
          providerName: provider.providerName,
          onStartConsultation: () {
            dialogContext.pop();
            _openProviderPage(provider);
          },
        );
      },
    );
  }

  Future<void> _showSubscriptionFailureDialog() async {
    await showDialog<void>(
      context: context,
      builder: (_) => const InstantDoctorSubscriptionFailureDialog(),
    );
  }

  Future<void> _openProviderPage(InstantDoctorProviderEntity provider) async {
    _reloadOnResume = true;
    final opened = await _cubit.openProviderPage(provider);
    if (!opened && mounted) {
      _reloadOnResume = false;
      _showSnackBar(
        _l10n.instantDoctorOpenAppError,
        behavior: SnackBarBehavior.floating,
      );
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
