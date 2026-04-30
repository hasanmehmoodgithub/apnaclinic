import 'package:flutter/material.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class DoctorConsultationBookingsScreen extends StatelessWidget {
  const DoctorConsultationBookingsScreen({super.key});

  static const List<_DoctorBookingItem> _items = [
    _DoctorBookingItem(
      doctorName: 'Dr. Sumbal Shahid',
      specialty: 'Orthopaedic',
      experience: '4 years Experience',
      qualification: 'MMBS, FCPS',
      date: '10/09/24',
      time: '10am - 1pm',
      status: 'Confirmed',
      statusTextColor: Color(0xFF0590A0),
      statusBgColor: Color(0xFFDEF8FB),
      fee: 'Rs.30,000/-',
      oldFee: 'Rs. 80,000/-',
      doctorImageUrl:
          'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&w=800&q=80',
    ),
    _DoctorBookingItem(
      doctorName: 'Dr. Kainat Shahid',
      specialty: 'Neurologist',
      experience: '4 years Experience',
      qualification: 'MMBS, FCPS',
      date: '10/09/24',
      time: '10am - 1pm',
      status: 'Canceled',
      statusTextColor: Color(0xFFE01F26),
      statusBgColor: Color(0xFFFBDEDE),
      fee: 'Rs.30,000/-',
      oldFee: 'Rs. 80,000/-',
      doctorImageUrl:
          'https://images.unsplash.com/photo-1594824476967-48c8b964273f?auto=format&fit=crop&w=800&q=80',
    ),
    _DoctorBookingItem(
      doctorName: 'Dr. Kainat Shahid',
      specialty: 'Neurologist',
      experience: '6 years Experience',
      qualification: 'MMBS, FCPS',
      date: '10/09/24',
      time: '10am - 1pm',
      status: 'Canceled',
      statusTextColor: Color(0xFFE01F26),
      statusBgColor: Color(0xFFFBDEDE),
      fee: 'Rs.30,000/-',
      oldFee: 'Rs. 80,000/-',
      doctorImageUrl:
          'https://images.unsplash.com/photo-1594824476967-48c8b964273f?auto=format&fit=crop&w=800&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(0, 20.h, 0, 8.h),
      itemBuilder: (context, index) =>
          _DoctorBookingCard(item: _items[index], textTheme: textTheme),
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemCount: _items.length,
    );
  }
}

class _DoctorBookingCard extends StatelessWidget {
  const _DoctorBookingCard({required this.item, required this.textTheme});

  final _DoctorBookingItem item;
  final TextTheme textTheme;

  static const String _partnerLogoUrl =
      'https://www.figma.com/api/mcp/asset/705ed652-7c25-48fd-916b-375e85a43137';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33053453),
            blurRadius: 64.2,
            offset: Offset(0, 14),
            spreadRadius: -27,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 8.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 93.w,
                height: 129.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.circular(9.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9.r),
                  child: Image.network(
                    item.doctorImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.person_rounded,
                      color: Color(0xFFBFC7CF),
                      size: 40,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.doctorName,
                                      style: textTheme.titleMedium?.copyWith(
                                        color: const Color(0xFF061E40),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      item.specialty,
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: const Color(0xFF667B99),
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _RatingBadge(textTheme: textTheme),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            '${item.experience}  ${item.qualification}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF667B99),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(height: 7.h),
                          Wrap(
                            spacing: 3.w,
                            runSpacing: 3.h,
                            children: [
                              _InfoPill(label: item.date, textTheme: textTheme),
                              _InfoPill(label: item.time, textTheme: textTheme),
                            ],
                          ),
                          SizedBox(height: 7.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(right: 6.w),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                        color: Color(0xFF9BA6A7),
                                        width: 0.3,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Status:',
                                        style: textTheme.bodySmall?.copyWith(
                                          color: const Color(0xFF667B99),
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: item.statusBgColor,
                                          borderRadius: BorderRadius.circular(13.r),
                                        ),
                                        child: Text(
                                          item.status,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.bodySmall?.copyWith(
                                            color: item.statusTextColor,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Fee',
                                      style: textTheme.bodySmall?.copyWith(
                                        color: const Color(0xFF667B99),
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    SizedBox(height: 3.h),
                                    Text(
                                      item.fee,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      item.oldFee,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: const Color(0xFF979797),
                                        fontSize: 12.sp,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    SizedBox(
                      height: 129.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0x36000000),
                                width: 0.305,
                              ),
                            ),
                            child: ClipOval(
                              child: _NetAsset(_partnerLogoUrl, fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(
                            width: 86.w,
                            height: 32.h,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFF9BA6A7),
                                  width: 0.32,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.108.r),
                                ),
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'View details',
                                style: textTheme.bodySmall?.copyWith(
                                  color: const Color(0xFF061E40),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final TextTheme textTheme;

  const _RatingBadge({required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.967.r),
        border: Border.all(color: const Color(0xFF98E089), width: 0.994),
      ),
      child: Text(
        '4 / 5',
        style: textTheme.bodySmall?.copyWith(
          color: const Color(0xFF667B99),
          fontSize: 7.956.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final String label;
  final TextTheme textTheme;

  const _InfoPill({required this.label, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF9BA6A7), width: 0.3),
        borderRadius: BorderRadius.circular(39.988.r),
      ),
      child: Text(
        label,
        style: textTheme.bodySmall?.copyWith(
          color: const Color(0xFF667B99),
          fontSize: 12.sp,
        ),
      ),
    );
  }
}

class _NetAsset extends StatelessWidget {
  const _NetAsset(this.url, {this.fit = BoxFit.contain});

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
    );
  }
}

class _DoctorBookingItem {
  const _DoctorBookingItem({
    required this.doctorName,
    required this.specialty,
    required this.experience,
    required this.qualification,
    required this.date,
    required this.time,
    required this.status,
    required this.statusTextColor,
    required this.statusBgColor,
    required this.fee,
    required this.oldFee,
    required this.doctorImageUrl,
  });

  final String doctorName;
  final String specialty;
  final String experience;
  final String qualification;
  final String date;
  final String time;
  final String status;
  final Color statusTextColor;
  final Color statusBgColor;
  final String fee;
  final String oldFee;
  final String doctorImageUrl;
}
