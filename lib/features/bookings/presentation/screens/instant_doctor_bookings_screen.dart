import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/session/auth_session_refresh.dart';
import '../../../dashboard/presentation/constants/main_navigation_tabs.dart';
import '../../../dashboard/presentation/cubit/main_navigation_cubit.dart';
import '../../../dashboard/presentation/cubit/main_navigation_state.dart';
import '../constants/bookings_tabs.dart';
import '../cubit/instant_doctor_bookings_cubit.dart';
import '../cubit/instant_doctor_bookings_state.dart';
import '../widgets/bookings_list_shimmer_widget.dart';
import '../widgets/bookings_refresh_view.dart';
import '../widgets/empty_booking_widget.dart';
import '../widgets/instant_doctor_booking_card_widget.dart';

class InstantDoctorBookingsScreen extends StatefulWidget {
  const InstantDoctorBookingsScreen({super.key});

  @override
  State<InstantDoctorBookingsScreen> createState() =>
      _InstantDoctorBookingsScreenState();
}

class _InstantDoctorBookingsScreenState extends State<InstantDoctorBookingsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => sl<InstantDoctorBookingsCubit>(),
      child: const _InstantDoctorBookingsBody(),
    );
  }
}

class _InstantDoctorBookingsBody extends StatefulWidget {
  const _InstantDoctorBookingsBody();

  @override
  State<_InstantDoctorBookingsBody> createState() =>
      _InstantDoctorBookingsBodyState();
}

class _InstantDoctorBookingsBodyState extends State<_InstantDoctorBookingsBody> {
  late final ScrollController _scrollController;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tabs = DefaultTabController.maybeOf(context);
    if (tabs != _tabController) {
      _tabController?.removeListener(_onTabChanged);
      _tabController = tabs;
      _tabController?.addListener(_onTabChanged);
    }
    _tryLoad();
  }

  @override
  void dispose() {
    _tabController?.removeListener(_onTabChanged);
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController?.indexIsChanging ?? false) return;
    _tryLoad();
  }

  bool _shouldLoadBookings() {
    final tabs = _tabController;
    if (tabs != null && tabs.index != BookingsTabs.instantDoctor) {
      return false;
    }
    final nav = context.read<MainNavigationCubit>();
    return nav.state.currentIndex == MainNavigationTabs.bookings;
  }

  void _tryLoad() {
    if (!mounted || !_shouldLoadBookings()) return;
    context.read<InstantDoctorBookingsCubit>().load();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<InstantDoctorBookingsCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Widget child = BlocBuilder<InstantDoctorBookingsCubit, InstantDoctorBookingsState>(
      builder: (context, state) {
        Future<void> onRefresh() =>
            context.read<InstantDoctorBookingsCubit>().load(refresh: true);

        if (state.isLoading || (!state.hasLoaded && !state.hasError)) {
          return const BookingsListShimmerWidget();
        }

        if (state.hasError && state.items.isEmpty) {
          return BookingsRefreshView(
            onRefresh: onRefresh,
            expandChild: true,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.errorMessage ?? ''),
                  SizedBox(height: 12.h),
                  TextButton(
                    onPressed: () =>
                        context.read<InstantDoctorBookingsCubit>().load(),
                    child: Text(l10n.commonRetry),
                  ),
                ],
              ),
            ),
          );
        }

        if (state.items.isEmpty) {
          return BookingsRefreshView(
            onRefresh: onRefresh,
            expandChild: true,
            child: Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: EmptyBookingWidget(
                description: l10n.bookingsInstantDoctorEmptyDescription,
                buttonText: l10n.instantDoctorTitle,
                onTap: () => sl<AuthSessionRefresh>().requestTabIndex(
                  MainNavigationTabs.instantDoctor,
                  instantDoctorSourceScreen:
                      AnalyticsInstantDoctorSourceKeys.bottomTab,
                ),
              ),
            ),
          );
        }

        return BookingsRefreshView(
          onRefresh: onRefresh,
          child: ListView.separated(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
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
              return InstantDoctorBookingCardWidget(item: state.items[index]);
            },
            separatorBuilder: (_, index) {
              if (index >= state.items.length - 1) {
                return const SizedBox.shrink();
              }
              return SizedBox(height: 14.h);
            },
            itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
          ),
        );
      },
    );

    return BlocListener<MainNavigationCubit, MainNavigationState>(
      listenWhen: (previous, current) =>
          previous.currentIndex != current.currentIndex,
      listener: (_, __) => _tryLoad(),
      child: child,
    );
  }
}
