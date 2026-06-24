import 'package:apnaclinic/core/enums/state_status.dart';
import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:apnaclinic/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/free_doctor_cubit.dart';
import '../cubit/free_doctor_state.dart';
import '../widgets/free_doctor_consultation_info_card_widget.dart';
import '../widgets/free_doctor_open_app_button_widget.dart';
import '../widgets/free_doctor_top_header_widget.dart';

class FreeDoctorScreen extends StatelessWidget {
  const FreeDoctorScreen({super.key, this.showBackButton = true, this.onBack});

  final bool showBackButton;
  final VoidCallback? onBack;

  static const double _cardOverlap = 72;
  static const double _topBannerFraction = 0.35;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bannerHeight = MediaQuery.sizeOf(context).height * _topBannerFraction;
    return BlocConsumer<FreeDoctorCubit, FreeDoctorState>(
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
                child: FreeDoctorTopHeaderWidget(
                  title: l10n.freeDoctorTitle,
                  showBackButton: showBackButton,
                  onBack: onBack,
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
                      child: FreeDoctorConsultationInfoCardWidget(
                        state: state,
                        defaultTitle: l10n.freeDoctorConsultationTitle,
                        defaultPoints: [
                          l10n.freeDoctorPoint1,
                          l10n.freeDoctorPoint2,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              FreeDoctorOpenAppButtonWidget(
                label: state.content?.buttonText ?? l10n.freeDoctorOpenAppCta,
                isLoading: state.isOpeningApp,
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
    final opened = await context.read<FreeDoctorCubit>().openConsultationPage();
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.freeDoctorOpenAppError),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
