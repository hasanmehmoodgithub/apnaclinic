import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import 'lab_test_browse_search_field_widget.dart';
import 'lab_test_city_radio_tile_widget.dart';

Future<String?> showLabTestSelectCityDialog(
  BuildContext context, {
  required List<String> cities,
  required String title,
  required String searchHint,
  String? initialSelectedCity,
}) {
  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (dialogContext) {
      return LabTestSelectCityDialogWidget(
        cities: cities,
        title: title,
        searchHint: searchHint,
        initialSelectedCity: initialSelectedCity,
      );
    },
  );
}

/// Centered dialog to pick a city from the catalog city list.
class LabTestSelectCityDialogWidget extends StatefulWidget {
  const LabTestSelectCityDialogWidget({
    super.key,
    required this.cities,
    required this.title,
    required this.searchHint,
    this.initialSelectedCity,
  });

  final List<String> cities;
  final String title;
  final String searchHint;
  final String? initialSelectedCity;

  @override
  State<LabTestSelectCityDialogWidget> createState() =>
      _LabTestSelectCityDialogWidgetState();
}

class _LabTestSelectCityDialogWidgetState
    extends State<LabTestSelectCityDialogWidget> {
  final TextEditingController _query = TextEditingController();
  late String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _selectedCity = widget.initialSelectedCity;
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = widget.cities
        .where(
          (c) => c.toLowerCase().contains(_query.text.trim().toLowerCase()),
        )
        .toList();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.78,
        ),
        decoration: BoxDecoration(
          color: AppColors.clrWhite,
          borderRadius: BorderRadius.circular(16.r),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
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
                        fontSize: 16.sp,
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
                      padding: EdgeInsets.fromLTRB(8.w, 0, 2.w, 4.h),
                      child: Text(
                        '×',
                        style: TextStyle(
                          fontSize: 24.sp,
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
            SizedBox(height: 18.h),
            LabTestBrowseSearchFieldWidget(
              controller: _query,
              hintText: widget.searchHint,
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: 12.h),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final city = filtered[index];
                  final selected = city == _selectedCity;
                  return LabTestCityRadioTileWidget(
                    city: city,
                    selected: selected,
                    onTap: () => context.pop(city),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
