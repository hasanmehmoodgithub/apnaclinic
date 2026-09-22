import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../surgery/domain/use_cases/get_surgery_leads_use_case.dart';
import '../../data/mappers/surgery_booking_list_mapper.dart';
import '../../data/models/surgery_booking_list_item_model.dart';
import '../../data/models/surgery_details_item.dart';
import '../bookings_analytics.dart';
import '../constants/bookings_tabs.dart';
import '../widgets/bookings_list_shimmer_widget.dart';
import '../widgets/bookings_refresh_view.dart';
import '../widgets/bookings_tab_visibility_listener.dart';
import '../widgets/empty_booking_widget.dart';
import '../widgets/surgery_booking_card_widget.dart';

class SurgeryBookingsScreen extends StatefulWidget {
  const SurgeryBookingsScreen({super.key});

  @override
  State<SurgeryBookingsScreen> createState() => _SurgeryBookingsScreenState();
}

class _SurgeryBookingsScreenState extends State<SurgeryBookingsScreen> {
  List<SurgeryBookingListItemModel> _items = const [];
  Object? _error;
  bool _isLoading = false;
  bool _hasLoaded = false;

  void _tryLoad() {
    if (!mounted) return;
    BookingsAnalytics.logMyBookingSurgery();
    if (_isLoading) return;
    _load(refresh: true);
  }

  Future<List<SurgeryBookingListItemModel>> _fetchBookings() async {
    final result = await sl<GetSurgeryLeadsUseCase>()(
      const GetSurgeryLeadsParams(page: 1, limit: 20),
    );
    return result.fold(
      (error) => throw Exception(error),
      (page) => page.items
          .map(SurgeryBookingListMapper.fromLead)
          .toList(growable: false),
    );
  }

  Future<void> _load({bool refresh = false}) async {
    setState(() {
      _isLoading = true;
      if (!refresh) _error = null;
    });
    try {
      final items = await _fetchBookings();
      if (!mounted) return;
      setState(() {
        _items = items;
        _error = null;
        _isLoading = false;
        _hasLoaded = true;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _isLoading = false;
        _hasLoaded = true;
        if (!refresh) _items = const [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    Widget body;
    if (_isLoading || !_hasLoaded) {
      body = const BookingsListShimmerWidget();
    } else if (_error != null && _items.isEmpty) {
      body = BookingsRefreshView(
        onRefresh: () => _load(refresh: true),
        expandChild: true,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _error.toString().replaceFirst('Exception: ', ''),
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),
              SizedBox(height: 12.h),
              TextButton(
                onPressed: () => _load(),
                child: Text(l10n.commonRetry),
              ),
            ],
          ),
        ),
      );
    } else if (_items.isEmpty) {
      body = BookingsRefreshView(
        onRefresh: () => _load(refresh: true),
        expandChild: true,
        child: EmptyBookingWidget(
          description: l10n.bookingsSurgeryEmptyDescription,
          buttonText: l10n.surgeryBookingScreenTitle,
          onTap: () => context.pushNamed(AppRoutes.surgery),
        ),
      );
    } else {
      body = BookingsRefreshView(
        onRefresh: () => _load(refresh: true),
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(0, 20.h, 0, 8.h),
          itemCount: _items.length,
          separatorBuilder: (_, _) => SizedBox(height: 14.h),
          itemBuilder: (context, index) {
            final item = _items[index];
            final details = item.toDetailsItem();
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _openDetails(context, details, item.initialStatus),
              child: SurgeryBookingCardWidget(
                item: details,
                statusLabel: details.status,
                onViewDetails: () =>
                    _openDetails(context, details, item.initialStatus),
              ),
            );
          },
        ),
      );
    }

    return BookingsTabVisibilityListener(
      tabIndex: BookingsTabs.surgery,
      onVisible: _tryLoad,
      child: body,
    );
  }

  void _openDetails(
    BuildContext context,
    SurgeryDetailsItem details,
    SurgeryBookingStatus initialStatus,
  ) {
    context.pushNamed(
      AppRoutes.surgeryBookingDetails,
      extra: SurgeryBookingDetailsArgs(
        leadId: details.leadId,
        item: details,
        initialStatus: initialStatus,
      ),
    );
  }
}
