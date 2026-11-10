import 'package:flutter/material.dart';

import '../../di/dependency_injection.dart';
import '../../l10n/app_localizations.dart';
import '../domain/entities/city_entity.dart';
import '../domain/repositories/cities_repository.dart';
import 'selected_city_result.dart';
import 'widgets/select_city_dialog_widget.dart';

/// Opens the shared Select City dialog used across Lab, Surgery, Pharmacy, etc.
///
/// Returns the selected city **id and name**, or `null` if dismissed.
/// When [cities] / [cityEntities] are omitted/empty, loads from [CitiesRepository].
Future<SelectedCityResult?> showSelectCityDialog(
  BuildContext context, {
  String? initialSelectedCity,
  List<String>? cities,
  List<CityEntity>? cityEntities,
  String? title,
  String? searchHint,
  bool barrierDismissible = true,
}) {
  final l10n = AppLocalizations.of(context)!;
  return showDialog<SelectedCityResult>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (dialogContext) {
      return PopScope(
        canPop: barrierDismissible,
        child: SelectCityDialogWidget(
          citiesRepository: sl<CitiesRepository>(),
          initialCities: cities,
          initialCityEntities: cityEntities,
          title: title ?? l10n.selectCityTitle,
          searchHint: searchHint ?? l10n.selectCitySearchHint,
          initialSelectedCity: initialSelectedCity,
          emptyMessage: l10n.selectCityEmpty,
          noResultsMessage: l10n.selectCityNoResults,
          showCloseButton: barrierDismissible,
        ),
      );
    },
  );
}
