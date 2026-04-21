import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../cubit/surgery_cubit.dart';
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
  late String _selectedCity;
  String? _selectedHospitalFilter;
  String? _selectedSpecialtyFilter;
  final List<_SurgeryDoctorCardData> _cards = const [
    _SurgeryDoctorCardData(
      doctorName: 'Dr. Sumbal Shahid',
      speciality: 'Eye Surgeon',
      experience: '6 years Experience',
      qualifications: 'MMBS, FCPS',
      hospitalName: 'Al Shifa International Hospital',
      procedureName: 'Refractive Lens Exchange',
      price: 'Rs. 65,000/-',
      oldPrice: 'Rs. 100,000/-',
      imageUrl:
          'https://www.figma.com/api/mcp/asset/ffc43bb2-89d9-4625-9d3a-8181a8770661',
      partnerLogoUrl:
          'https://www.figma.com/api/mcp/asset/5e669d2b-dc77-4e06-86d2-9ead92b99252',
    ),
    _SurgeryDoctorCardData(
      doctorName: 'Dr. Ayesha',
      speciality: 'Cornea Specialist',
      experience: '6 years Experience',
      qualifications: 'MMBS, FCPS',
      hospitalName: 'Al Maroof Hospital',
      procedureName: 'Corneal Transplant (Keratoplasty)',
      price: 'Rs. 65,000/-',
      oldPrice: 'Rs. 100,000/-',
      imageUrl:
          'https://www.figma.com/api/mcp/asset/53a7b334-8ba8-496f-93bb-8e8d6774aacd',
      partnerLogoUrl:
          'https://www.figma.com/api/mcp/asset/5e669d2b-dc77-4e06-86d2-9ead92b99252',
    ),
    _SurgeryDoctorCardData(
      doctorName: 'Dr. Raheel Khan',
      speciality: 'Refractive Surgeon',
      experience: '6 years Experience',
      qualifications: 'MMBS, FCPS',
      hospitalName: 'Al Maroof Hospital',
      procedureName: 'Photorefractive keratectomy Surgery',
      price: 'Rs. 50,000/-',
      oldPrice: 'Rs. 80,000/-',
      imageUrl:
          'https://www.figma.com/api/mcp/asset/b58142b3-b9db-44d0-87b2-6d84da0d6968',
      partnerLogoUrl:
          'https://www.figma.com/api/mcp/asset/5e669d2b-dc77-4e06-86d2-9ead92b99252',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedCity = widget.city;
  }

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
                  onPressed: () => Navigator.of(context).maybePop(),
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
                  _LocationRow(
                    city: _selectedCity,
                    onChangeTap: _showCityBottomSheet,
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
                        child: _SearchField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      _FilterButton(
                        isActive:
                            _selectedHospitalFilter != null ||
                            _selectedSpecialtyFilter != null,
                        onTap: _showFilterSheet,
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  ..._filteredCards.map(
                    (card) => _DoctorCard(
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

  List<_SurgeryDoctorCardData> get _filteredCards {
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

  Future<void> _showCityBottomSheet() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 18.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCACACA),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  'Select a city',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF061E40),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10.h),
                ...widget.cities.map(
                  (city) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(city),
                    trailing: Icon(
                      city == _selectedCity
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_off_rounded,
                      color: const Color(0xFF5D758F),
                    ),
                    onTap: () => Navigator.of(context).pop(city),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || selected == null) return;
    setState(() => _selectedCity = selected);
  }

  void _openPatientDetails(_SurgeryDoctorCardData card) {
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
    final result = await showModalBottomSheet<_FilterSelection>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.r)),
      builder: (context) {
        return _FilterSheet(
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

class _LocationRow extends StatelessWidget {
  const _LocationRow({required this.city, required this.onChangeTap});

  final String city;
  final VoidCallback onChangeTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: const Color(0xFF9BA6A7), width: 0.3),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: const Color(0xFF667B99),
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  city,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: const Color(0xFF110844),
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onChangeTap,
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
              child: Row(
                children: [
                  Text(
                    'Change',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF667B99),
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 14.r,
                    color: const Color(0xFF667B99),
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

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.5.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF9BA6A7), width: 0.3),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search name..',
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF9E9E9E),
            fontWeight: FontWeight.w500,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 11.w,
            vertical: 15.h,
          ),
          suffixIcon: Icon(
            Icons.search_rounded,
            size: 18.r,
            color: const Color(0xFF5D758F),
          ),
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.onTap, required this.isActive});

  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 44.5.h,
        width: 72.w,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFEFFCF9) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isActive ? const Color(0xFF0FAA9A) : const Color(0xFF9BA6A7),
            width: 0.3,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 11.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.filter_list_outlined,
              size: 14.r,
              color: const Color(0xFF667B99),
            ),
            SizedBox(width: 6.w),
            Text(
              'Filter',
              style: theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF667B99),
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({
    required this.hospitals,
    required this.specialties,
    required this.selectedHospital,
    required this.selectedSpecialty,
  });

  final List<String> hospitals;
  final List<String> specialties;
  final String? selectedHospital;
  final String? selectedSpecialty;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  String? selectedHospital;
  String? selectedSpecialty;

  @override
  void initState() {
    super.initState();
    selectedHospital = widget.selectedHospital;
    selectedSpecialty = widget.selectedSpecialty;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFCACACA),
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Filter',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 14.h),
            _FilterRow(
              label: selectedHospital ?? 'Hospital',
              onTap: () async {
                final selected = await _showSelectionSheet(
                  title: 'Hospital',
                  options: widget.hospitals,
                  selected: selectedHospital,
                );
                if (!mounted || selected == null) return;
                setState(() => selectedHospital = selected);
              },
            ),
            SizedBox(height: 12.h),
            _FilterRow(
              label: selectedSpecialty ?? 'Speciality',
              onTap: () async {
                final selected = await _showSelectionSheet(
                  title: 'Speciality',
                  options: widget.specialties,
                  selected: selectedSpecialty,
                );
                if (!mounted || selected == null) return;
                setState(() => selectedSpecialty = selected);
              },
            ),
            SizedBox(height: 15.h),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(
                  _FilterSelection(
                    selectedHospital: selectedHospital,
                    selectedSpecialty: selectedSpecialty,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0FAA9A),
                  minimumSize: Size.fromHeight(54.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.909.r),
                  ),
                ),
                child: Text(
                  'Proceed',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showSelectionSheet({
    required String title,
    required List<String> options,
    required String? selected,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.r)),
      builder: (context) {
        return _FilterSelectionSheet(
          title: title,
          options: options,
          selected: selected,
        );
      },
    );
  }
}

