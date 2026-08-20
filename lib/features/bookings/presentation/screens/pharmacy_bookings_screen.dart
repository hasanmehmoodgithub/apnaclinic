import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../pharmacy/domain/entities/pharmacy_booking_entity.dart';
import '../../../pharmacy/domain/use_cases/get_pharmacy_bookings_use_case.dart';
import '../widgets/bookings_list_shimmer_widget.dart';
import '../widgets/empty_booking_widget.dart';

class PharmacyBookingsScreen extends StatefulWidget {
  const PharmacyBookingsScreen({super.key});

  @override
  State<PharmacyBookingsScreen> createState() => _PharmacyBookingsScreenState();
}

class _PharmacyBookingsScreenState extends State<PharmacyBookingsScreen> {
  late final Future<List<PharmacyBookingEntity>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _bookingsFuture = _loadBookings();
  }

  Future<List<PharmacyBookingEntity>> _loadBookings() async {
    final result = await sl<GetPharmacyBookingsUseCase>()(
      const GetPharmacyBookingsParams(page: 1, limit: 20),
    );
    return result.fold(
      (_) => const <PharmacyBookingEntity>[],
      (page) => page.items,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return FutureBuilder<List<PharmacyBookingEntity>>(
      future: _bookingsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return BookingsListShimmerWidget(
            cardHeight: 118.h,
            separatorHeight: 12.h,
          );
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

        final items = snapshot.data ?? const <PharmacyBookingEntity>[];
        if (items.isEmpty) {
          return Column(
            children: [
              EmptyBookingWidget(
                description: l10n.pharmacyEmptyMedicines,
                buttonText: l10n.pharmacyScreenTitle,
                onTap: () => context.pushNamed(AppRoutes.pharmacyMain),
              ),
            ],
          );
        }

        return ListView.separated(
          padding: EdgeInsets.fromLTRB(0, 20.h, 0, 10.h),
          itemBuilder: (context, index) => _PharmacyBookingCard(
            item: items[index],
            textTheme: textTheme,
            l10n: l10n,
            onViewDetailsTap: () {
              final orderId = items[index].orderId.trim();
              if (orderId.isEmpty) return;
              context.pushNamed(
                AppRoutes.pharmacyBookingDetails,
                extra: {
                  'orderId': orderId,
                  'orderNo': items[index].orderNo,
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
  const _PharmacyBookingCard({
    required this.item,
    required this.textTheme,
    required this.l10n,
    required this.onViewDetailsTap,
  });

  final PharmacyBookingEntity item;
  final TextTheme textTheme;
  final AppLocalizations l10n;
  final VoidCallback onViewDetailsTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onViewDetailsTap,
        borderRadius: BorderRadius.circular(8.54.r),
        child: SizedBox(
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
                        item.productName,
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
                        item.quantityPriceLabel,
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
                            TextSpan(
                              text: '${l10n.bookingsTotalLabel}  ',
                              style: const TextStyle(color: AppColors.clr5D758F),
                            ),
                            TextSpan(
                              text: item.totalLabel,
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
                              _statusLabel(item.status),
                              style: textTheme.bodyMedium?.copyWith(
                                color: _statusColor(item.status),
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
        ),
      ),
    );
  }
}

Color _statusColor(String raw) {
  final key = raw.trim().toUpperCase().replaceAll(RegExp(r'[\s\-]+'), '_');
  switch (key) {
    case 'ACCEPTED':
    case 'CONFIRMED':
    case 'COMPLETED':
    case 'DELIVERED':
      return const Color(0xFF34C759);
    case 'FAILED':
    case 'PAYMENT_FAILED':
    case 'CANCELLED':
    case 'CANCELED':
    case 'REJECTED':
      return const Color(0xFFFF4F4F);
    case 'SHIPPED':
    case 'DISPATCHED':
      return const Color(0xFF495AFF);
    case 'READY_TO_DISPATCH':
    case 'READY_FOR_DISPATCH':
    case 'PENDING':
    case 'CONFIRMATION_PENDING':
    case 'ORDER_VERIFICATION':
      return const Color(0xFFFFCC00);
    default:
      return const Color(0xFFFFCC00);
  }
}

String _statusLabel(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return 'Pending';

  final key = trimmed.toUpperCase().replaceAll(RegExp(r'[\s\-]+'), '_');
  switch (key) {
    case 'PENDING':
      return 'Pending';
    case 'FAILED':
    case 'PAYMENT_FAILED':
      return 'Failed';
    case 'ACCEPTED':
      return 'Accepted';
    case 'CONFIRMED':
      return 'Confirmed';
    case 'CONFIRMATION_PENDING':
      return 'Confirmation Pending';
    case 'ORDER_VERIFICATION':
      return 'Order Verification';
    case 'READY_TO_DISPATCH':
    case 'READY_FOR_DISPATCH':
      return 'Ready to Dispatch';
    case 'SHIPPED':
    case 'DISPATCHED':
      return 'Shipped';
    case 'COMPLETED':
    case 'DELIVERED':
      return 'Delivered';
    case 'CANCELLED':
    case 'CANCELED':
      return 'Cancelled';
    default:
      // API may already send display labels like "Confirmed" / "Failed".
      return trimmed;
  }
}
