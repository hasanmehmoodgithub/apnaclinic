import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/router/app_routes.dart';
import '../constants/consultation_ui_config.dart';

class DoctorConsultationResultsScreen extends StatefulWidget {
  final String selectedCategory;

  const DoctorConsultationResultsScreen({
    super.key,
    required this.selectedCategory,
  });

  @override
  State<DoctorConsultationResultsScreen> createState() =>
      _DoctorConsultationResultsScreenState();
}

class _DoctorConsultationResultsScreenState
    extends State<DoctorConsultationResultsScreen> {
  final TextEditingController _searchController = TextEditingController();

  static const List<_DoctorItem> _allDoctors = [
    _DoctorItem(
      name: 'Dr. Sumbal Shahid',
      specialty: 'Neurologist',
      experience: '6 years Experience',
      qualification: 'MMBS, FCPS',
      fee: 'Rs. 15,000/-',
      oldFee: 'Rs. 80,000/-',
      partner: 'oladoc',
      imageUrl: '',
    ),
    _DoctorItem(
      name: 'Dr. Kainat Shahid',
      specialty: 'Neurologist',
      experience: '6 years Experience',
      qualification: 'MMBS, FCPS',
      fee: 'Rs. 15,000/-',
      oldFee: 'Rs. 80,000/-',
      partner: 'MedIQ',
      imageUrl: '',
    ),
    _DoctorItem(
      name: 'Dr. Raheel Khan',
      specialty: 'Neurologist',
      experience: '6 years Experience',
      qualification: 'MMBS, FCPS',
      fee: 'Rs. 15,000/-',
      oldFee: 'Rs. 80,000/-',
      partner: 'oladoc',
      imageUrl: '',
    ),
  ];

  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final doctors = _allDoctors.where((doctor) {
      final query = _query.toLowerCase().trim();
      if (query.isEmpty) {
        return true;
      }
      return doctor.name.toLowerCase().contains(query) ||
          doctor.specialty.toLowerCase().contains(query);
    }).toList(growable: false);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ConsultationUiConfig.pageTopGradient,
              ConsultationUiConfig.pageBottomGradient,
            ],
            stops: [0.09, 0.36],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(22.w, 8.h, 22.w, 8.h),
                child: Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.of(context).pop(),
                      child: SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: Center(
                          child: SvgPicture.asset(
                            ConsultationUiConfig.backArrowAsset,
                            width: 24.w,
                            height: 24.h,
                            fit: BoxFit.contain,
                            colorFilter: const ColorFilter.mode(
                              ConsultationUiConfig.primaryText,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        ConsultationUiConfig.screenTitle,
                        textAlign: TextAlign.center,
                        style: textTheme.titleLarge?.copyWith(
                          color: ConsultationUiConfig.primaryText,
                          fontWeight: FontWeight.w700,
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 24.w),
                  ],
                ),
              ),
              SizedBox(
                height: 178.h,
                child: Center(
                  child: SizedBox(
                    width: 240.w,
                    height: 178.h,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Positioned(
                          top: 2.h,
                          child: SvgPicture.asset(
                            ConsultationUiConfig.heroVectorAsset,
                            width: 238.w,
                            height: 172.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          child: Image.asset(
                            ConsultationUiConfig.heroDoctorAsset,
                            width: 188.w,
                            height: 177.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(42.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 16.h),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildSearchField(context)),
                            SizedBox(width: 8.w),
                            _FilterButton(textTheme: textTheme),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        _CategoryCard(
                          category: widget.selectedCategory,
                          textTheme: textTheme,
                        ),
                        SizedBox(height: 12.h),
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: doctors.length,
                            separatorBuilder: (_, __) => SizedBox(height: 12.h),
                            itemBuilder: (context, index) {
                              return _DoctorCard(
                                doctor: doctors[index],
                                textTheme: textTheme,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return SizedBox(
      height: 44.6.h,
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _query = value),
        decoration: InputDecoration(
          hintText: 'Search for Doctor',
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF9E9E9E),
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(12.r),
            child: SvgPicture.asset(
              ConsultationUiConfig.searchIconAsset,
              width: 18.6.w,
              height: 18.6.h,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 12.h),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF9BA6A7), width: 0.3),
            borderRadius: BorderRadius.circular(12.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF9BA6A7), width: 0.3),
            borderRadius: BorderRadius.circular(12.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ConsultationUiConfig.ctaColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final TextTheme textTheme;

  const _FilterButton({required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.6.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF9BA6A7), width: 0.3),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          const Icon(Icons.filter_list_rounded, color: Color(0xFF667B99), size: 16),
          SizedBox(width: 8.w),
          Text(
            'Filter',
            style: textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF667B99),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String category;
  final TextTheme textTheme;

  const _CategoryCard({required this.category, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 61.6.h,
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF9BA6A7), width: 0.3),
        borderRadius: BorderRadius.circular(5.3.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Doctor’s Category',
                style: textTheme.bodySmall?.copyWith(
                  color: ConsultationUiConfig.tertiaryText,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                category,
                style: textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF110844),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            iconAlignment: IconAlignment.end,
            style: TextButton.styleFrom(
              foregroundColor: ConsultationUiConfig.tertiaryText,
              padding: EdgeInsets.zero,
              minimumSize: Size(10.w, 10.h),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            label: Text(
              'Change',
              style: textTheme.bodySmall?.copyWith(
                color: ConsultationUiConfig.tertiaryText,
                fontSize: 12.sp,
              ),
            ),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16.w,
              color: ConsultationUiConfig.tertiaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final _DoctorItem doctor;
  final TextTheme textTheme;

  const _DoctorCard({required this.doctor, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3308619C),
            blurRadius: 59,
            offset: Offset(0, 18),
            spreadRadius: -27,
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(9.r),
            child: SizedBox(
              width: 97.4.w,
              height: 97.4.h,
              child: _DoctorThumb(imageUrl: doctor.imageUrl),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  doctor.name,
                                  style: textTheme.titleMedium?.copyWith(
                                    fontSize: 16.sp,
                                    color: ConsultationUiConfig.primaryText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              _RatingBadge(textTheme: textTheme),
                            ],
                          ),
                          Text(
                            doctor.specialty,
                            style: textTheme.bodyMedium?.copyWith(
                              fontSize: 14.sp,
                              color: ConsultationUiConfig.tertiaryText,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '${doctor.experience}  •  ${doctor.qualification}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              fontSize: 12.sp,
                              color: ConsultationUiConfig.tertiaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 6.w),
                    _PartnerAvatar(partner: doctor.partner, textTheme: textTheme),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fee',
                          style: textTheme.bodySmall?.copyWith(
                            color: ConsultationUiConfig.tertiaryText,
                            fontSize: 12.sp,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              doctor.fee,
                              style: textTheme.bodyMedium?.copyWith(
                                fontSize: 14.sp,
                                color: const Color(0xFF110844),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                doctor.oldFee,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodySmall?.copyWith(
                                  color: const Color(0xFF979797),
                                  fontSize: 12.sp,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ),
                    SizedBox(width: 8.w),
                    SizedBox(
                      height: 34.h,
                      width: 97.w,
                      child: ElevatedButton(
                        onPressed: () => context.pushNamed(
                          AppRoutes.consultationBookDoctor,
                          extra: {
                            'doctorName': doctor.name,
                            'specialty': doctor.specialty,
                            'fee': doctor.fee,
                            'imageUrl': doctor.imageUrl,
                          },
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: ConsultationUiConfig.ctaColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.1.r),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                        ),
                        child: Text(
                          'Book Now',
                          style: textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.9.r),
        border: Border.all(color: const Color(0xFF98E089), width: 1),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '4',
              style: textTheme.bodySmall?.copyWith(
                color: const Color(0xFF98E089),
                fontSize: 8.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: ' / 5',
              style: textTheme.bodySmall?.copyWith(
                color: ConsultationUiConfig.tertiaryText,
                fontSize: 8.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PartnerAvatar extends StatelessWidget {
  final String partner;
  final TextTheme textTheme;

  const _PartnerAvatar({required this.partner, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0x36000000), width: 0.3),
      ),
      child: Text(
        partner,
        style: textTheme.bodySmall?.copyWith(
          color: partner.toLowerCase() == 'oladoc'
              ? const Color(0xFFF39A2E)
              : const Color(0xFF6D49B9),
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _DoctorThumb extends StatelessWidget {
  final String imageUrl;

  const _DoctorThumb({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _placeholder();
    }
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFF2F2F2),
      alignment: Alignment.center,
      child: const Icon(
        Icons.person_outline_rounded,
        color: Color(0xFFB3B3B3),
        size: 38,
      ),
    );
  }
}

class _DoctorItem {
  final String name;
  final String specialty;
  final String experience;
  final String qualification;
  final String fee;
  final String oldFee;
  final String partner;
  final String imageUrl;

  const _DoctorItem({
    required this.name,
    required this.specialty,
    required this.experience,
    required this.qualification,
    required this.fee,
    required this.oldFee,
    required this.partner,
    required this.imageUrl,
  });
}
