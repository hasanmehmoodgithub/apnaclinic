import 'package:flutter/material.dart';

import '../../di/dependency_injection.dart';
import '../../l10n/app_localizations.dart';
import '../domain/repositories/cities_repository.dart';
import 'widgets/select_city_dialog_widget.dart';

/// Opens the shared Select City dialog used across Lab, Surgery, Pharmacy, etc.
///
/// Returns the selected city **name**, or `null` if dismissed.
/// When [cities] is omitted/empty, loads from [CitiesRepository] (session cache).
Future<String?> showSelectCityDialog(
  BuildContext context, {
  String? initialSelectedCity,
  List<String>? cities,
  String? title,
  String? searchHint,
}) {
  final l10n = AppLocalizations.of(context)!;
  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (dialogContext) {
      return SelectCityDialogWidget(
        citiesRepository: sl<CitiesRepository>(),
        initialCities: cities,
        title: title ?? l10n.selectCityTitle,
        searchHint: searchHint ?? l10n.selectCitySearchHint,
        initialSelectedCity: initialSelectedCity,
        emptyMessage: l10n.selectCityEmpty,
        noResultsMessage: l10n.selectCityNoResults,
      );
    },
  );
}
