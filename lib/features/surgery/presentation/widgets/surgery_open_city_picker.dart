import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cities/presentation/show_select_city_dialog.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../cubit/surgery_cubit.dart';
import '../surgery_analytics.dart';

/// Opens the shared Select City dialog and applies the result to [SurgeryCubit].
Future<void> openSurgeryCityPicker(BuildContext context) async {
  final cubit = context.read<SurgeryCubit>();
  SurgeryAnalytics.logCityChange(cubit.state.selectedCity);
  final l10n = AppLocalizations.of(context)!;
  final cities = cubit.state.content.cities;

  final picked = await showSelectCityDialog(
    context,
    cities: cities.isNotEmpty ? cities : null,
    initialSelectedCity: cubit.state.selectedCity,
    title: l10n.selectCityTitle,
    searchHint: l10n.selectCitySearchHint,
  );
  if (picked == null || !context.mounted) return;
  await cubit.changeCity(picked.name);
}
