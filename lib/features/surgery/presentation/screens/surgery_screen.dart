import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../cubit/surgery_cubit.dart';
import '../cubit/surgery_state.dart';
import '../surgery_analytics.dart';
import '../widgets/surgery_content_view_widget.dart';
import '../widgets/surgery_shimmer_view_widget.dart';

class SurgeryScreen extends StatefulWidget {
  const SurgeryScreen({
    super.key,
    this.source = AnalyticsSurgerySourceKeys.home,
  });

  final String source;

  @override
  State<SurgeryScreen> createState() => _SurgeryScreenState();
}

class _SurgeryScreenState extends State<SurgeryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      SurgeryAnalytics.logModule(widget.source);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return BlocBuilder<SurgeryCubit, SurgeryState>(
      builder: (context, state) {
        return AppScaffoldGradient(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 18.h),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.clr060,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        l10n.surgeryScreenTitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: AppColors.clr060,
                          fontWeight: FontWeight.w700,
                          fontSize: 20.sp,
                          height: 1.2,
                        ),
                      ),
                    ),
                    SizedBox(width: 40.w),
                  ],
                ),
              ),
              AppScaffoldGradientPanel(
                child: _buildBody(context, state),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, SurgeryState state) {
    if (state.loadingStateStatus == StateStatus.loading) {
      return const SurgeryShimmerViewWidget();
    }

    if (state.loadingStateStatus == StateStatus.error) {
      return Center(
        child: Text(
          state.errorMessage ?? AppStrings.genericErrorMessage,
          textAlign: TextAlign.center,
        ),
      );
    }

    return SurgeryContentViewWidget(
      state: state,
      isRefreshing: state.loadingStateStatus == StateStatus.refreshing,
    );
  }
}


