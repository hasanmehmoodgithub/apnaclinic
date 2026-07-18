import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/app_colors.dart';
import '../../../extensions/screen_util_extensions.dart';
import '../../domain/repositories/cities_repository.dart';
import 'select_city_radio_tile_widget.dart';
import 'select_city_search_field_widget.dart';

/// Centered dialog to pick a city (Lab-style Select City UI).
class SelectCityDialogWidget extends StatefulWidget {
  const SelectCityDialogWidget({
    super.key,
    required this.citiesRepository,
    required this.title,
    required this.searchHint,
    required this.emptyMessage,
    required this.noResultsMessage,
    this.initialCities,
    this.initialSelectedCity,
  });

  final CitiesRepository citiesRepository;
  final List<String>? initialCities;
  final String title;
  final String searchHint;
  final String emptyMessage;
  final String noResultsMessage;
  final String? initialSelectedCity;

  @override
  State<SelectCityDialogWidget> createState() => _SelectCityDialogWidgetState();
}

class _SelectCityDialogWidgetState extends State<SelectCityDialogWidget> {
  final TextEditingController _query = TextEditingController();
  late String? _selectedCity;
  List<String> _cities = const [];
  bool _loading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _selectedCity = widget.initialSelectedCity;
    final provided = widget.initialCities
        ?.map((c) => c.trim())
        .where((c) => c.isNotEmpty)
        .toList(growable: false);
    if (provided != null && provided.isNotEmpty) {
      _cities = provided;
      _loading = false;
    } else {
      _loadCities();
    }
  }

  Future<void> _loadCities() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      await widget.citiesRepository.loadCities();
      if (!mounted) return;
      setState(() {
        _cities = widget.citiesRepository.cityNames;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _cities = widget.citiesRepository.cityNames;
        _loading = false;
        if (_cities.isEmpty) {
          _loadError = widget.emptyMessage;
        }
      });
    }
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _cities
        .where(
          (c) => c.toLowerCase().contains(_query.text.trim().toLowerCase()),
        )
        .toList(growable: false);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.62,
        ),
        decoration: BoxDecoration(
          color: AppColors.clrWhite,
          borderRadius: BorderRadius.circular(14.r),
        ),
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 10.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Text(
                      widget.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.clr060,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => context.pop(),
                    borderRadius: BorderRadius.circular(4.r),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(6.w, 0, 2.w, 2.h),
                      child: Text(
                        '×',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w300,
                          color: AppColors.clr060,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            SelectCitySearchFieldWidget(
              controller: _query,
              hintText: widget.searchHint,
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: 8.h),
            Flexible(child: _buildBody(filtered)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(List<String> filtered) {
    if (_loading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 36.h),
        child: Center(
          child: SizedBox(
            width: 22.r,
            height: 22.r,
            child: const CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.clr0FAA9A,
            ),
          ),
        ),
      );
    }

    if (_loadError != null && _cities.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Center(
          child: Text(
            _loadError!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.clr5D758F,
              fontSize: 12.sp,
            ),
          ),
        ),
      );
    }

    if (_cities.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Center(
          child: Text(
            widget.emptyMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.clr5D758F,
              fontSize: 12.sp,
            ),
          ),
        ),
      );
    }

    if (filtered.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Center(
          child: Text(
            widget.noResultsMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.clr5D758F,
              fontSize: 12.sp,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final city = filtered[index];
        final selected = city == _selectedCity;
        return SelectCityRadioTileWidget(
          city: city,
          selected: selected,
          onTap: () => context.pop(city),
        );
      },
    );
  }
}
