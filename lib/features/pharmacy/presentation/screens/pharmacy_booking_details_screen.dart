import 'package:flutter/material.dart';

import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../../bookings/presentation/widgets/bookings_list_shimmer_widget.dart';
import '../../../bookings/presentation/bookings_analytics.dart';
import '../../domain/entities/pharmacy_booking_detail_entity.dart';
import '../../domain/use_cases/get_pharmacy_booking_detail_use_case.dart';
import '../pharmacy_navigation.dart';
import '../widgets/pharmacy_booking_details_body_widget.dart';
import '../widgets/pharmacy_flow_header_widget.dart';

class PharmacyBookingDetailsScreen extends StatefulWidget {
  const PharmacyBookingDetailsScreen({
    super.key,
    required this.orderId,
    this.fallbackOrderNo,
  });

  final String orderId;
  final String? fallbackOrderNo;

  @override
  State<PharmacyBookingDetailsScreen> createState() =>
      _PharmacyBookingDetailsScreenState();
}

class _PharmacyBookingDetailsScreenState
    extends State<PharmacyBookingDetailsScreen> {
  late Future<PharmacyBookingDetailEntity?> _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = _loadDetail();
  }

  Future<PharmacyBookingDetailEntity?> _loadDetail() async {
    final orderId = widget.orderId.trim();
    if (orderId.isEmpty) return null;

    final result = await sl<GetPharmacyBookingDetailUseCase>()(
      GetPharmacyBookingDetailParams(orderId: orderId),
    );
    return result.fold((_) => null, (detail) {
      BookingsAnalytics.logBookingViewed(AnalyticsBookingTypeKeys.pharmacy);
      return detail;
    });
  }

  /// App-bar number (`unified_order_id`), never the public UUID used to fetch.
  String _headerOrderNo(PharmacyBookingDetailEntity? detail) {
    final fromDetail = detail?.orderNo.trim() ?? '';
    if (fromDetail.isNotEmpty && !_looksLikeUuid(fromDetail)) return fromDetail;
    final fallback = widget.fallbackOrderNo?.trim() ?? '';
    if (fallback.isEmpty || _looksLikeUuid(fallback)) return '';
    return fallback;
  }

  bool _looksLikeUuid(String value) {
    return RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    ).hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<PharmacyBookingDetailEntity?>(
      future: _detailFuture,
      builder: (context, snapshot) {
        final detail = snapshot.data;
        final titleOrder = _headerOrderNo(detail);

        return AppScaffoldGradient(
          child: Column(
            children: [
              PharmacyFlowHeaderWidget(
                title: titleOrder.isEmpty
                    ? l10n.pharmacyBookingOrderPrefix
                    : '${l10n.pharmacyBookingOrderPrefix} $titleOrder',
                trailingWidth: 40,
                onBackTap: () => pharmacyPopOrGoHome(context),
              ),
              AppScaffoldGradientPanel(
                child: _buildBody(context, snapshot, detail),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    AsyncSnapshot<PharmacyBookingDetailEntity?> snapshot,
    PharmacyBookingDetailEntity? detail,
  ) {
    final l10n = AppLocalizations.of(context)!;

    if (snapshot.connectionState == ConnectionState.waiting) {
      return BookingsListShimmerWidget(
        cardHeight: 110.h,
        separatorHeight: 12.h,
      );
    }

    if (detail == null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Text(
            l10n.pharmacyLoadError,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return PharmacyBookingDetailsBodyWidget(detail: detail);
  }
}
