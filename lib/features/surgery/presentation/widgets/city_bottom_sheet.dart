import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../cubit/surgery_cubit.dart';
import '../cubit/surgery_state.dart';

Future<void> showCityPickerSheet(BuildContext context) {
  final cubit = context.read<SurgeryCubit>();

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
    ),
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: const CityBottomSheet(),
    ),
  );
}

class CityBottomSheet extends StatefulWidget {
  const CityBottomSheet({super.key});

  @override
  State<CityBottomSheet> createState() => _CityBottomSheetState();
}

class _CityBottomSheetState extends State<CityBottomSheet> {
  late String selectedCity;
  String query = '';

  @override
  void initState() {
    super.initState();
    // Read initial selected city directly from the cubit
    selectedCity = context.read<SurgeryCubit>().state.selectedCity;
  }

  @override
  Widget build(BuildContext context) {
    // Rebuild when cubit state's city list changes (e.g., async load)
    return BlocBuilder<SurgeryCubit, SurgeryState>(
      buildWhen: (prev, curr) =>
      prev.content.cities != curr.content.cities,
      builder: (context, state) {
        final cities = state.content.cities
            .where((city) => city.toLowerCase().contains(query.toLowerCase()))
            .toList();

        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 18.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
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
                SizedBox(height: 20.h),

                // Title
                Text(
                  'Select a city',
                  style: TextStyle(
                    color: const Color(0xFF061E40),
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 16.h),

                // Search Field
                Container(
                  height: 52.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    border:
                    Border.all(color: const Color(0xFFE0E0E0), width: 1),
                  ),
                  child: TextField(
                    onChanged: (value) => setState(() => query = value),
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: const Color(0xFF5D758F),
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search by name',
                      hintStyle: TextStyle(
                        color: const Color(0xFF9AAABD),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: Icon(
                          Icons.search_rounded,
                          color: const Color(0xFF9AAABD),
                          size: 22.r,
                        ),
                      ),
                      suffixIconConstraints: BoxConstraints(
                        minWidth: 30.w,
                        minHeight: 30.h,
                      ),
                    ),
                  ),
                ),

                // City List
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 300.h),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: cities.length,
                    itemBuilder: (context, index) {
                      final city = cities[index];
                      final selected = city == selectedCity;
                      return _CityTile(
                        city: city,
                        selected: selected,
                        onTap: () => setState(() => selectedCity = city),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.h),

                // Proceed Button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      context.read<SurgeryCubit>().changeCity(selectedCity);
                      Navigator.of(context).pop();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0FAFA0),
                      minimumSize: Size.fromHeight(50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Text(
                      'Proceed',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CityTile extends StatelessWidget {
  const _CityTile({
    required this.city,
    required this.selected,
    required this.onTap,
  });

  final String city;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: selected ? const Color(0xFFF2F2F2) : Colors.transparent,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      city,
                      style: TextStyle(
                        color: const Color(0xFF061E40),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  _RadioCircle(selected: selected),
                ],
              ),
            ),
            Container(
              height: 1,
              color: const Color(0xFFE8E8E8),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioCircle extends StatelessWidget {
  const _RadioCircle({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.r,
      height: 20.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected
              ? const Color(0xFF061E40)
              : const Color(0xFFBFCAD6),
          width: 1.2,
        ),
      ),
      child: selected
          ? Center(
        child: Container(
          width: 10.r,
          height: 10.r,
          decoration: const BoxDecoration(
            color: Color(0xFF061E40),
            shape: BoxShape.circle,
          ),
        ),
      )
          : null,
    );
  }
}