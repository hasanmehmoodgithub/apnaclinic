import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../cubit/doctor_consultation_booking_details_cubit.dart';
import '../cubit/doctor_consultation_booking_details_state.dart';
import '../widgets/doctor_consultation_booking_details_content_widget.dart';
import '../widgets/doctor_consultation_booking_details_shimmer_widget.dart';
import '../widgets/surgery_booking_details_header_widget.dart';

class DoctorConsultationBookingDetailsScreen extends StatefulWidget {
  const DoctorConsultationBookingDetailsScreen({super.key});

  @override
  State<DoctorConsultationBookingDetailsScreen> createState() =>
      _DoctorConsultationBookingDetailsScreenState();
}

class _DoctorConsultationBookingDetailsScreenState
    extends State<DoctorConsultationBookingDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DoctorConsultationBookingDetailsCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFAEE3E3),
              Color(0xFFEAF3F4),
              Color(0xFFF3F5F7),
            ],
            stops: [0.0, 0.28, 0.45],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SurgeryBookingDetailsHeaderWidget(),
              Expanded(
                child: BlocBuilder<
                    DoctorConsultationBookingDetailsCubit,
                    DoctorConsultationBookingDetailsState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const DoctorConsultationBookingDetailsShimmerWidget();
                    }
                    if (state.hasError || state.data == null) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(l10n.bookingsDetailsLoadError),
                            SizedBox(height: 12.h),
                            FilledButton(
                              onPressed: () => context
                                  .read<DoctorConsultationBookingDetailsCubit>()
                                  .load(),
                              child: Text(l10n.commonRetry),
                            ),
                          ],
                        ),
                      );
                    }
                    return DoctorConsultationBookingDetailsContentWidget(
                      data: state.data!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
