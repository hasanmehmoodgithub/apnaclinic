import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../generated/assets.dart';
import '../../../lab_test/presentation/widgets/lab_test_figma_image.dart';
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
  static const List<String> _categoryOptions = [
    'General & Internal Medicine',
    'General Surgery',
    "Children's Health (Pediatrics)",
    "Women's Health",
    'Mental Health & Counseling',
    'Skin, Hair & Aesthetics',
    'Bones, Muscles & Movement',
    'Heart & Lungs',
    'Stomach, Liver & Kidneys',
    'Neurology & Brain',
    'Teeth & Mouth',
  ];

  static const List<_DoctorItem> _allDoctors = [
    _DoctorItem(
      name: 'Dr. Saadiya Akhtar Janjua',
      specialty: 'General Practitioner',
      experience: '2 years Experience',
      qualification: 'MBBS',
      fee: 'Rs. 350/-',
      oldFee: 'Rs. 500/-',
      partner: 'MedIQ',
      rating: '4.5 / 5',
      imageUrl: 'https://static.vecteezy.com/system/resources/previews/046/680/074/non_2x/an-pakistani-female-doctor-on-isolated-transparent-background-png.png',
    ),
    _DoctorItem(
      name: 'Dr. Abdul Hafeez',
      specialty: 'Family Physician',
      experience: '12 years Experience',
      qualification: 'MBBS, DFM',
      fee: 'Rs. 560/-',
      oldFee: 'Rs. 800/-',
      partner: 'MedIQ',
      rating: '4.6 / 5',
      imageUrl: 'https://www.shutterstock.com/image-photo/indian-doctor-stethoscope-around-neck-600nw-1625058334.jpg',
    ),
    _DoctorItem(
      name: 'Dr Sarmad Hafeez',
      specialty: 'General Practitioner',
      experience: '5 years Experience',
      qualification: 'MBBS, RMP',
      fee: 'Rs. 350/-',
      oldFee: 'Rs. 500/-',
      partner: 'MedIQ',
      rating: '4.5 / 5',
      imageUrl:"https://static.vecteezy.com/system/resources/previews/002/853/524/large_2x/handsome-pakistani-doctor-and-stethoscope-looking-confident-with-smile-on-face-pointing-oneself-with-fingers-proud-and-happy-photo.jpg",
    ),
  ];

  String _query = '';
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
  }

  Future<void> _openSelectCategoryDialog() async {
    final category = await showDialog<String>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.28),
      builder: (context) => _SelectCategoriesDialog(
        selectedCategory: _selectedCategory,
        categories: _categoryOptions,
      ),
    );
    if (category == null || category == _selectedCategory) return;
    setState(() => _selectedCategory = category);
  }

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
                            width: 18.w,
                            height: 18.h,
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
                        'Specialist',
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
                    padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 12.h),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildSearchField(context)),
                            SizedBox(width: 8.w),
                            _FilterButton(textTheme: textTheme),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        _CategoryCard(
                          category: _selectedCategory,
                          textTheme: textTheme,
                          onChangeTap: _openSelectCategoryDialog,
                        ),
                        SizedBox(height: 14.h),
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: doctors.length,
                            separatorBuilder: (_, _) => SizedBox(height: 10.h),
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
      height: 48.h,
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _query = value),
        decoration: InputDecoration(
          hintText: 'Search for Doctor',
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF9E9E9E),
            fontWeight: FontWeight.w400,
            fontSize: 13.sp,
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.all(12.r),
            child: SvgPicture.asset(
              ConsultationUiConfig.searchIconAsset,
              width: 18.w,
              height: 18.h,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD9DEE4), width: 1),
            borderRadius: BorderRadius.circular(11.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD9DEE4), width: 1),
            borderRadius: BorderRadius.circular(11.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ConsultationUiConfig.ctaColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(11.r),
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
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD9DEE4), width: 1),
        borderRadius: BorderRadius.circular(11.r),
        color: Colors.white,
      ),
      child: Row(
        children: [
          const Icon(Icons.filter_alt_outlined, color: Color(0xFF96A1AE), size: 16),
          SizedBox(width: 8.w),
          Text(
            'Filter',
            style: textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF667B99),
              fontSize: 13.sp,
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
  final VoidCallback onChangeTap;

  const _CategoryCard({
    required this.category,
    required this.textTheme,
    required this.onChangeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 62.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD9DEE4), width: 1),
        borderRadius: BorderRadius.circular(11.r),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Doctor’s Category',
                style: textTheme.bodySmall?.copyWith(
                  color: ConsultationUiConfig.tertiaryText,
                  fontSize: 12.sp,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                category,
                style: textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF1A2533),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          TextButton.icon(
            onPressed: onChangeTap,
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

class _SelectCategoriesDialog extends StatelessWidget {
  const _SelectCategoriesDialog({
    required this.selectedCategory,
    required this.categories,
  });

  final String selectedCategory;
  final List<String> categories;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 44.h),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Select Categories',
                      style: textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF2A3441),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(14.r),
                    onTap: () => Navigator.of(context).pop(selectedCategory),
                    child: Padding(
                      padding: EdgeInsets.all(2.r),
                      child: Icon(
                        Icons.close_rounded,
                        color: const Color(0xFF7E8898),
                        size: 21.r,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Divider(height: 1, thickness: 1, color: const Color(0xFFF0F1F3)),
              SizedBox(height: 6.h),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: categories.map((category) {
                      final isSelected = category == selectedCategory;
                      return InkWell(
                        onTap: () => Navigator.of(context).pop(category),
                        borderRadius: BorderRadius.circular(7.r),
                        child: Container(
                          height: 42.h,
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFF4F5F7)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(7.r),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  category,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF3B4756),
                                    fontSize: 12.8.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Icon(
                                isSelected
                                    ? Icons.radio_button_checked_rounded
                                    : Icons.radio_button_unchecked_rounded,
                                color: const Color(0xFF5D6777),
                                size: 18.r,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(growable: false),
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

class _DoctorCard extends StatelessWidget {
  final _DoctorItem doctor;
  final TextTheme textTheme;

  const _DoctorCard({required this.doctor, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE8ECF0), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14565C67),
            blurRadius: 8,
            spreadRadius: 0.6,
            offset: Offset.zero,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: SizedBox(
              width: 74.w,
              height: 84.h,
              child: _DoctorThumb(imageUrl: doctor.imageUrl),
            ),
          ),
          SizedBox(width: 10.w),
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
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.titleMedium?.copyWith(
                                    fontSize: 15.sp,
                                    color: ConsultationUiConfig.primaryText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              _RatingBadge(textTheme: textTheme, rating: doctor.rating),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            doctor.specialty,
                            style: textTheme.bodyMedium?.copyWith(
                              fontSize: 13.sp,
                              color: ConsultationUiConfig.tertiaryText,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '${doctor.experience} | ${doctor.qualification}',
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
                    SizedBox(width: 4.w),
                    _PartnerBadge(partner: doctor.partner, textTheme: textTheme),
                  ],
                ),
                SizedBox(height: 8.h),
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
                              fontSize: 11.sp,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            doctor.fee,
                            style: textTheme.bodyMedium?.copyWith(
                              fontSize: 14.sp,
                              height: 1,
                              color: const Color(0xFF1A2533),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            doctor.oldFee,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF979797),
                              fontSize: 14.sp,
                              decoration: TextDecoration.lineThrough,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    SizedBox(
                      height: 40.h,
                      width: 114.w,
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
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                        ),
                        child: Text(
                          'Book Now',
                          style: textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
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
  final String rating;

  const _RatingBadge({required this.textTheme, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5FBEF),
        borderRadius: BorderRadius.circular(3.r),
        border: Border.all(color: const Color(0xFFDAEFCF), width: 1),
      ),
      child: Text(
        rating,
        style: textTheme.bodySmall?.copyWith(
          color: const Color(0xFF87B074),
          fontSize: 9.sp,
          fontWeight: FontWeight.w600,
          height: 1,
        ),
      ),
    );
  }
}

class _PartnerBadge extends StatelessWidget {
  final String partner;
  final TextTheme textTheme;

  const _PartnerBadge({required this.partner, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    final isMediq = partner.trim().toLowerCase() == 'mediq';
    return Container(
      alignment: Alignment.topRight,
      padding: EdgeInsets.only(top: 1.h),
      child: isMediq
          ? LabTestFigmaImage(
              url: Assets.labTestMedIQLogo,
              width: 60.w,
              height: 30.h,
              fit: BoxFit.contain,
            )
          : Text(
              partner,
              style: textTheme.bodySmall?.copyWith(
                color: const Color(0xFF6D49B9),
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
    if (imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFEAF1FA),
      alignment: Alignment.center,
      child: Icon(
        Icons.person_rounded,
        color: const Color(0xFF99A9BC),
        size: 38.r,
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
  final String rating;
  final String imageUrl;

  const _DoctorItem({
    required this.name,
    required this.specialty,
    required this.experience,
    required this.qualification,
    required this.fee,
    required this.oldFee,
    required this.partner,
    required this.rating,
    required this.imageUrl,
  });
}
