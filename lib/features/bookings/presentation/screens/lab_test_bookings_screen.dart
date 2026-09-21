import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../lab_test/domain/use_cases/get_lab_orders_use_case.dart';
import '../../../lab_test/presentation/lab_test_analytics.dart';
import '../../data/mappers/lab_test_booking_list_mapper.dart';
import '../../data/models/lab_test_booking_item_model.dart';
import '../constants/bookings_tabs.dart';
import '../widgets/bookings_list_shimmer_widget.dart';
import '../widgets/bookings_refresh_view.dart';
import '../widgets/bookings_tab_visibility_listener.dart';
import '../widgets/empty_booking_widget.dart';
import '../widgets/lab_test_booking_card_widget.dart';

class LabTestBookingsScreen extends StatefulWidget {
  const LabTestBookingsScreen({super.key});

  @override
  State<LabTestBookingsScreen> createState() => _LabTestBookingsScreenState();
}

class _LabTestBookingsScreenState extends State<LabTestBookingsScreen> {
  List<LabTestBookingItemModel> _bookings = const [];
  bool _isLoading = false;
  bool _hasLoaded = false;

  void _tryLoad() {
    if (!mounted || _isLoading) return;
    _load();
  }

  Future<List<LabTestBookingItemModel>> _fetchBookings() async {
    final result = await sl<GetLabOrdersUseCase>()(
      const GetLabOrdersParams(page: 1, limit: 20),
    );

    return result.fold(
      (_) => const <LabTestBookingItemModel>[],
      (page) => page.items
          .map(LabTestBookingListMapper.fromOrder)
          .toList(growable: false),
    );
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    final bookings = await _fetchBookings();
    if (!mounted) return;
    setState(() {
      _bookings = bookings;
      _isLoading = false;
      _hasLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BookingsTabVisibilityListener(
      tabIndex: BookingsTabs.labTest,
      onVisible: _tryLoad,
      child: Padding(
        padding: EdgeInsets.fromLTRB(2.w, 18.h, 2.w, 8.h),
        child: _isLoading || !_hasLoaded
            ? BookingsListShimmerWidget(
                padding: EdgeInsets.zero,
                separatorHeight: 10.h,
              )
            : _bookings.isEmpty
            ? BookingsRefreshView(
                onRefresh: _load,
                expandChild: true,
                child: Column(
                  children: [
                    EmptyBookingWidget(
                      description: l10n.bookingsLabTestEmptyDescription,
                      buttonText: l10n.labTestBookCta,
                      onTap: () => context.pushNamed(
                        AppRoutes.labTest,
                        extra: {
                          LabTestRouteExtraKeys.source:
                              AnalyticsLabSourceKeys.bookings,
                        },
                      ),
                    ),
                  ],
                ),
              )
            : BookingsRefreshView(
                onRefresh: _load,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _bookings.length,
                  separatorBuilder: (_, _) => SizedBox(height: 10.h),
                  itemBuilder: (context, index) =>
                      LabTestBookingCardWidget(booking: _bookings[index]),
                ),
              ),
      ),
    );
  }
}
