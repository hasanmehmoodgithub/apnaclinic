import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

class PharmacyBookingsScreen extends StatelessWidget {
  const PharmacyBookingsScreen({super.key});

  static const List<_PharmacyBookingItem> _items = [
    _PharmacyBookingItem(
      title: 'O-ZEETINE Capsules 6/25MG',
      quantityPrice: '2x Rs 1900/-',
      total: 'Rs 4040/-',
      status: 'Delivered',
      statusColor: Color(0xFF34C759),
    ),
    _PharmacyBookingItem(
      title: 'O-ZEETINE Capsules 6/25MG',
      quantityPrice: '2x Rs 1900/-',
      total: 'Rs 4040/-',
      status: 'Delivered',
      statusColor: Color(0xFF34C759),
    ),
    _PharmacyBookingItem(
      title: 'O-ZEETINE Capsules 6/25MG',
      quantityPrice: '2x Rs 1900/-',
      total: 'Rs 4040/-',
      status: 'InProgress',
      statusColor: Color(0xFFFFCC00),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(0, 20.h, 0, 10.h),
      itemBuilder: (context, index) => _PharmacyBookingCard(
        item: _items[index],
        textTheme: textTheme,
      ),
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemCount: _items.length,
    );
  }
}

class _PharmacyBookingCard extends StatelessWidget {
  final _PharmacyBookingItem item;
  final TextTheme textTheme;

  const _PharmacyBookingCard({required this.item, required this.textTheme});

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
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(8.54.r),
            ),
            child: Center(
              child: Icon(
                Icons.medication_rounded,
                color: const Color(0xFF5D758F),
                size: 52.r,
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
                      color: const Color(0xFF061E40),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    item.quantityPrice,
                    style: textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF5D758F),
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
                          text: 'Total  ',
                          style: TextStyle(color: Color(0xFF5D758F)),
                        ),
                        TextSpan(
                          text: item.total,
                          style: const TextStyle(color: Color(0xFF061E40)),
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
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFF000000),
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
                          'View Details',
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
  final String title;
  final String quantityPrice;
  final String total;
  final String status;
  final Color statusColor;

  const _PharmacyBookingItem({
    required this.title,
    required this.quantityPrice,
    required this.total,
    required this.status,
    required this.statusColor,
  });
}
