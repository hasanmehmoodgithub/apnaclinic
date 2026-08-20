import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../lab_test/domain/use_cases/get_lab_orders_use_case.dart';
import '../../data/mappers/lab_test_booking_list_mapper.dart';
import '../../data/models/lab_test_booking_item_model.dart';
import '../widgets/bookings_list_shimmer_widget.dart';
import '../widgets/empty_booking_widget.dart';
import '../widgets/lab_test_booking_card_widget.dart';

class LabTestBookingsScreen extends StatefulWidget {
  const LabTestBookingsScreen({super.key});

  @override
  State<LabTestBookingsScreen> createState() => _LabTestBookingsScreenState();
}

class _LabTestBookingsScreenState extends State<LabTestBookingsScreen> {
  late final Future<List<LabTestBookingItemModel>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _bookingsFuture = _loadBookings();
  }

  Future<List<LabTestBookingItemModel>> _loadBookings() async {
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.fromLTRB(2.w, 18.h, 2.w, 8.h),
      child: FutureBuilder<List<LabTestBookingItemModel>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return BookingsListShimmerWidget(
              padding: EdgeInsets.zero,
              separatorHeight: 10.h,
            );
          }

          final bookings = snapshot.data ?? const <LabTestBookingItemModel>[];
          if (bookings.isEmpty) {
            return Column(
              children: [
                EmptyBookingWidget(
                  description: l10n.bookingsLabTestEmptyDescription,
                  buttonText: l10n.labTestBookCta,
                  onTap: () => context.pushNamed(AppRoutes.labTest),
                ),
              ],
            );
          }

          return ListView.separated(
            itemCount: bookings.length,
            separatorBuilder: (_, _) => SizedBox(height: 10.h),
            itemBuilder: (context, index) => LabTestBookingCardWidget(
              booking: bookings[index],
            ),
          );
        },
      ),
    );
  }
}
