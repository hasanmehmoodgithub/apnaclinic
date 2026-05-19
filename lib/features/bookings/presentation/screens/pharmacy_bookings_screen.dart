import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../pharmacy/data/mock/pharmacy_mock_api.dart';
import '../../../pharmacy/presentation/widgets/pharmacy_booking_details_body_widget.dart';

class PharmacyBookingsScreen extends StatefulWidget {
  const PharmacyBookingsScreen({super.key});

  @override
  State<PharmacyBookingsScreen> createState() => _PharmacyBookingsScreenState();
}

class _PharmacyBookingsScreenState extends State<PharmacyBookingsScreen> {
  late final Future<List<_PharmacyBookingItem>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _bookingsFuture = _loadBookings();
  }

  Future<List<_PharmacyBookingItem>> _loadBookings() async {
    final response = await PharmacyMockApi().getPharmacyBookingsSuccessResponse();
    final list = (response['bookings'] as List<dynamic>? ?? []);
    return list
        .whereType<Map>()
        .map((raw) => _PharmacyBookingItem.fromJson(Map<String, dynamic>.from(raw)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return FutureBuilder<List<_PharmacyBookingItem>>(
      future: _bookingsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              l10n.pharmacyLoadError,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(color: AppColors.clr667B99),
            ),
          );
        }

        final items = snapshot.data ?? const <_PharmacyBookingItem>[];
        if (items.isEmpty) {
          return Center(
            child: Text(
              l10n.pharmacyEmptyMedicines,
              style: textTheme.bodyMedium?.copyWith(color: AppColors.clr667B99),
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.fromLTRB(0, 20.h, 0, 10.h),
          itemBuilder: (context, index) => _PharmacyBookingCard(
            item: items[index],
            textTheme: textTheme,
            l10n: l10n,
            onViewDetailsTap: () {
              context.pushNamed(
                AppRoutes.pharmacyBookingDetails,
                extra: {
                  'orderNo': items[index].orderNo,
                  'status': items[index].toTimelineStatus().name,
                },
              );
            },
          ),
          separatorBuilder: (_, _) => SizedBox(height: 12.h),
          itemCount: items.length,
        );
      },
    );
  }
}

class _PharmacyBookingCard extends StatelessWidget {
  final _PharmacyBookingItem item;
  final TextTheme textTheme;
  final AppLocalizations l10n;
  final VoidCallback onViewDetailsTap;

  const _PharmacyBookingCard({
    required this.item,
    required this.textTheme,
    required this.l10n,
    required this.onViewDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 118.h,
      child: Row(
        children: [
          Container(
            width: 130.w,
            height: 118.h,
            decoration: BoxDecoration(
              color: AppColors.clrF9F9F9,
              borderRadius: BorderRadius.circular(8.54.r),
            ),
            clipBehavior: Clip.antiAlias,
            child: CachedNetworkImage(
              imageUrl: item.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => AppShimmer(
                width: 130.w,
                height: 118.h,
                borderRadius: 8.54.r,
                shape: ShimmerShape.roundedRectangle,
              ),
              errorWidget: (context, url, error) => Center(
                child: Icon(
                  Icons.medication_rounded,
                  color: AppColors.clr5D758F,
                  size: 52.r,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.clr060,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    item.quantityPrice,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.clr5D758F,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  RichText(
                    text: TextSpan(
                      style: textTheme.bodyMedium?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        const TextSpan(
                          text: '',
                          style: TextStyle(color: Color(0xFF5D758F)),
                        ),
                        TextSpan(
                          text: '${l10n.bookingsTotalLabel}  ',
                          style: const TextStyle(color: AppColors.clr5D758F),
                        ),
                        TextSpan(
                          text: item.total,
                          style: const TextStyle(color: AppColors.clr060),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.status,
                          style: textTheme.bodyMedium?.copyWith(
                            color: item.statusColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: onViewDetailsTap,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppColors.clrBlack,
                            width: 0.26,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(36.78.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 5.h,
                          ),
                          minimumSize: Size(71.w, 24.h),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          l10n.bookingsViewDetailsCta,
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.black,
                            fontSize: 8.6.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PharmacyBookingItem {
  final String orderNo;
  final String title;
  final String imageUrl;
  final String quantityPrice;
  final String total;
  final String status;
  final Color statusColor;

  const _PharmacyBookingItem({
    required this.orderNo,
    required this.title,
    required this.imageUrl,
    required this.quantityPrice,
    required this.total,
    required this.status,
    required this.statusColor,
  });

  factory _PharmacyBookingItem.fromJson(Map<String, dynamic> json) {
    final quantity = (json['quantity'] as num?)?.toInt() ?? 1;
    final unitPrice = (json['unitPrice'] as num?)?.toDouble() ?? 0;
    final total = (json['total'] as num?)?.toDouble() ?? 0;
    final statusRaw = (json['status'] as String? ?? 'in_progress').trim();
    final status = _statusLabel(statusRaw);
    return _PharmacyBookingItem(
      orderNo: (json['orderNo'] as String? ?? '0000').trim(),
      title: (json['title'] as String? ?? '').trim(),
      imageUrl: (json['imageUrl'] as String? ?? '').trim(),
      quantityPrice: '${quantity}x Rs ${unitPrice.toStringAsFixed(0)}/-',
      total: 'Rs ${total.toStringAsFixed(0)}/-',
      status: status,
      statusColor: _statusColor(statusRaw),
    );
  }

  PharmacyBookingTimelineStatus toTimelineStatus() {
    final normalized = status.toLowerCase();
    if (normalized.contains('cancel')) {
      return PharmacyBookingTimelineStatus.cancelled;
    }
    if (normalized.contains('complete')) {
      return PharmacyBookingTimelineStatus.completed;
    }
    if (normalized.contains('ship')) {
      return PharmacyBookingTimelineStatus.shipped;
    }
    if (normalized.contains('ready')) {
      return PharmacyBookingTimelineStatus.readyForDispatch;
    }
    return PharmacyBookingTimelineStatus.confirmed;
  }

  static Color _statusColor(String raw) {
    switch (raw) {
      case 'confirmed':
        return const Color(0xFF0FAA9A);
      case 'ready_to_dispatch':
        return const Color(0xFFFFCC00);
      case 'shipped':
        return const Color(0xFF495AFF);
      case 'completed':
      case 'delivered':
        return const Color(0xFF34C759);
      case 'cancelled':
        return const Color(0xFFFF4F4F);
      default:
        return const Color(0xFFFFCC00);
    }
  }

  static String _statusLabel(String raw) {
    switch (raw) {
      case 'confirmed':
        return 'Confirmed';
      case 'ready_to_dispatch':
        return 'Ready to Dispatch';
      case 'shipped':
        return 'Shipped';
      case 'completed':
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Confirmed';
    }
  }
}
