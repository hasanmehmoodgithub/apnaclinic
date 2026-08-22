import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/analytics/analytics_event_keys.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/preference/app_pref.dart';
import '../../../core/preference/app_pref_keys.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/utils/auth_guard.dart';
import '../../consultation/presentation/doctor_consultation_book_doctor_args.dart';
import '../../consultation/presentation/widgets/results_doctor_item.dart';
import '../../lab_test/data/constants/lab_test_catalog_defaults.dart';
import '../../lab_test/presentation/lab_test_route_args.dart';
import '../../pharmacy/domain/entities/pharmacy_medicine_entity.dart';
import '../../surgery/presentation/surgery_patient_details_args.dart';
import '../domain/entities/search_entity.dart';

void _logSearchResultClicked(String type) {
  unawaited(
    sl<AnalyticsService>().logEvent(
      AnalyticsEventKeys.searchResultClicked,
      {AnalyticsParamKeys.type: type},
    ),
  );
}

void openSearchPharmacyDetail(
  BuildContext context,
  SearchResultEntity item,
) {
  _logSearchResultClicked(AnalyticsSearchResultTypeKeys.medicineName);
  final productId = item.id.trim();
  if (productId.isEmpty) return;

  final medicine = PharmacyMedicineEntity(
    id: productId,
    name: item.title,
    description: item.description ?? '',
    imageUrl: item.imageUrl ?? '',
    companyUrl: '',
    price: _parseMoney(item.price),
    oldPrice: 0,
    manufacturer: _manufacturerFromSubtitle(item.subtitle),
    category: '',
    prescriptionRequired: false,
    genericName: item.description ?? '',
    packageType: '',
    indications: '',
    contraIndications: '',
    images: const [],
  );

  context.pushNamed(
    AppRoutes.pharmacy,
    extra: {'selectedMedicine': medicine},
  );
}

void openSearchDoctorBooking(
  BuildContext context,
  SearchResultEntity item,
) {
  _logSearchResultClicked(AnalyticsSearchResultTypeKeys.doctor);
  if (!context.requireLogin()) return;

  final apiId = item.id.trim();
  final publicId = item.publicId?.trim() ?? '';
  if (apiId.isEmpty && publicId.isEmpty) return;

  final doctor = ResultsDoctorItem(
    id: publicId.isNotEmpty ? publicId : apiId,
    apiDoctorId: apiId.isNotEmpty ? apiId : publicId,
    tenantId: item.tenantId?.trim() ?? '',
    name: item.title,
    specialty: item.subtitle,
    experience: item.description ?? '',
    qualification: '',
    fee: item.fee ?? '',
    oldFee: item.oldFee ?? '',
    partner: '',
    rating: item.rating ?? '',
    imageUrl: item.imageUrl ?? '',
    description: item.description ?? '',
    partnerLogoUrl: item.providerLogo ?? '',
  );

  context.pushNamed(
    AppRoutes.consultationBookDoctor,
    extra: DoctorConsultationBookDoctorArgs(doctor: doctor),
  );
}

void openSearchLabBooking(
  BuildContext context,
  SearchResultEntity item,
) {
  _logSearchResultClicked(AnalyticsSearchResultTypeKeys.lab);
  if (!context.requireLogin()) return;

  final l10n = AppLocalizations.of(context)!;
  final testId = int.tryParse(item.id.trim());
  if (testId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.labTestBookingDataUnavailable)),
    );
    return;
  }

  final city =
      (sl<AppPref>().getString(AppPrefKeys.labTestSelectedCity) ?? '')
          .trim();
  if (city.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.labTestPleaseSelectCityFirst)),
    );
    context.pushNamed(AppRoutes.labTest);
    return;
  }

  context.pushNamed(
    AppRoutes.labTestBooking,
    extra: LabTestBookingArgs.pending(
      testId: testId,
      city: city,
      requirementLines: LabTestCatalogDefaults.requirementLines,
      testTitle: item.title,
    ),
  );
}

void openSearchSurgeryBooking(
  BuildContext context,
  SearchResultEntity item,
) {
  _logSearchResultClicked(AnalyticsSearchResultTypeKeys.surgeryDoctor);
  if (!context.requireLogin()) return;

  final surgeryId = item.id.trim();
  final doctorId = item.doctorId?.trim() ?? '';
  final cityId = item.cityId?.trim() ?? '';
  if (surgeryId.isEmpty || doctorId.isEmpty || cityId.isEmpty) return;

  final procedureName =
      (item.packageName ?? item.subtitle).trim().isNotEmpty
          ? (item.packageName ?? item.subtitle).trim()
          : item.title;

  context.pushNamed(
    AppRoutes.surgeryPatientDetails,
    extra: SurgeryPatientDetailsArgs(
      surgeryId: surgeryId,
      cityId: cityId,
      doctorId: doctorId,
      doctorName: item.title,
      speciality: item.subtitle,
      experience: item.description ?? '',
      qualifications: '',
      hospitalName: item.hospital ?? '',
      procedureName: procedureName,
      price: item.fee ?? item.price ?? '',
      oldPrice: item.oldFee ?? '',
      imageUrl: item.imageUrl ?? '',
      partnerLogoUrl: item.providerLogo ?? '',
    ),
  );
}

double _parseMoney(String? value) {
  if (value == null) return 0;
  final digits = value.replaceAll(RegExp(r'[^\d.]'), '');
  return double.tryParse(digits) ?? 0;
}

String _manufacturerFromSubtitle(String subtitle) {
  final trimmed = subtitle.trim();
  if (trimmed.isEmpty) return '';
  final sep = trimmed.indexOf('·');
  if (sep <= 0) return trimmed;
  return trimmed.substring(0, sep).trim();
}
