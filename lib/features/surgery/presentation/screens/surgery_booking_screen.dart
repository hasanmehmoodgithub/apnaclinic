import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../cubit/surgery_cubit.dart';
import '../cubit/surgery_state.dart';
import '../widgets/city_bottom_sheet.dart';
import '../widgets/surgery_booking_doctor_card_data.dart';
import '../widgets/surgery_booking_doctor_card_widget.dart';
import '../widgets/surgery_booking_filter_button_widget.dart';
import '../widgets/surgery_booking_filter_selection.dart';
import '../widgets/surgery_booking_filter_sheet_widget.dart';
import '../widgets/surgery_booking_location_row_widget.dart';
import '../widgets/surgery_booking_search_field_widget.dart';
import 'surgery_patient_details_screen.dart';

class SurgeryBookingScreen extends StatefulWidget {
  const SurgeryBookingScreen({
    super.key,
    required this.procedureName,
    required this.city,
    required this.cities,
  });

  final String procedureName;
  final String city;
  final List<String> cities;

  @override
  State<SurgeryBookingScreen> createState() => _SurgeryBookingScreenState();
}

class _SurgeryBookingScreenState extends State<SurgeryBookingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedHospitalFilter;
  String? _selectedSpecialtyFilter;
  final List<SurgeryBookingDoctorCardData> _cards = const [
    SurgeryBookingDoctorCardData(
      doctorName: 'Dr. Sumbal Shahid',
      speciality: 'Eye Surgeon',
      experience: '6 years Experience',
      qualifications: 'MMBS, FCPS',
      hospitalName: 'Al Shifa International Hospital',
      procedureName: 'Refractive Lens Exchange',
      price: 'Rs. 65,000/-',
      oldPrice: 'Rs. 100,000/-',
      imageUrl:
          'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&w=800&q=80',
      partnerLogoUrl:
          'https://www.figma.com/api/mcp/asset/5e669d2b-dc77-4e06-86d2-9ead92b99252',
    ),
    SurgeryBookingDoctorCardData(
      doctorName: 'Dr. Ayesha',
      speciality: 'Cornea Specialist',
      experience: '6 years Experience',
      qualifications: 'MMBS, FCPS',
      hospitalName: 'Al Maroof Hospital',
      procedureName: 'Corneal Transplant (Keratoplasty)',
      price: 'Rs. 65,000/-',
      oldPrice: 'Rs. 100,000/-',
      imageUrl:
          'https://images.unsplash.com/photo-1594824476967-48c8b964273f?auto=format&fit=crop&w=800&q=80',
      partnerLogoUrl:
          'https://www.figma.com/api/mcp/asset/5e669d2b-dc77-4e06-86d2-9ead92b99252',
    ),
    SurgeryBookingDoctorCardData(
      doctorName: 'Dr. Raheel Khan',
      speciality: 'Refractive Surgeon',
      experience: '6 years Experience',
      qualifications: 'MMBS, FCPS',
      hospitalName: 'Al Maroof Hospital',
      procedureName: 'Photorefractive keratectomy Surgery',
      price: 'Rs. 50,000/-',
      oldPrice: 'Rs. 80,000/-',
      imageUrl:
          'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?auto=format&fit=crop&w=800&q=80',
      partnerLogoUrl:
          'https://www.figma.com/api/mcp/asset/5e669d2b-dc77-4e06-86d2-9ead92b99252',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppScaffoldGradient(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 18.h),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF061E40),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Surgery Booking',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF061E40),
                      fontWeight: FontWeight.w700,
                      fontSize: 20.sp,
                      height: 1.2,
                    ),
                  ),
                ),
                SizedBox(width: 40.w),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
              ),
              child: ListView(
                padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 16.h),
                children: [
                  Text(
                    widget.procedureName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF061E40),
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  BlocBuilder<SurgeryCubit, SurgeryState>(
                    buildWhen: (prev, curr) =>
                    prev.selectedCity != curr.selectedCity,
                    builder: (context, state) {
                      return SurgeryBookingLocationRowWidget(
                        city: state.selectedCity,
                        onChangeTap: () => showCityPickerSheet(context),
                      );
                    },
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Select for Surgery',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF061E40),
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: SurgeryBookingSearchFieldWidget(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      SurgeryBookingFilterButtonWidget(
                        isActive:
                            _selectedHospitalFilter != null ||
                            _selectedSpecialtyFilter != null,
                        onTap: _showFilterSheet,
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  ..._filteredCards.map(
                    (card) => SurgeryBookingDoctorCardWidget(
                      data: card,
                      onBookNowTap: () => _openPatientDetails(card),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<SurgeryBookingDoctorCardData> get _filteredCards {
    final query = _searchController.text.trim().toLowerCase();
    final searched = _cards.where((card) {
      if (query.isEmpty) return true;
      return card.doctorName.toLowerCase().contains(query) ||
          card.hospitalName.toLowerCase().contains(query) ||
          card.procedureName.toLowerCase().contains(query);
    });

    final hospitalFiltered = searched.where((card) {
      if (_selectedHospitalFilter == null) return true;
      return card.hospitalName == _selectedHospitalFilter;
    });

    final specialtyFiltered = hospitalFiltered.where((card) {
      if (_selectedSpecialtyFilter == null) return true;
      return card.speciality == _selectedSpecialtyFilter;
    });

    return specialtyFiltered.toList();
  }

  void _openPatientDetails(SurgeryBookingDoctorCardData card) {
    final surgeryCubit = context.read<SurgeryCubit>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: surgeryCubit,
          child: SurgeryPatientDetailsScreen(
            doctorName: card.doctorName,
            speciality: card.speciality,
            experience: card.experience,
            qualifications: card.qualifications,
            hospitalName: card.hospitalName,
            procedureName: card.procedureName,
            price: card.price,
            oldPrice: card.oldPrice,
            imageUrl: card.imageUrl,
            partnerLogoUrl: card.partnerLogoUrl,
          ),
        ),
      ),
    );
  }

  Future<void> _showFilterSheet() async {
    final result = await showModalBottomSheet<SurgeryBookingFilterSelection>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.r)),
      builder: (context) {
        return SurgeryBookingFilterSheetWidget(
          hospitals: _cards.map((e) => e.hospitalName).toSet().toList(),
          specialties: _cards.map((e) => e.speciality).toSet().toList(),
          selectedHospital: _selectedHospitalFilter,
          selectedSpecialty: _selectedSpecialtyFilter,
        );
      },
    );

    if (!mounted || result == null) return;
    setState(() {
      _selectedHospitalFilter = result.selectedHospital;
      _selectedSpecialtyFilter = result.selectedSpecialty;
    });
  }
}
