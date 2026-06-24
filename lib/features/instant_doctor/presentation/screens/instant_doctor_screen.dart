import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:apnaclinic/core/enums/state_status.dart';
import 'package:apnaclinic/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/instant_doctor_cubit.dart';
import '../cubit/instant_doctor_state.dart';
import '../widgets/instant_doctor_consultation_info_card_widget.dart';
import '../widgets/instant_doctor_open_app_button_widget.dart';
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
  static const double _cardOverlap = 72;
  static const double _topBannerFraction = 0.35;
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
        if (state.loadingStateStatus == StateStatus.error &&
            state.errorMessage != null &&
            state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        return ColoredBox(
          color: AppColors.clrF4F6F8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: bannerHeight,
                child: InstantDoctorTopHeaderWidget(
                  title: l10n.instantDoctorTitle,
                  showBackButton: widget.showBackButton,
                  onBack: widget.onBack,
                ),
              ),
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      top: -_cardOverlap,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: InstantDoctorConsultationInfoCardWidget(
                        state: state,
                        defaultTitle: l10n.instantDoctorConsultationTitle,
                        defaultPoints: [
                          l10n.instantDoctorPoint1,
                          l10n.instantDoctorPoint2,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InstantDoctorOpenAppButtonWidget(
                label: state.content?.buttonText ?? l10n.instantDoctorOpenAppCta,
                isLoading: state.isOpeningApp,
                isShimmerLoading:
                    state.loadingStateStatus == StateStatus.loading &&
                    !state.isOpeningApp,
                onPressed: () => _openConsultationPage(context, l10n),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openConsultationPage(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    _reloadOnResume = true;
    final opened = await context.read<InstantDoctorCubit>().openConsultationPage();
    if (!opened && context.mounted) {
      _reloadOnResume = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.instantDoctorOpenAppError),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
