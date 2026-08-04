import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/search_entity.dart';
import '../search_navigation.dart';
import 'search_doctor_result_card_widget.dart';
import 'search_lab_result_card_widget.dart';
import 'search_pharmacy_result_card_widget.dart';
import 'search_section_header_pill_widget.dart';
import 'search_surgery_result_card_widget.dart';
import 'search_widget_utils.dart';

class SearchResultsSectionsWidget extends StatelessWidget {
  const SearchResultsSectionsWidget({
    super.key,
    required this.sections,
    required this.query,
  });

  final List<SearchSectionEntity> sections;
  final String query;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
      children: [
        if (query.trim().isNotEmpty) ...[
          Text(
            l10n.searchForQuery(query.trim()),
            style: TextStyle(
              color: AppColors.clrBlack,
              fontWeight: FontWeight.w800,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 14.h),
        ],
        ...sections.map(
          (s) => SearchSectionBlockWidget(section: s, query: query),
        ),
      ],
    );
  }
}

class SearchSectionBlockWidget extends StatelessWidget {
  const SearchSectionBlockWidget({
    super.key,
    required this.section,
    required this.query,
  });

  final SearchSectionEntity section;
  final String query;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SearchSectionHeaderPillWidget(
            title: section.title,
            iconAsset: sectionIconAsset(section.type),
          ),
          SizedBox(height: 12.h),
          ...section.results.map(
            (item) => switch (section.type) {
              SearchSectionType.doctorConsultation =>
                SearchDoctorResultCardWidget(
                  item: item,
                  onTap: () => openSearchDoctorBooking(context, item),
                ),
              SearchSectionType.surgeryBooking =>
                SearchSurgeryResultCardWidget(
                  item: item,
                  onTap: () => openSearchSurgeryBooking(context, item),
                ),
              SearchSectionType.pharmacy => SearchPharmacyResultCardWidget(
                  item: item,
                  onTap: () => openSearchPharmacyDetail(context, item),
                ),
              SearchSectionType.laboratoryTests => SearchLabResultCardWidget(
                  item: item,
                  onTap: () => openSearchLabBooking(context, item),
                ),
            },
          ),
        ],
      ),
    );
  }
}