class _FilterSelection {
  const _FilterSelection({
    required this.selectedHospital,
    required this.selectedSpecialty,
  });

  final String? selectedHospital;
  final String? selectedSpecialty;
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: const Color(0xFF9BA6A7), width: 0.253),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: const Color(0xFF061E40),
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
              ),
            ),
            Container(
              width: 20.r,
              height: 20.r,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.21),
                  width: 1,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: const Color(0xFF9BA6A7),
                size: 18.r,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterSelectionSheet extends StatefulWidget {
  const _FilterSelectionSheet({
    required this.title,
    required this.options,
    required this.selected,
  });

  final String title;
  final List<String> options;
  final String? selected;

  @override
  State<_FilterSelectionSheet> createState() => _FilterSelectionSheetState();
}

class _FilterSelectionSheetState extends State<_FilterSelectionSheet> {
  late String? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 18.h, 24.w, 18.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36.98.w,
              height: 2.h,
              decoration: BoxDecoration(
                color: const Color(0xFFC4C4C4),
                borderRadius: BorderRadius.circular(100.r),
              ),
            ),
            SizedBox(height: 18.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Filter',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            _FilterRow(label: selected ?? widget.title, onTap: () {}),
            Container(
              constraints: BoxConstraints(maxHeight: 352.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFD0D0D0),
                  width: 0.253,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(4.r),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.35),
                    blurRadius: 17,
                    offset: Offset(0, 4),
                    spreadRadius: -10,
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.options.length,
                itemBuilder: (context, index) {
                  final option = widget.options[index];
                  final isSelected = option == selected;
                  return InkWell(
                    onTap: () => setState(() => selected = option),
                    child: Container(
                      height: 44.h,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFF1F1F1)
                            : Colors.white,
                        border: const Border(
                          bottom: BorderSide(
                            color: Color(0xFFD0D0D0),
                            width: 0.253,
                          ),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        option,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: const Color(0xFF061E40),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(selected),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0FAA9A),
                  minimumSize: Size.fromHeight(57.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.9.r),
                  ),
                ),
                child: Text(
                  'Proceed',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontSize: 12.9.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  const _DoctorCard({required this.data, required this.onBookNowTap});

  final _SurgeryDoctorCardData data;
  final VoidCallback onBookNowTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(8, 97, 156, 0.2),
            blurRadius: 59,
            offset: Offset(0, 18),
            spreadRadius: -27,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(7.8.r),
                child: Container(
                  width: 59.h,
                  height: 59.h,
                  color: const Color(0xFFF4F4F4),
                  child: Image.network(
                    data.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.person_rounded,
                      size: 28.r,
                      color: const Color(0xFFB1B1B1),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.doctorName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF061E40),
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      data.speciality,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFA6A6A6),
                        fontSize: 13.sp,
                      ),
                    ),
                    Text(
                      '${data.experience}  ${data.qualifications}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFA6A6A6),
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 35.r,
                height: 35.r,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.21),
                    width: 1,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: ClipOval(
                  child: Image.network(
                    data.partnerLogoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFF7F7F7)),
                bottom: BorderSide(color: Color(0xFFF7F7F7)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.hospitalName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: const Color(0xFF061E40),
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        data.procedureName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF061E40),
                          fontSize: 14.sp,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Stating from',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF777272),
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      data.price,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF061E40),
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      data.oldPrice,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF979797),
                        decoration: TextDecoration.lineThrough,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onBookNowTap,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF0FAA9A),
                minimumSize: Size.fromHeight(40.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.5.r),
                ),
              ),
              child: Text(
                'Book Now',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SurgeryDoctorCardData {
  const _SurgeryDoctorCardData({
    required this.doctorName,
    required this.speciality,
    required this.experience,
    required this.qualifications,
    required this.hospitalName,
    required this.procedureName,
    required this.price,
    required this.oldPrice,
    required this.imageUrl,
    required this.partnerLogoUrl,
  });

  final String doctorName;
  final String speciality;
  final String experience;
  final String qualifications;
  final String hospitalName;
  final String procedureName;
  final String price;
  final String oldPrice;
  final String imageUrl;
  final String partnerLogoUrl;
}
