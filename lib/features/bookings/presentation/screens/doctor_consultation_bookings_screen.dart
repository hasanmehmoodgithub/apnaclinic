import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../cubit/doctor_consultation_bookings_cubit.dart';
import '../cubit/doctor_consultation_bookings_state.dart';
import '../widgets/bookings_list_shimmer_widget.dart';
import '../widgets/doctor_consultation_booking_card_widget.dart';
import '../widgets/empty_booking_widget.dart';

class DoctorConsultationBookingsScreen extends StatelessWidget {
  const DoctorConsultationBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DoctorConsultationBookingsCubit>()..load(),
      child: const _DoctorConsultationBookingsBody(),
    );
  }
}

class _DoctorConsultationBookingsBody extends StatefulWidget {
  const _DoctorConsultationBookingsBody();

  @override
  State<_DoctorConsultationBookingsBody> createState() =>
      _DoctorConsultationBookingsBodyState();
}

class _DoctorConsultationBookingsBodyState
    extends State<_DoctorConsultationBookingsBody> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<DoctorConsultationBookingsCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<DoctorConsultationBookingsCubit,
        DoctorConsultationBookingsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const BookingsListShimmerWidget();
        }

        if (state.hasError && state.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.errorMessage ?? ''),
                SizedBox(height: 12.h),
                TextButton(
                  onPressed: () =>
                      context.read<DoctorConsultationBookingsCubit>().load(),
                  child: Text(l10n.commonRetry),
                ),
              ],
            ),
          );
        }

        if (state.items.isEmpty) {
          return Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: EmptyBookingWidget(
              description: l10n.bookingsDoctorConsultationEmptyDescription,
              buttonText: l10n.onboardingBookConsultationTitle,
              onTap: () => context.pushNamed(AppRoutes.consultation),
            ),
          );
        }

        return ListView.separated(
          controller: _scrollController,
          padding: EdgeInsets.fromLTRB(0, 20.h, 0, 8.h),
          itemBuilder: (context, index) {
            if (index >= state.items.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }
            return DoctorConsultationBookingCardWidget(item: state.items[index]);
          },
          separatorBuilder: (_, index) {
            if (index >= state.items.length - 1) {
              return const SizedBox.shrink();
            }
            return SizedBox(height: 14.h);
          },
          itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
        );
      },
    );
  }
}
