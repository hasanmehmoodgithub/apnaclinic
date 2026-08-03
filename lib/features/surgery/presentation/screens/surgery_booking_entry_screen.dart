import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/state_status.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../cubit/surgery_cubit.dart';
import '../cubit/surgery_state.dart';
import '../surgery_booking_args.dart';
import '../widgets/surgery_booking_shimmer_view_widget.dart';
import 'surgery_booking_screen.dart';

/// Opens surgery doctor list after [SurgeryCubit] finishes content/city bootstrap.
class SurgeryBookingEntryScreen extends StatelessWidget {
  const SurgeryBookingEntryScreen({
    super.key,
    required this.args,
  });

  final SurgeryBookingArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SurgeryCubit, SurgeryState>(
      buildWhen: (previous, current) =>
          previous.loadingStateStatus != current.loadingStateStatus ||
          previous.selectedCity != current.selectedCity ||
          previous.content.cities != current.content.cities,
      builder: (context, state) {
        final isBootstrapping =
            state.loadingStateStatus == StateStatus.idle ||
            state.loadingStateStatus == StateStatus.loading ||
            state.loadingStateStatus == StateStatus.refreshing;

        if (isBootstrapping && state.selectedCity.isEmpty) {
          return AppScaffoldGradient(
            child: Column(
              children: [
                const Expanded(child: SurgeryBookingShimmerViewWidget()),
              ],
            ),
          );
        }

        if (state.loadingStateStatus == StateStatus.error &&
            state.selectedCity.isEmpty) {
          return AppScaffoldGradient(
            child: Center(
              child: Text(state.errorMessage ?? 'Failed to load surgery'),
            ),
          );
        }

        return SurgeryBookingScreen(
          key: ValueKey('surgery-booking-${args.surgeryId}'),
          surgeryId: args.surgeryId,
          procedureName: args.procedureName,
          city: state.selectedCity,
          cities: state.content.cities,
        );
      },
    );
  }
}
