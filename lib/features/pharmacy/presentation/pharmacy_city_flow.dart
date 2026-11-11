import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/cities/domain/entities/city_entity.dart';
import '../../../core/cities/presentation/show_select_city_dialog.dart';
import '../../../core/l10n/app_localizations.dart';
import '../domain/entities/pharmacy_city_entity.dart';
import 'cubit/pharmacy_cubit.dart';

/// Opens the shared Lab/Surgery-style Select City dialog for pharmacy cities.
///
/// Returns `true` if a city is confirmed.
Future<bool> openPharmacyCityPicker(
  BuildContext context, {
  required bool barrierDismissible,
  bool reloadCatalog = true,
}) async {
  final cubit = context.read<PharmacyCubit>();
  final l10n = AppLocalizations.of(context)!;
  final previousCity = cubit.state.selectedCity.trim();
  final hasCartItems = cubit.state.cartItems.isNotEmpty;

  final cities = await _ensurePharmacyCities(cubit);
  if (!context.mounted) return cubit.hasPharmacyCity;

  if (cities.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.pharmacyCitiesLoadError)),
    );
    if (!barrierDismissible && context.canPop()) {
      context.pop();
      return false;
    }
    return cubit.hasPharmacyCity;
  }

  if (hasCartItems && previousCity.isNotEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.pharmacyCityCartSwitchHint(previousCity))),
    );
  }

  final cityEntities = cities
      .map(
        (city) => CityEntity(
          id: city.id.toString(),
          name: city.name,
          slug: city.slug,
        ),
      )
      .toList(growable: false);

  final initial = _initialSelected(cubit);
  final picked = await showSelectCityDialog(
    context,
    cityEntities: cityEntities,
    initialSelectedCity: initial?.name,
    title: l10n.selectCityTitle,
    searchHint: l10n.selectCitySearchHint,
    barrierDismissible: barrierDismissible,
  );

  if (!context.mounted) return cubit.hasPharmacyCity;
  if (picked == null) {
    if (!barrierDismissible) {
      // Back / dismiss on required picker exits pharmacy.
      if (context.canPop()) {
        context.pop();
      }
      return false;
    }
    return cubit.hasPharmacyCity;
  }

  final matched = _matchPharmacyCity(cities, picked.id, picked.name);
  if (matched == null) {
    return cubit.hasPharmacyCity;
  }

  await cubit.confirmPharmacyCity(matched, reloadCatalog: reloadCatalog);
  return true;
}

Future<List<PharmacyCityEntity>> _ensurePharmacyCities(
  PharmacyCubit cubit,
) async {
  if (cubit.state.pharmacyCities.isNotEmpty) {
    return cubit.state.pharmacyCities;
  }
  final result = await cubit.fetchPharmacyCities();
  return result.fold(
    (_) => cubit.state.pharmacyCities,
    (cities) => cities,
  );
}

PharmacyCityEntity? _matchPharmacyCity(
  List<PharmacyCityEntity> cities,
  String pickedId,
  String pickedName,
) {
  final id = int.tryParse(pickedId);
  if (id != null && id > 0) {
    for (final city in cities) {
      if (city.id == id) return city;
    }
  }
  final name = pickedName.trim().toLowerCase();
  for (final city in cities) {
    if (city.name.trim().toLowerCase() == name) return city;
  }
  return null;
}

PharmacyCityEntity? _initialSelected(PharmacyCubit cubit) {
  final id = cubit.state.pharmacyCityId;
  final name = cubit.state.selectedCity.trim();
  if (id == null || id <= 0 || name.isEmpty) return null;
  for (final city in cubit.state.pharmacyCities) {
    if (city.id == id) return city;
  }
  return PharmacyCityEntity(
    id: id,
    name: name,
    partner: cubit.state.pharmacyPartner,
  );
}
