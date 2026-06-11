import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../domain/entities/surgery_doctor_entity.dart';
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
import '../widgets/surgery_booking_shimmer_view_widget.dart';
import 'surgery_patient_details_screen.dart';

class SurgeryBookingScreen extends StatefulWidget {
  const SurgeryBookingScreen({
    super.key,
    required this.surgeryId,
    required this.procedureName,
    required this.city,
    required this.cities,
  });

  final String surgeryId;
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

  @override
  void initState() {
    super.initState();
    context.read<SurgeryCubit>().loadSurgeryDoctors(
      surgeryId: widget.surgeryId,
      procedureName: widget.procedureName,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<SurgeryCubit, SurgeryState>(
      listenWhen: (previous, current) =>
          previous.selectedCity != current.selectedCity &&
          previous.selectedCity.isNotEmpty,
      listener: (context, state) {
        context.read<SurgeryCubit>().loadSurgeryDoctors(
          surgeryId: widget.surgeryId,
          procedureName: widget.procedureName,
          refresh: true,
        );
      },
      child: AppScaffoldGradient(
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
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(42.r)),
                ),
                child: BlocBuilder<SurgeryCubit, SurgeryState>(
                  buildWhen: (prev, curr) =>
                      prev.doctorsLoadingStateStatus !=
                          curr.doctorsLoadingStateStatus ||
                      prev.doctorsContent != curr.doctorsContent ||
                      prev.doctorsErrorMessage != curr.doctorsErrorMessage,
                  builder: (context, state) {
                    if (state.doctorsLoadingStateStatus ==
                            StateStatus.loading ||
                        state.doctorsLoadingStateStatus ==
                            StateStatus.refreshing) {
                      return const SurgeryBookingShimmerViewWidget();
                    }

                    if (state.doctorsLoadingStateStatus == StateStatus.error) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.w),
                          child: Text(
                            state.doctorsErrorMessage ??
                                'Unable to load doctors. Please try again.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    final l10n = AppLocalizations.of(context)!;
                    final cards = _mapDoctors(state.doctorsContent.doctors);
                    final filteredCards = _filteredCards(cards);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              SurgeryBookingLocationRowWidget(
                                city: state.selectedCity,
                                onChangeTap: () => showCityPickerSheet(context),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                l10n.surgerySelectForSurgery,
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
                                    onTap: () => _showFilterDialog(state),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: filteredCards.isEmpty
                              ? Center(
                                  child: Text(
                                    l10n.surgeryNoDataFound,
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: const Color(0xFF667B99),
                                    ),
                                  ),
                                )
                              : ListView(
                                  padding: EdgeInsets.fromLTRB(
                                    24.w,
                                    14.h,
                                    24.w,
                                    16.h,
                                  ),
                                  children: [
                                    for (final card in filteredCards)
                                      SurgeryBookingDoctorCardWidget(
                                        data: card,
                                        onBookNowTap: () =>
                                            _openPatientDetails(card),
                                      ),
                                  ],
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<SurgeryBookingDoctorCardData> _mapDoctors(
    List<SurgeryDoctorEntity> doctors,
  ) {
    return doctors
        .map(
          (doctor) => SurgeryBookingDoctorCardData(
            id: doctor.id,
            doctorName: doctor.doctorName,
            speciality: doctor.speciality,
            experience: doctor.experience,
            qualifications: doctor.qualifications,
            hospitalName: doctor.hospitalName,
            procedureName: doctor.procedureName,
            price: doctor.price,
            oldPrice: doctor.oldPrice,
            imageUrl: doctor.imageUrl,
            partnerLogoUrl: doctor.partnerLogoUrl,
          ),
        )
        .toList();
  }

  List<SurgeryBookingDoctorCardData> _filteredCards(
    List<SurgeryBookingDoctorCardData> cards,
  ) {
    final query = _searchController.text.trim().toLowerCase();
    final searched = cards.where((card) {
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
    if (!sl<AppPref>().getLoginStatus()) {
      context.push(AppRoutes.path(AppRoutes.authLogin));
      return;
    }

    final surgeryCubit = context.read<SurgeryCubit>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: surgeryCubit,
          child: SurgeryPatientDetailsScreen(
            doctorId: card.id,
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

  Future<void> _showFilterDialog(SurgeryState state) async {
    final result = await showDialog<SurgeryBookingFilterSelection>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (context) {
        return SurgeryBookingFilterSheetWidget(
          hospitals: state.doctorsContent.hospitals,
          specialties: state.doctorsContent.specialties,
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
