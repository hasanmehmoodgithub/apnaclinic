import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../domain/entities/search_entity.dart';
import 'search_doctor_result_card_widget.dart';
import 'search_lab_result_card_widget.dart';
import 'search_pharmacy_result_card_widget.dart';
import 'search_section_header_pill_widget.dart';
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
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 24.h),
      children: sections
          .map((s) => SearchSectionBlockWidget(section: s, query: query))
          .toList(),
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
                SearchDoctorResultCardWidget(item: item, showHospital: false),
              SearchSectionType.surgeryBooking =>
                SearchDoctorResultCardWidget(item: item, showHospital: true),
              SearchSectionType.pharmacy => SearchPharmacyResultCardWidget(item: item),
              SearchSectionType.laboratoryTests => SearchLabResultCardWidget(item: item),
            },
          ),
        ],
      ),
    );
  }
}
