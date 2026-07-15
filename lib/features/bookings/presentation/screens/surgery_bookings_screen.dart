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
import '../widgets/bookings_list_shimmer_widget.dart';
import '../widgets/empty_booking_widget.dart';
import '../widgets/surgery_booking_card_widget.dart';

class SurgeryBookingsScreen extends StatefulWidget {
  const SurgeryBookingsScreen({super.key});

  @override
  State<SurgeryBookingsScreen> createState() => _SurgeryBookingsScreenState();
}

class _SurgeryBookingsScreenState extends State<SurgeryBookingsScreen> {
  late Future<List<SurgeryBookingListItemModel>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _bookingsFuture = _loadBookings();
  }

  Future<List<SurgeryBookingListItemModel>> _loadBookings() async {
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

  Future<void> _retry() async {
    setState(() {
      _bookingsFuture = _loadBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return FutureBuilder<List<SurgeryBookingListItemModel>>(
      future: _bookingsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const BookingsListShimmerWidget();
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  snapshot.error.toString().replaceFirst('Exception: ', ''),
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium,
                ),
                SizedBox(height: 12.h),
                TextButton(
                  onPressed: _retry,
                  child: Text(l10n.commonRetry),
                ),
              ],
            ),
          );
        }

        final items = snapshot.data ?? const <SurgeryBookingListItemModel>[];
        if (items.isEmpty) {
          return EmptyBookingWidget(
            description: l10n.bookingsSurgeryEmptyDescription,
            buttonText: l10n.surgeryBookingScreenTitle,
            onTap: () => context.pushNamed(AppRoutes.surgery),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.fromLTRB(0, 20.h, 0, 8.h),
          itemCount: items.length,
          separatorBuilder: (_, _) => SizedBox(height: 14.h),
          itemBuilder: (context, index) {
            final item = items[index];
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
        );
      },
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
